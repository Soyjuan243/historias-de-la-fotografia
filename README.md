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

## Hosting 24/7 (Mantener el bot siempre encendido)

Para que el bot no se apague al cerrar tu laptop, necesitas un **Servidor (Hosting)**. Aquí tienes las mejores opciones:

### Opción 1: Hosting especializado (Recomendado para facilidad)
Servicios como **PebbleHost**, **BisectHosting** o **SparkedHost** ofrecen planes de "Discord Bot Hosting" por ~1 USD al mes. Ellos te dan un panel de control donde subes los archivos y el bot se queda encendido siempre.

### Opción 2: Railway.app o Render (Fácil y moderno)
1. Sube tu código a un repositorio de **GitHub**.
2. Conecta Railway o Render a ese repositorio.
3. Configura la variable `DISCORD_TOKEN` en el panel de control del servicio.
4. El bot se desplegará y encenderá solo.

### Opción 3: VPS (DigitalOcean, AWS, Google Cloud)
Si tienes un servidor Linux (Ubuntu), usa **PM2** para que el bot se reinicie solo si falla:
1. Instala PM2: `npm install pm2 -g`
2. Inicia el bot: `pm2 start bot/main.py --name "discord-bot" --interpreter python3`
3. Para ver el estado: `pm2 status`
