# Guía de Instalación Manual (Roblox Studio)

Sigue estos pasos EXACTOS para configurar el juego. He dividido los scripts según su tipo y dónde deben ir.

## 1. Preparación del Workspace (EL MAPA)
1. En el **Explorer**, haz clic derecho en `Workspace` -> `Insert Object` -> `Folder`.
2. Nómbrala exactamente: **Platforms**.
3. **Tú pones las bases:** Dentro de esa carpeta, crea tus plataformas (usa `Part`).
   - Puedes poner las que quieras. El script las detectará automáticamente.
   - Asegúrate de que estén Ancladas (`Anchored = true`).

## 2. ReplicatedStorage (Lógica Compartida)
Crea una carpeta llamada **Shared** y dentro pon estos **ModuleScripts**:

*   **BrainrotData**: (Copia el código de `src/shared/BrainrotData.lua`)
*   **Events**: (Copia el código de `src/shared/Events.lua`)
*   **Utils**: (Copia el código de `src/shared/Utils.lua`)

## 3. ServerScriptService (Lógica del Servidor)
Crea estos **Scripts** (Scripts normales, icono pergamino azul):

*   **RemoteSetup**: Crea los eventos de red (¡Muy importante!).
*   **PlatformManager**: Configura las bases que tú pusiste en el mapa.
*   **BrainrotManager**: Maneja la colocación y mejoras de los brainrots.
*   **ProgressionService**: Genera dinero cada segundo.
*   **DataService**: Guarda el dinero y el inventario automáticamente.

## 4. StarterPlayer -> StarterPlayerScripts (Lógica del Jugador)
Crea estos **LocalScripts** (Icono pergamino con una persona):

*   **InventoryManager**: Crea el botón y el menú de tu inventario.
*   **PlacementManager**: Te permite hacer clic en una base para poner el brainrot seleccionado.
*   **StatsGuiManager**: Muestra la vida/dinero flotando sobre los personajes.
*   **InteractionManager**: Muestra los botones de "Recoger" y "Mejorar" cuando estás cerca.

---

### ¿Cómo jugar?
1. Verás un botón de **INVENTARIO**. Al empezar, ya tienes 2 brainrots de prueba.
2. Abre el inventario y haz clic en uno.
3. Haz clic en una de las plataformas que pusiste en el mapa.
4. ¡Listo! Empezará a generar dinero. Acércate para recogerlo o mejorarlo.

### Resumen de tipos de objetos:
| Nombre | Tipo de Objeto | Ubicación |
| :--- | :--- | :--- |
| `Platforms` | **Folder** | Workspace |
| `Shared` | **Folder** | ReplicatedStorage |
| `InventoryManager` | **LocalScript** | StarterPlayerScripts |
| `RemoteSetup` | **Script** | ServerScriptService |
| `BrainrotData` | **ModuleScript** | ReplicatedStorage > Shared |

**Nota sobre DataStores:** El juego guarda tu dinero e inventario. Para que funcione en Studio, recuerda activar **"Enable Studio Access to API Services"** en Game Settings > Security.
