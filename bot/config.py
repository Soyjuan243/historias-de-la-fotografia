import os

# Bot Token (Should be set in environment variables)
TOKEN = os.getenv("DISCORD_TOKEN", "YOUR_BOT_TOKEN_HERE")

# Role IDs
ROLE_ALTO_MANDO_ID = 123456789012345678  # Replace with actual ID
ROLE_ADMIN_ID = 234567890123456789       # Replace with actual ID
ROLE_DEVELOPER_ID = 345678901234567890   # Replace with actual ID

# Status Roles (Optional, but mentioned in prompt)
ROLE_OCUPADO_ID = 456789012345678901
ROLE_DISPONIBLE_ID = 567890123456789012

# Categories
TICKET_CATEGORY_ID = 678901234567890123  # Category where tickets will be created
