import discord
from discord.ext import commands
from discord import app_commands
import database
import config

class DeveloperCog(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @app_commands.command(name="registrar_dev", description="Registra un nuevo developer en la base de datos")
    @app_commands.describe(dev="El usuario a registrar")
    async def registrar_dev(self, interaction: discord.Interaction, dev: discord.Member):
        user = interaction.user
        is_staff = any(role.id in [config.ROLE_ADMIN_ID, config.ROLE_ALTO_MANDO_ID] for role in user.roles)

        if not is_staff:
            await interaction.response.send_message("No tienes permiso para registrar developers.", ephemeral=True)
            return

        database.register_developer(dev.id, dev.display_name)

        # Add Developer role
        dev_role = interaction.guild.get_role(config.ROLE_DEVELOPER_ID)
        disponible_role = interaction.guild.get_role(config.ROLE_DISPONIBLE_ID)

        if dev_role:
            await dev.add_roles(dev_role)
        if disponible_role:
            await dev.add_roles(disponible_role)

        await interaction.response.send_message(f"Developer {dev.display_name} registrado correctamente.")

    @app_commands.command(name="perfil_dev", description="Muestra el perfil de un developer")
    @app_commands.describe(dev="El developer a consultar")
    async def perfil_dev(self, interaction: discord.Interaction, dev: discord.Member):
        dev_db = database.get_developer(dev.id)
        if not dev_db:
            await interaction.response.send_message("El developer no está registrado.", ephemeral=True)
            return

        d_id, name, status, is_active, strikes = dev_db

        embed = discord.Embed(title=f"Perfil: {name}", color=discord.Color.blue())
        embed.set_thumbnail(url=dev.display_avatar.url)
        embed.add_field(name="Estado", value=status.capitalize())
        embed.add_field(name="Activo", value="Sí" if is_active else "No")
        embed.add_field(name="Strikes", value=f"🟥 {strikes}")

        # If occupied, show project
        if status == 'ocupado':
            # This is a bit complex as we don't have a direct link dev->project in developers table
            # but we have assignments table.
            conn = database.get_connection()
            cursor = conn.cursor()
            cursor.execute('SELECT name FROM projects JOIN assignments ON projects.id = assignments.project_id WHERE assignments.dev_id = ?', (d_id,))
            project = cursor.fetchone()
            conn.close()
            if project:
                embed.add_field(name="Proyecto Actual", value=project[0], inline=False)

        await interaction.response.send_message(embed=embed)

    @app_commands.command(name="devs_disponibles", description="Muestra la lista de developers disponibles")
    async def devs_disponibles(self, interaction: discord.Interaction):
        devs = database.get_available_developers()
        if not devs:
            await interaction.response.send_message("No hay developers disponibles actualmente.", ephemeral=True)
            return

        description = "\n".join([f"• {d[1]} (Strikes: {d[4]})" for d in devs])
        embed = discord.Embed(title="Developers Disponibles", description=description, color=discord.Color.green())
        await interaction.response.send_message(embed=embed)

    @app_commands.command(name="recomendar_dev", description="Recomienda un developer disponible con menos strikes")
    async def recomendar_dev(self, interaction: discord.Interaction):
        devs = database.get_available_developers()
        if not devs:
            await interaction.response.send_message("No hay developers disponibles.", ephemeral=True)
            return

        # Sort by strikes ascending
        recommended = sorted(devs, key=lambda x: x[4])[0]

        await interaction.response.send_message(f"Te recomiendo a **{recommended[1]}** (Strikes: {recommended[4]}).")

async def setup(bot):
    await bot.add_cog(DeveloperCog(bot))
