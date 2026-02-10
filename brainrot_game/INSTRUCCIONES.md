# Guía Paso a Paso para Instalar en Roblox Studio

¡Hola! Aquí tienes la explicación súper detallada. Sigue estos pasos uno por uno:

---

## 1. Preparación del Mapa (Workspace)
1.  Busca la ventana **Explorer** (a la derecha).
2.  Haz clic derecho en `Workspace` -> `Insert Object` -> `Folder`. Nómbrala: **Platforms**.
3.  **Bases:** Crea partes (`Part`) dentro de esa carpeta. Son donde irán los personajes. Ponles **Anchored** en Propiedades.
4.  **Spawns:** Crea partes en el suelo llamadas exactamente: **spawn1**.

---

## 2. ReplicatedStorage (Lógica Compartida)
1.  Busca **ReplicatedStorage** en el Explorer.
2.  Clic derecho -> `Insert Object` -> `Folder`. Nómbrala: **Shared**.
3.  Dentro de **Shared**, crea 3 **ModuleScripts** (icono engranaje azul):
    *   **BrainrotData**: Pega su código.
    *   **Events**: Pega su código.
    *   **Utils**: Pega su código.

---

## 3. ServerScriptService (Scripts del Servidor)
Aquí controlamos la "magia" del juego.

### Crea primero este ModuleScript (Icono engranaje azul):
*   **BrainrotManager**: Pega el código de `src/server/BrainrotManager.lua`.

### Ahora crea estos Scripts normales (Icono pergamino azul):
*   **Main**: Pega el de `src/server/Main.server.lua`. (Este activa el Manager).
*   **RemoteSetup**: Pega su código. (Crea la carpeta de eventos).
*   **PlatformManager**: Pega su código. (Inicia las bases).
*   **SpawningService**: Pega su código. (Aparecen personajes en el suelo).
*   **ProgressionService**: Pega su código. (Da dinero).
*   **DataService**: Pega su código. (Guarda el progreso).

---

## 4. StarterPlayer (Scripts del Jugador)
1.  Busca **StarterPlayer** -> **StarterPlayerScripts**.
2.  Crea **LocalScripts** (icono pergamino con personita):
    *   **InventoryManager**: Menú de personajes.
    *   **PlacementManager**: Poner personajes en bases.
    *   **StatsGuiManager**: Textos sobre la cabeza.
    *   **InteractionManager**: Botones Recoger/Mejorar.

---

### CONSEJOS FINALES:
*   **Nombres:** Deben ser EXACTOS (ej. `Platforms` con P mayúscula).
*   **Guardado:** Activa `Game Settings` -> `Security` -> **"Allow HTTP Requests"** y **"Enable Studio Access to API Services"**.
*   **Un solo jugador:** Esta versión está diseñada para que tú pruebes el sistema. En una versión multijugador avanzada, cada jugador tendría su propia zona de plataformas.
