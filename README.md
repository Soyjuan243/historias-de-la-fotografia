# Discord Bot de Gestión de Developers y Proyectos

Este es un bot de Discord diseñado para gestionar equipos de desarrolladores, proyectos y tickets de soporte.

## Características

- **Sistema de Tickets**: Creación automática de canales privados con permisos controlados.
- **Registro de Proyectos**: Seguimiento de proyectos, prioridades y estados.
- **Gestión de Developers**: Registro de perfiles, control de disponibilidad y sistema de strikes.
- **Asignación Inteligente**: Vinculación de desarrolladores a proyectos y tickets.

## Instalación

1. Clona el repositorio.
2. Instala las dependencias:
   ```bash
   pip install discord.py
   ```
3. Configura las variables en `bot/config.py`:
   - `TOKEN`: El token de tu bot de Discord.
   - `ROLE_ADMIN_ID`: ID del rol de Administrador.
   - `ROLE_ALTO_MANDO_ID`: ID del rol de Alto Mando.
   - `ROLE_DEVELOPER_ID`: ID del rol de Developer.
   - `TICKET_CATEGORY_ID`: ID de la categoría donde se crearán los tickets.

## Comandos Principales

### Tickets
- `/crear_ticket <tipo> <descripcion>`: Crea un canal privado para el ticket.
- `/cerrar_ticket`: Cierra y elimina el canal del ticket (Solo Staff).

### Proyectos
- `/registrar_proyecto <nombre> <tipo> <cliente> <prioridad>`: Registra un nuevo proyecto.
- `/ver_proyectos [estado]`: Lista los proyectos registrados.
- `/asignar_dev <@dev> <proyecto_id>`: Asigna un desarrollador a un proyecto y le da acceso al ticket.
- `/finalizar_proyecto <proyecto_id>`: Marca el proyecto como terminado y libera al desarrollador.

### Developers
- `/registrar_dev <@usuario>`: Registra a un usuario como desarrollador.
- `/perfil_dev <@usuario>`: Muestra información detallada del desarrollador.
- `/devs_disponibles`: Lista los desarrolladores que no están en un proyecto.
- `/recomendar_dev`: Sugiere al desarrollador disponible con menos strikes.

### Moderación
- `/strike <@dev> <motivo>`: Aplica una sanción al desarrollador.

## Estructura del Proyecto

- `bot/main.py`: Punto de entrada del bot.
- `bot/database.py`: Lógica de base de datos (SQLite).
- `bot/config.py`: Configuraciones y constantes.
- `bot/cogs/`: Extensiones del bot divididas por funcionalidad.
- `tests/`: Pruebas unitarias para la lógica de base de datos.
