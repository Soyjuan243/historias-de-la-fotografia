import discord
from discord.ext import commands
from discord import app_commands
import database
import config

class ProjectCog(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @app_commands.command(name="registrar_proyecto", description="Registra un nuevo proyecto (Solo Staff)")
    @app_commands.describe(
        nombre="Nombre del proyecto",
        tipo="Tipo de proyecto",
        cliente="Nombre del cliente",
        prioridad="Prioridad del proyecto"
    )
    @app_commands.choices(tipo=[
        app_commands.Choice(name="Juego completo", value="Juego completo"),
        app_commands.Choice(name="Mapa", value="Mapa"),
        app_commands.Choice(name="Script", value="Script"),
        app_commands.Choice(name="Modelado", value="Modelado"),
        app_commands.Choice(name="Mixto", value="Mixto")
    ])
    @app_commands.choices(prioridad=[
        app_commands.Choice(name="Baja", value="baja"),
        app_commands.Choice(name="Media", value="media"),
        app_commands.Choice(name="Alta", value="alta")
    ])
    async def registrar_proyecto(self, interaction: discord.Interaction, nombre: str, tipo: str, cliente: str, prioridad: str):
        guild = interaction.guild
        user = interaction.user
        is_staff = any(role.id in [config.ROLE_ADMIN_ID, config.ROLE_ALTO_MANDO_ID] for role in user.roles)

        if not is_staff:
            await interaction.response.send_message("No tienes permiso para registrar proyectos.", ephemeral=True)
            return

        # 1. Create Project in DB
        project_id = database.create_project(nombre, tipo, cliente, prioridad)

        # 2. Create associated Ticket Channel (as per spec: "Todo proyecto tiene ticket asociado")
        overwrites = {
            guild.default_role: discord.PermissionOverwrite(read_messages=False),
        }
        # Add Staff roles
        admin_role = guild.get_role(config.ROLE_ADMIN_ID)
        alto_mando_role = guild.get_role(config.ROLE_ALTO_MANDO_ID)
        if admin_role: overwrites[admin_role] = discord.PermissionOverwrite(read_messages=True, send_messages=True)
        if alto_mando_role: overwrites[alto_mando_role] = discord.PermissionOverwrite(read_messages=True, send_messages=True)

        channel_name = f"ticket-proyecto-{nombre[:15].replace(' ', '-')}"
        category = guild.get_channel(config.TICKET_CATEGORY_ID)

        channel = await guild.create_text_channel(
            name=channel_name,
            overwrites=overwrites,
            category=category
        )

        # 3. Create Ticket in DB and link
        ticket_id = database.create_ticket(channel.id, "Proyecto", user.id)
        database.link_ticket_project(ticket_id, project_id)

        # Initial message in channel
        embed = discord.Embed(title=f"Proyecto: {nombre}", color=discord.Color.gold())
        embed.add_field(name="Tipo", value=tipo)
        embed.add_field(name="Cliente", value=cliente)
        embed.add_field(name="Prioridad", value=prioridad.capitalize())
        embed.add_field(name="Estado", value="Pendiente")

        ping_msg = f"{admin_role.mention if admin_role else '@Admin'} {alto_mando_role.mention if alto_mando_role else '@Alto Mando'}"
        await channel.send(content=ping_msg, embed=embed)

        await interaction.response.send_message(f"Proyecto **{nombre}** registrado con ID: {project_id} y canal {channel.mention}.", ephemeral=True)

    @app_commands.command(name="ver_proyectos", description="Muestra la lista de proyectos")
    @app_commands.describe(estado="Filtrar por estado (pendiente, en curso, finalizado)")
    async def ver_proyectos(self, interaction: discord.Interaction, estado: str = None):
        projects = database.get_projects(estado)
        if not projects:
            await interaction.response.send_message("No se encontraron proyectos.", ephemeral=True)
            return

        embed = discord.Embed(title="Lista de Proyectos", color=discord.Color.green())
        for p in projects:
            p_id, name, p_type, client, priority, p_status, t_id = p
            embed.add_field(
                name=f"ID: {p_id} | {name}",
                value=f"Tipo: {p_type}\nCliente: {client}\nPrioridad: {priority}\nEstado: {p_status}",
                inline=False
            )

        await interaction.response.send_message(embed=embed)

    @app_commands.command(name="asignar_dev", description="Asigna un developer a un proyecto")
    @app_commands.describe(dev="El developer a asignar", proyecto_id="ID del proyecto o nombre")
    async def asignar_dev(self, interaction: discord.Interaction, dev: discord.Member, proyecto_id: str):
        user = interaction.user
        is_staff = any(role.id in [config.ROLE_ADMIN_ID, config.ROLE_ALTO_MANDO_ID] for role in user.roles)

        if not is_staff:
            await interaction.response.send_message("No tienes permiso para asignar developers.", ephemeral=True)
            return

        # Try to find project by ID or Name
        project = None
        if proyecto_id.isdigit():
            project = database.get_project(int(proyecto_id))

        if not project:
            project = database.get_project_by_name(proyecto_id)

        if not project:
            await interaction.response.send_message("Proyecto no encontrado.", ephemeral=True)
            return

        p_id, p_name, _, _, _, p_status, t_id = project

        # Check dev in DB
        dev_db = database.get_developer(dev.id)
        if not dev_db:
            await interaction.response.send_message("El usuario no está registrado como developer.", ephemeral=True)
            return

        # Check availability
        if dev_db[2] == 'ocupado': # status is 3rd column
            await interaction.response.send_message(f"{dev.display_name} ya está ocupado en otro proyecto.", ephemeral=True)
            return

        if dev_db[3] == 0: # is_active is 4th column
            await interaction.response.send_message(f"{dev.display_name} no está activo.", ephemeral=True)
            return

        # Perform assignment
        success, msg = database.assign_developer(dev.id, p_id)
        if not success:
            await interaction.response.send_message(msg, ephemeral=True)
            return

        # Update Discord roles
        ocupado_role = interaction.guild.get_role(config.ROLE_OCUPADO_ID)
        disponible_role = interaction.guild.get_role(config.ROLE_DISPONIBLE_ID)

        if ocupado_role:
            await dev.add_roles(ocupado_role)
        if disponible_role:
            await dev.remove_roles(disponible_role)

        # Add dev to ticket channel
        ticket = database.get_ticket_by_channel(interaction.channel.id)
        # We assume the command is run in the ticket channel or we find it from project
        target_channel_id = t_id if t_id else interaction.channel.id
        channel = interaction.guild.get_channel(target_channel_id)

        if channel:
            await channel.set_permissions(dev, read_messages=True, send_messages=True)
            await channel.send(f"🛠️ {dev.mention} ha sido asignado al proyecto **{p_name}**.")

        await interaction.response.send_message(f"Developer {dev.display_name} asignado al proyecto {p_name}.")

    @app_commands.command(name="finalizar_proyecto", description="Marca un proyecto como finalizado")
    @app_commands.describe(proyecto_id="ID del proyecto")
    async def finalizar_proyecto(self, interaction: discord.Interaction, proyecto_id: int):
        user = interaction.user
        is_staff = any(role.id in [config.ROLE_ADMIN_ID, config.ROLE_ALTO_MANDO_ID] for role in user.roles)

        if not is_staff:
            await interaction.response.send_message("No tienes permiso para finalizar proyectos.", ephemeral=True)
            return

        project = database.get_project(proyecto_id)
        if not project:
            await interaction.response.send_message("Proyecto no encontrado.", ephemeral=True)
            return

        # Update project status
        database.update_project_status(proyecto_id, 'finalizado')

        # Free the developer
        assignment = database.get_project_assignment(proyecto_id)
        if assignment:
            dev_id = assignment[0]
            database.unassign_developer(dev_id, proyecto_id)

            # Update Discord roles
            dev_member = interaction.guild.get_member(dev_id)
            if dev_member:
                ocupado_role = interaction.guild.get_role(config.ROLE_OCUPADO_ID)
                disponible_role = interaction.guild.get_role(config.ROLE_DISPONIBLE_ID)
                if ocupado_role:
                    await dev_member.remove_roles(ocupado_role)
                if disponible_role:
                    await dev_member.add_roles(disponible_role)

        await interaction.response.send_message(f"Proyecto {proyecto_id} finalizado y developer liberado.")

async def setup(bot):
    await bot.add_cog(ProjectCog(bot))
