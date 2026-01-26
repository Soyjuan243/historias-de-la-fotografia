# Bot de Discord - Guía de Configuración

Este bot está diseñado para gestionar desarrolladores, proyectos y tickets en un servidor de Discord.

## Requisitos Previos

1. **Python 3.8+**: Asegúrate de tener Python instalado. Puedes descargarlo de [python.org](https://www.python.org/).
2. **Token de Bot de Discord**: Crea una aplicación en el [Discord Developer Portal](https://discord.com/developers/applications), añade un bot y copia el Token.
3. **Intents de Discord**: En el panel de control del bot (Developer Portal), activa los **Privileged Gateway Intents**:
   - Presence Intent
   - Server Members Intent
   - Message Content Intent

## Configuración en Visual Studio Code

1. **Abrir la carpeta**: Abre la carpeta raíz del proyecto en VS Code.
2. **Crear un Entorno Virtual (Recomendado)**:
   Abre la terminal en VS Code (`Ctrl + ` `) y ejecuta:
   ```bash
   python -m venv venv
   ```
   Actívalo:
   - Windows: `.\venv\Scripts\activate`
   - Mac/Linux: `source venv/bin/activate`

3. **Instalar dependencias**:
   ```bash
   pip install discord.py python-dotenv
   ```

4. **Configurar el Token**:
   Para que el bot funcione, necesitas configurar el token de Discord de una de las siguientes maneras:

   - **Opción A (Archivo .env - Recomendada)**:
     1. Crea un archivo llamado `.env` en la carpeta raíz del proyecto.
     2. Añade la siguiente línea dentro del archivo:
        ```text
        DISCORD_TOKEN=TU_TOKEN_AQUI
        ```
     3. Asegúrate de haber instalado `python-dotenv` (incluido en el paso 3).

   - **Opción B (Variable de Entorno en Terminal)**:
     - Windows (PowerShell): `$env:DISCORD_TOKEN="TU_TOKEN_AQUI"`
     - Linux/Mac/Git Bash: `export DISCORD_TOKEN="TU_TOKEN_AQUI"`

5. **Configurar Roles**:
   Asegúrate de que los nombres de los roles en `bot/config.py` coincidan exactamente con los de tu servidor de Discord.

## Ejecución

Para iniciar el bot, ejecuta desde la carpeta raíz:
```bash
python bot/main.py
```

## Comandos Disponibles
El bot utiliza comandos de barra (`/`). Asegúrate de que el bot tenga permisos de `Administrator` o permisos específicos para crear canales y gestionar roles.

- `/crear_ticket`: Inicia el flujo de creación de tickets.
- `/registrar_proyecto`: (Staff) Registra un nuevo proyecto.
- `/asignar_dev`: (Staff) Asigna un desarrollador disponible a un proyecto.
- `/registrar_dev`: Registra a un usuario como desarrollador en el sistema.
- `/devs_disponibles`: Muestra quién puede trabajar.
