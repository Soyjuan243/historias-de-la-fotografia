import discord
from discord.ext import commands
import os
import asyncio
from database import init_db
import config

class MyBot(commands.Bot):
    def __init__(self):
        intents = discord.Intents.default()
        intents.members = True
        intents.message_content = True
        super().__init__(command_prefix="/", intents=intents)

    async def setup_hook(self):
        # Initialize Database
        init_db()
        print("Database initialized.")

        # Load Cogs
        cogs_dir = os.path.join(os.path.dirname(__file__), 'cogs')
        for filename in os.listdir(cogs_dir):
            if filename.endswith(".py") and filename != "__init__.py":
                await self.load_extension(f"cogs.{filename[:-3]}")
                print(f"Loaded extension: {filename}")

    async def on_ready(self):
        print(f"Logged in as {self.user} (ID: {self.user.id})")
        print("------")

async def main():
    bot = MyBot()
    if config.TOKEN == "YOUR_BOT_TOKEN_HERE":
        print("Warning: Bot token is not configured in config.py or environment variables.")
        return
    await bot.start(config.TOKEN)

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
