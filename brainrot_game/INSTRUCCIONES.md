# Guía de Instalación Manual (Roblox Studio)

Sigue estos pasos EXACTOS para configurar el juego. He dividido los scripts según su tipo y dónde deben ir.

## 1. Preparación del Workspace (EL MAPA)
### Plataformas de Mejora:
1. Crea una Carpeta (`Folder`) en `Workspace` llamada **Platforms**.
2. Pon dentro tus partes (las bases donde se suben los personajes). ¡Asegúrate de que estén Ancladas!

### Puntos de Aparición (Spawn):
1. Crea una o varias partes (`Part`) donde quieras que aparezcan brainrots por el suelo.
2. Nómbralas exactamente: **spawn1**.
3. El juego hará aparecer personajes ahí cada 15 segundos. Si no los agarras en 30 segundos, desaparecerán.

## 2. ReplicatedStorage (Lógica Compartida)
Crea una carpeta llamada **Shared** y dentro pon estos **ModuleScripts**:
*   **BrainrotData**: Datos de los personajes.
*   **Events**: Control de eventos.
*   **Utils**: Formateo de números.

## 3. ServerScriptService (Lógica del Servidor)
### ModuleScripts (Icono azul con interrogación/engranaje):
*   **BrainrotManager**: (Copia el código de `src/server/BrainrotManager.lua`) - Maneja inventario y personajes.

### Scripts (Icono pergamino azul):
*   **Main**: (Copia `src/server/Main.server.lua`) - **¡IMPORTANTE!** Este script activa todo lo demás.
*   **RemoteSetup**: Crea los eventos de red.
*   **PlatformManager**: Configura las bases.
*   **SpawningService**: Maneja la aparición de personajes en el suelo.
*   **ProgressionService**: Genera dinero cada segundo.
*   **DataService**: Guarda el dinero y el inventario.

## 4. StarterPlayer -> StarterPlayerScripts (Lógica del Jugador)
Crea estos **LocalScripts** (Icono pergamino con persona):
*   **InventoryManager**: El menú del inventario.
*   **PlacementManager**: Colocar personajes en las bases.
*   **StatsGuiManager**: Etiquetas flotantes.
*   **InteractionManager**: Botones de Recoger/Mejorar.

---

### ¿Cómo jugar?
1. Verás brainrots apareciendo en las partes llamadas **spawn1**. Acércate y usa la tecla **E** (o toca el botón) para agarrarlos.
2. Abre tu **INVENTARIO**, selecciona uno y haz clic en una base de **Platforms** para ponerlo a trabajar.
3. ¡Genera dinero y mejora tus personajes hasta el nivel 100!

**Nota:** Recuerda activar "Studio Access to API Services" en la configuración del juego para que el guardado funcione.
