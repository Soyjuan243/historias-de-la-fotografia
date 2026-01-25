import discord
from discord.ext import commands
from discord import app_commands
import database
import config

class ModerationCog(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @app_commands.command(name="strike", description="Añade un strike a un developer")
    @app_commands.describe(dev="El developer a sancionar", motivo="Motivo del strike")
    async def strike(self, interaction: discord.Interaction, dev: discord.Member, motivo: str):
        user = interaction.user
        is_staff = any(role.id in [config.ROLE_ADMIN_ID, config.ROLE_ALTO_MANDO_ID] for role in user.roles)

        if not is_staff:
            await interaction.response.send_message("No tienes permiso para aplicar strikes.", ephemeral=True)
            return

        dev_db = database.get_developer(dev.id)
        if not dev_db:
            await interaction.response.send_message("El usuario no está registrado como developer.", ephemeral=True)
            return

        database.add_strike(dev.id)

        # Log strike
        # In a real bot, you might want a strikes table for history

        embed = discord.Embed(title="Strike Aplicado", color=discord.Color.red())
        embed.add_field(name="Developer", value=dev.mention)
        embed.add_field(name="Motivo", value=motivo)
        embed.add_field(name="Total Strikes", value=f"{dev_db[4] + 1}")

        await interaction.response.send_message(embed=embed)

        # Optionally DM the developer
        try:
            await dev.send(f"Has recibido un strike por: {motivo}")
        except:
            pass

async def setup(bot):
    await bot.add_cog(ModerationCog(bot))
