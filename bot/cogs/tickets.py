import discord
from discord.ext import commands
from discord import app_commands
import database
import config

class TicketType(discord.Enum):
    postulacion = "Postulación"
    proyecto = "Proyecto"
    servicio = "Servicio"
    otro = "Otro"

class TicketCog(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @app_commands.command(name="crear_ticket", description="Crea un nuevo ticket de soporte o proyecto")
    @app_commands.describe(tipo="Tipo de ticket", descripcion="Breve descripción del ticket")
    async def crear_ticket(self, interaction: discord.Interaction, tipo: TicketType, descripcion: str):
        guild = interaction.guild
        user = interaction.user

        # Check roles if necessary (Spec says devs don't create tickets, but maybe users do?)
        # For now, let's assume anyone can create, but only staff sees.
        # Actually spec says: "❌ Los developers NO crean tickets"
        # So I should check if user has Developer role and NOT Admin/Alto Mando.

        is_staff = any(role.id in [config.ROLE_ADMIN_ID, config.ROLE_ALTO_MANDO_ID] for role in user.roles)
        is_dev = any(role.id == config.ROLE_DEVELOPER_ID for role in user.roles)

        if is_dev and not is_staff:
            await interaction.response.send_message("Los developers no pueden crear tickets.", ephemeral=True)
            return

        # Create permissions
        overwrites = {
            guild.default_role: discord.PermissionOverwrite(read_messages=False),
            user: discord.PermissionOverwrite(read_messages=True, send_messages=True),
        }

        # Add Staff roles
        admin_role = guild.get_role(config.ROLE_ADMIN_ID)
        alto_mando_role = guild.get_role(config.ROLE_ALTO_MANDO_ID)

        if admin_role:
            overwrites[admin_role] = discord.PermissionOverwrite(read_messages=True, send_messages=True)
        if alto_mando_role:
            overwrites[alto_mando_role] = discord.PermissionOverwrite(read_messages=True, send_messages=True)

        # Create channel
        channel_name = f"ticket-{tipo.name}-{descripcion[:15].replace(' ', '-')}"
        category = guild.get_channel(config.TICKET_CATEGORY_ID)

        channel = await guild.create_text_channel(
            name=channel_name,
            overwrites=overwrites,
            category=category
        )

        # Save to DB
        ticket_id = database.create_ticket(channel.id, tipo.value, user.id)

        # Initial message
        embed = discord.Embed(title=f"Ticket: {tipo.value}", color=discord.Color.blue())
        embed.add_field(name="Creador", value=user.mention)
        embed.add_field(name="Descripción", value=descripcion)
        embed.add_field(name="Estado", value="Abierto")

        ping_msg = f"{admin_role.mention if admin_role else '@Admin'} {alto_mando_role.mention if alto_mando_role else '@Alto Mando'}"

        await channel.send(content=ping_msg, embed=embed)
        await interaction.response.send_message(f"Ticket creado en {channel.mention}", ephemeral=True)

    @app_commands.command(name="cerrar_ticket", description="Cierra el ticket actual")
    async def cerrar_ticket(self, interaction: discord.Interaction):
        channel = interaction.channel
        ticket = database.get_ticket_by_channel(channel.id)

        if not ticket:
            await interaction.response.send_message("Este canal no es un ticket válido.", ephemeral=True)
            return

        # Only staff can close?
        user = interaction.user
        is_staff = any(role.id in [config.ROLE_ADMIN_ID, config.ROLE_ALTO_MANDO_ID] for role in user.roles)

        if not is_staff:
            await interaction.response.send_message("Solo el personal puede cerrar tickets.", ephemeral=True)
            return

        database.close_ticket(channel.id)
        await interaction.response.send_message("Ticket cerrado. El canal se eliminará en 10 segundos.")

        await discord.utils.sleep_until(discord.utils.utcnow() + discord.utils.timedelta(seconds=10))
        await channel.delete()

async def setup(bot):
    await bot.add_cog(TicketCog(bot))
