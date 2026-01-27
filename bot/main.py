import discord
from discord import app_commands
from discord.ext import commands
import database
import config
import datetime

class MyBot(commands.Bot):
    def __init__(self):
        intents = discord.Intents.default()
        intents.members = True
        intents.message_content = True
        super().__init__(command_prefix="!", intents=intents)

    async def setup_hook(self):
        database.init_db()
        await self.tree.sync()
        print(f"Synced slash commands for {self.user}")

bot = MyBot()

# Helper to check roles
def is_staff(interaction: discord.Interaction):
    staff_roles = [str(config.ROLE_ALTO_MANDO), str(config.ROLE_ADMIN)]
    return any(str(role.id) in staff_roles or role.name in staff_roles for role in interaction.user.roles)

def is_developer(interaction: discord.Interaction):
    target = str(config.ROLE_DEVELOPER)
    return any(str(role.id) == target or role.name == target for role in interaction.user.roles)

def get_role_custom(guild, name_or_id):
    target = str(name_or_id)
    # Try by ID first
    if target.isdigit():
        role = guild.get_role(int(target))
        if role: return role
    # Then by name
    return discord.utils.get(guild.roles, name=target)

# Ticket Commands
class TicketTypeSelect(discord.ui.Select):
    def __init__(self):
        options = [discord.SelectOption(label=t) for t in config.TICKET_TYPES]
        super().__init__(placeholder="Selecciona el tipo de ticket", options=options)

    async def callback(self, interaction: discord.Interaction):
        await interaction.response.send_modal(TicketDescriptionModal(self.values[0]))

class TicketDescriptionModal(discord.ui.Modal, title="Descripción del Ticket"):
    description = discord.ui.TextInput(label="Nombre corto o descripción inicial", style=discord.TextStyle.short)

    def __init__(self, ticket_type):
        super().__init__()
        self.ticket_type = ticket_type

    async def on_submit(self, interaction: discord.Interaction):
        guild = interaction.guild
        user = interaction.user

        # Check if developer
        if is_developer(interaction):
            await interaction.response.send_message("Los developers no pueden crear tickets.", ephemeral=True)
            return

        # Create channel
        overwrites = {
            guild.default_role: discord.PermissionOverwrite(read_messages=False),
            user: discord.PermissionOverwrite(read_messages=True, send_messages=True)
        }

        # Add staff roles to overwrites
        staff_id_or_names = [str(config.ROLE_ALTO_MANDO), str(config.ROLE_ADMIN)]
        staff_roles = [r for r in guild.roles if str(r.id) in staff_id_or_names or r.name in staff_id_or_names]
        for role in staff_roles:
            overwrites[role] = discord.PermissionOverwrite(read_messages=True, send_messages=True)

        channel_name = f"ticket-{self.ticket_type.lower().replace(' ', '-')}-{self.description.value.lower().replace(' ', '-')}"
        # Limit channel name length
        channel_name = channel_name[:100]

        channel = await guild.create_text_channel(name=channel_name, overwrites=overwrites)

        # Save to DB
        database.create_ticket(str(channel.id), self.ticket_type, str(user.id), self.description.value)
        database.add_log(f"Ticket creado: {channel.name} por {user.display_name}")

        await interaction.response.send_message(f"Ticket creado: {channel.mention}", ephemeral=True)

        # Initial message
        embed = discord.Embed(title=f"Nuevo Ticket: {self.ticket_type}", color=discord.Color.blue())
        embed.add_field(name="Creador", value=user.mention)
        embed.add_field(name="Descripción", value=self.description.value)
        embed.add_field(name="Fecha", value=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))

        ping_msg = ""
        for role in staff_roles:
            ping_msg += f"{role.mention} "

        await channel.send(content=ping_msg, embed=embed)

@bot.tree.command(name="crear_ticket", description="Crea un nuevo ticket de soporte o postulación")
async def crear_ticket(interaction: discord.Interaction):
    if is_developer(interaction):
        await interaction.response.send_message("Los developers no pueden crear tickets.", ephemeral=True)
        return

    view = discord.ui.View()
    view.add_item(TicketTypeSelect())
    await interaction.response.send_message("Por favor selecciona el tipo de ticket:", view=view, ephemeral=True)

@bot.tree.command(name="cerrar_ticket", description="Cierra el ticket y finaliza cualquier proyecto activo en él")
async def cerrar_ticket(interaction: discord.Interaction):
    if not is_staff(interaction):
        ticket = database.get_ticket(str(interaction.channel_id))
        if not ticket or ticket[2] != str(interaction.user.id):
            await interaction.response.send_message("No tienes permiso para cerrar este ticket.", ephemeral=True)
            return

    # Auto-finalize project if it exists and is not finished
    project = database.get_project_by_ticket(str(interaction.channel_id))
    exp_info = ""
    if project and project[5] != "finalizado":
        database.update_project_status(project[0], "finalizado")
        dev_id = project[7]
        if dev_id:
            database.update_dev_status(dev_id, 'disponible')
            database.update_work_count(dev_id, 1)
            exp_info = f"\nProyecto **{project[1]}** finalizado automáticamente. Dev liberado (+1 exp)."

            # Update roles
            try:
                member = await interaction.guild.fetch_member(int(dev_id))
                r_disp = get_role_custom(interaction.guild, config.ROLE_DISPONIBLE)
                r_ocup = get_role_custom(interaction.guild, config.ROLE_OCUPADO)
                if r_disp and r_ocup:
                    await member.add_roles(r_disp)
                    await member.remove_roles(r_ocup)
            except:
                pass

    database.close_ticket(str(interaction.channel_id))
    database.add_log(f"Ticket cerrado en canal {interaction.channel_id} por {interaction.user.display_name}")

    await interaction.response.send_message(f"El ticket ha sido cerrado.{exp_info}\nEl canal se eliminará en 5 segundos.")
    await discord.utils.sleep_until(datetime.datetime.now() + datetime.timedelta(seconds=5))
    try:
        await interaction.channel.delete()
    except:
        pass

# Project Commands
@bot.tree.command(name="registrar_proyecto", description="Registra un nuevo proyecto (Solo Staff)")
@app_commands.describe(
    nombre="Nombre del proyecto",
    tipo="Tipo de proyecto",
    cliente="Nombre del cliente",
    prioridad="Prioridad del proyecto"
)
@app_commands.choices(tipo=[
    app_commands.Choice(name=t, value=t) for t in config.PROJECT_TYPES
], prioridad=[
    app_commands.Choice(name=p, value=p) for p in config.PRIORITIES
])
async def registrar_proyecto(interaction: discord.Interaction, nombre: str, tipo: str, cliente: str, prioridad: str):
    if not is_staff(interaction):
        await interaction.response.send_message("Solo el Staff puede registrar proyectos.", ephemeral=True)
        return

    # Check if we are in a ticket channel to associate it
    ticket_id = str(interaction.channel_id)
    ticket = database.get_ticket(ticket_id)

    project_id = database.create_project(nombre, tipo, cliente, prioridad, ticket_id if ticket else None)
    database.add_log(f"Proyecto registrado: {nombre} (ID: {project_id}) por {interaction.user.display_name}")

    await interaction.response.send_message(f"Proyecto **{nombre}** registrado con ID: {project_id}")

@bot.tree.command(name="ver_proyectos", description="Muestra la lista de proyectos (Solo Staff)")
async def ver_proyectos(interaction: discord.Interaction):
    if not is_staff(interaction):
        await interaction.response.send_message("Solo el Staff puede ver los proyectos.", ephemeral=True)
        return

    projects = database.get_projects()
    if not projects:
        await interaction.response.send_message("No hay proyectos registrados.")
        return

    embed = discord.Embed(title="Lista de Proyectos", color=discord.Color.green())
    for p in projects:
        # p = (id, name, type, client, priority, status, ticket_id, assigned_dev)
        assigned_dev = f"<@{p[7]}>" if p[7] else "Ninguno"
        embed.add_field(
            name=f"ID: {p[0]} - {p[1]}",
            value=f"Tipo: {p[2]}\nCliente: {p[3]}\nPrioridad: {p[4]}\nEstado: {p[5]}\nDev: {assigned_dev}",
            inline=False
        )

    await interaction.response.send_message(embed=embed)

@bot.tree.command(name="finalizar_proyecto", description="Finaliza el proyecto, suma experiencia y libera al dev (Solo Staff)")
@app_commands.describe(
    project_id="ID del proyecto (opcional si estás en el canal del ticket)",
    cerrar_ticket="¿Deseas cerrar y eliminar el canal del ticket también?"
)
async def finalizar_proyecto(interaction: discord.Interaction, project_id: int = None, cerrar_ticket: bool = False):
    if not is_staff(interaction):
        await interaction.response.send_message("Solo el Staff puede finalizar proyectos.", ephemeral=True)
        return

    project = None
    if project_id is None:
        # Intentar buscar por canal actual
        project = database.get_project_by_ticket(str(interaction.channel_id))
        if not project:
            await interaction.response.send_message("No se encontró un proyecto asociado a este canal. Por favor, proporciona el ID del proyecto.", ephemeral=True)
            return
        project_id = project[0]
    else:
        conn = database.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM projects WHERE id = ?", (project_id,))
        project = cursor.fetchone()
        conn.close()

    if not project:
        await interaction.response.send_message(f"No se encontró el proyecto con ID {project_id}.", ephemeral=True)
        return

    if project[5] == "finalizado":
        await interaction.response.send_message("Este proyecto ya ha sido finalizado previamente.", ephemeral=True)
        return

    database.update_project_status(project_id, "finalizado")
    database.add_log(f"Proyecto finalizado: {project[1]} (ID: {project_id}) por {interaction.user.display_name}")

    dev_id = project[7] # assigned_dev
    exp_msg = ""
    if dev_id:
        database.update_dev_status(dev_id, 'disponible')
        database.update_work_count(dev_id, 1) # Sumar experiencia
        exp_msg = "\n📈 El desarrollador ha ganado +1 de experiencia y ahora está disponible."

        # Update roles if possible
        try:
            member = await interaction.guild.fetch_member(int(dev_id))
            role_disponible = get_role_custom(interaction.guild, config.ROLE_DISPONIBLE)
            role_ocupado = get_role_custom(interaction.guild, config.ROLE_OCUPADO)
            if role_disponible and role_ocupado:
                await member.add_roles(role_disponible)
                await member.remove_roles(role_ocupado)
        except Exception as e:
            print(f"Error actualizando roles para el dev {dev_id}: {e}")

    await interaction.response.send_message(f"✅ Proyecto **{project[1]}** marcado como finalizado.{exp_msg}")

    if cerrar_ticket:
        await interaction.channel.send("El ticket se cerrará y el canal se eliminará en 5 segundos...")
        database.close_ticket(str(interaction.channel_id))
        await discord.utils.sleep_until(datetime.datetime.now() + datetime.timedelta(seconds=5))
        try:
            await interaction.channel.delete()
        except:
            pass

# Developer Commands
@bot.tree.command(name="registrar_dev", description="Registra a un nuevo desarrollador en la base de datos")
@app_commands.describe(dev="El usuario a registrar", especialidad="Especialidad del desarrollador")
@app_commands.choices(especialidad=[
    app_commands.Choice(name=s, value=s) for s in config.SPECIALTIES
])
async def registrar_dev(interaction: discord.Interaction, dev: discord.Member, especialidad: str):
    if not is_staff(interaction) and interaction.user.id != dev.id:
        await interaction.response.send_message("No tienes permiso para registrar a este desarrollador.", ephemeral=True)
        return

    database.register_dev(str(dev.id), dev.display_name, especialidad)

    # Auto-assign Developer role
    try:
        role_dev = get_role_custom(interaction.guild, config.ROLE_DEVELOPER)
        if role_dev:
            await dev.add_roles(role_dev)
    except Exception as e:
        print(f"Error asignando rol de developer: {e}")

    await interaction.response.send_message(f"Desarrollador {dev.mention} registrado exitosamente como **{especialidad}**.")

@bot.tree.command(name="eliminar_dev", description="Elimina a un desarrollador de la base de datos (Solo Staff)")
@app_commands.describe(dev="El desarrollador a eliminar")
async def eliminar_dev(interaction: discord.Interaction, dev: discord.Member):
    if not is_staff(interaction):
        await interaction.response.send_message("Solo el Staff puede eliminar desarrolladores.", ephemeral=True)
        return

    # Check if exists
    dev_data = database.get_dev(str(dev.id))
    if not dev_data:
        await interaction.response.send_message(f"{dev.mention} no está registrado en la base de datos.", ephemeral=True)
        return

    database.delete_dev(str(dev.id))
    database.add_log(f"Dev {dev.display_name} eliminado por {interaction.user.display_name}")

    # Remove Developer role
    try:
        role_dev = get_role_custom(interaction.guild, config.ROLE_DEVELOPER)
        if role_dev:
            await dev.remove_roles(role_dev)
    except Exception as e:
        print(f"Error removiendo rol de developer: {e}")

    await interaction.response.send_message(f"❌ {dev.mention} ha sido eliminado de la base de datos y se le ha retirado el rol de developer.")

@bot.tree.command(name="asignar_dev", description="Asigna un desarrollador a un proyecto (Solo Staff)")
@app_commands.describe(dev="El desarrollador", project_id="ID del proyecto")
async def asignar_dev(interaction: discord.Interaction, dev: discord.Member, project_id: int):
    if not is_staff(interaction):
        await interaction.response.send_message("Solo el Staff puede asignar desarrolladores.", ephemeral=True)
        return

    # Check if dev is in DB
    dev_data = database.get_dev(str(dev.id))
    if not dev_data:
        await interaction.response.send_message(f"{dev.mention} no está registrado como desarrollador.", ephemeral=True)
        return

    # Check if dev is available
    if dev_data[2] != 'disponible' or not dev_data[3]: # status, active
        await interaction.response.send_message(f"{dev.mention} no está disponible o no está activo.", ephemeral=True)
        return

    # Find project
    conn = database.get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM projects WHERE id = ?", (project_id,))
    project = cursor.fetchone()
    conn.close()

    if not project:
        await interaction.response.send_message(f"No se encontró el proyecto con ID {project_id}.", ephemeral=True)
        return

    # Assign
    database.assign_dev_to_project(project_id, str(dev.id))
    database.update_dev_status(str(dev.id), 'ocupado')
    database.update_project_status(project_id, 'en curso')
    database.add_log(f"Dev {dev.display_name} asignado al proyecto ID {project_id}")

    # Update Roles
    try:
        role_disponible = get_role_custom(interaction.guild, config.ROLE_DISPONIBLE)
        role_ocupado = get_role_custom(interaction.guild, config.ROLE_OCUPADO)
        if role_disponible and role_ocupado:
            await dev.add_roles(role_ocupado)
            await dev.remove_roles(role_disponible)
    except Exception as e:
        print(f"Error actualizando roles para {dev.display_name}: {e}")

    # Add to ticket if exists
    ticket_id = project[6] # ticket_id
    if ticket_id:
        channel = interaction.guild.get_channel(int(ticket_id))
        if channel:
            await channel.set_permissions(dev, read_messages=True, send_messages=True)
            await channel.send(f"Hola {dev.mention}, has sido asignado a este proyecto.")

    await interaction.response.send_message(f"{dev.mention} ha sido asignado al proyecto **{project[1]}**.")

@bot.tree.command(name="perfil_dev", description="Muestra el perfil de un desarrollador")
@app_commands.describe(dev="El desarrollador")
async def perfil_dev(interaction: discord.Interaction, dev: discord.Member):
    dev_data = database.get_dev(str(dev.id))
    if not dev_data:
        await interaction.response.send_message(f"{dev.mention} no está registrado como desarrollador.", ephemeral=True)
        return

    # dev_data = (discord_id, username, status, active, strikes, specialty, work_count)
    embed = discord.Embed(title=f"Perfil de {dev_data[1]}", color=discord.Color.blue())
    embed.add_field(name="Especialidad", value=str(dev_data[5]))
    embed.add_field(name="Estado", value=dev_data[2].capitalize())
    embed.add_field(name="Trabajos Realizados", value=str(dev_data[6]))
    embed.add_field(name="Activo", value="Sí" if dev_data[3] else "No")
    embed.add_field(name="Strikes", value=str(dev_data[4]))

    await interaction.response.send_message(embed=embed)

@bot.tree.command(name="modificar_trabajos", description="Modifica la cantidad de trabajos de un desarrollador (Solo Staff)")
@app_commands.describe(dev="El desarrollador", cantidad="Cantidad a establecer o sumar", modo="Modo de actualización")
@app_commands.choices(modo=[
    app_commands.Choice(name="Sumar", value="add"),
    app_commands.Choice(name="Establecer", value="set")
])
async def modificar_trabajos(interaction: discord.Interaction, dev: discord.Member, cantidad: int, modo: str):
    if not is_staff(interaction):
        await interaction.response.send_message("Solo el Staff puede modificar trabajos.", ephemeral=True)
        return

    is_absolute = (modo == "set")
    database.update_work_count(str(dev.id), cantidad, absolute=is_absolute)

    action = "establecido en" if is_absolute else "aumentado en"
    await interaction.response.send_message(f"Trabajos de {dev.mention} {action} {cantidad}.")

@bot.tree.command(name="devs_disponibles", description="Lista los desarrolladores disponibles")
async def devs_disponibles(interaction: discord.Interaction):
    devs = database.get_available_devs()
    if not devs:
        await interaction.response.send_message("No hay desarrolladores disponibles en este momento.")
        return

    content = "### Desarrolladores Disponibles:\n"
    for d in devs:
        content += f"- <@{d[0]}> ({d[1]})\n"

    await interaction.response.send_message(content)

@bot.tree.command(name="recomendar_dev", description="Recomienda desarrolladores disponibles de forma inteligente")
@app_commands.describe(project_id="ID del proyecto (opcional para recomendación inteligente)")
async def recomendar_dev(interaction: discord.Interaction, project_id: int = None):
    devs = database.get_available_devs()
    if not devs:
        await interaction.response.send_message("No hay desarrolladores disponibles para recomendar.")
        return

    # dev_data = (discord_id, username, status, active, strikes, specialty, work_count)

    project = None
    if project_id:
        conn = database.get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM projects WHERE id = ?", (project_id,))
        project = cursor.fetchone()
        conn.close()

    if project and project[2] == "Juego completo":
        # Intelligent recommendation for large projects: 1 Advanced + 1 New
        # Sort by work_count
        devs_sorted = sorted(devs, key=lambda x: x[6])

        new_dev = devs_sorted[0]
        advanced_dev = devs_sorted[-1]

        if new_dev[0] == advanced_dev[0]:
            await interaction.response.send_message(f"Para este proyecto grande, recomiendo a <@{new_dev[0]}> (es el único disponible).")
        else:
            await interaction.response.send_message(
                f"### Recomendación Inteligente para Proyecto Grande:\n"
                f"🌟 **Líder (Avanzado):** <@{advanced_dev[0]}> ({advanced_dev[6]} trabajos)\n"
                f"👶 **Apoyo (Nuevo):** <@{new_dev[0]}> ({new_dev[6]} trabajos)"
            )
    else:
        # Standard recommendation: fewest strikes, then most work_count
        recommended = min(devs, key=lambda x: (x[4], -x[6]))
        await interaction.response.send_message(f"Te recomiendo a <@{recommended[0]}> ({recommended[5]}, {recommended[6]} trabajos)")

@bot.tree.command(name="strike", description="Añade un strike a un desarrollador (Solo Staff)")
@app_commands.describe(dev="El desarrollador", motivo="Motivo del strike")
async def strike(interaction: discord.Interaction, dev: discord.Member, motivo: str):
    if not is_staff(interaction):
        await interaction.response.send_message("Solo el Staff puede poner strikes.", ephemeral=True)
        return

    dev_data = database.get_dev(str(dev.id))
    if not dev_data:
        await interaction.response.send_message(f"{dev.mention} no está registrado como desarrollador.", ephemeral=True)
        return

    database.add_strike(str(dev.id))

    # Log to a channel or just send message
    await interaction.response.send_message(f"Strike añadido a {dev.mention}. Motivo: {motivo}")

    # Optionally notify the dev
    try:
        await dev.send(f"Has recibido un strike. Motivo: {motivo}")
    except:
        pass

if __name__ == "__main__":
    import os
    dotenv_loaded = False
    try:
        from dotenv import load_dotenv
        load_dotenv()
        dotenv_loaded = True
    except ImportError:
        pass

    token = os.getenv("DISCORD_TOKEN")
    if token:
        bot.run(token)
    else:
        print("--- ERROR DE CONFIGURACIÓN ---")
        print("DISCORD_TOKEN no encontrado.")
        print(f"Directorio de ejecución: {os.getcwd()}")
        print(f"Archivo .env encontrado: {os.path.exists('.env')}")
        if not dotenv_loaded:
            print("AVISO: La librería 'python-dotenv' no está instalada. Ejecuta: pip install python-dotenv")
        print("\nREVISIÓN:")
        print("1. El archivo debe llamarse exactamente .env (sin .txt al final)")
        print("2. El contenido debe ser: DISCORD_TOKEN=TuTokenAqui (sin espacios)")
        print("3. Si usas VS Code, asegúrate de haber guardado el archivo (Ctrl+S)")
