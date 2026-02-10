# Guía de Instalación en Roblox Studio

Si no estás usando Rojo, aquí tienes cómo organizar los archivos manualmente en el Explorer de Roblox Studio:

## 1. ReplicatedStorage (Lógica Compartida)
Crea una carpeta llamada **Shared** y dentro coloca estos **ModuleScripts**:

*   **BrainrotData**: (Contenido de `src/shared/BrainrotData.lua`)
*   **Events**: (Contenido de `src/shared/Events.lua`)
*   **Utils**: (Contenido de `src/shared/Utils.lua`)

También crea una carpeta llamada **Remotes** directamente en ReplicatedStorage (el script `RemoteSetup` lo hará automáticamente, pero puedes crearla tú).

## 2. ServerScriptService (Lógica del Servidor)
Crea estos **Scripts** (Scripts normales, no LocalScripts):

*   **PlatformManager**: Maneja la creación de las 5 plataformas.
*   **BrainrotManager**: Maneja las mejoras y la lógica de los personajes.
*   **ProgressionService**: Maneja la generación de dinero por segundo.
*   **DataService**: Maneja el guardado de datos (DataStore).
*   **RemoteSetup**: Crea los eventos necesarios.

## 3. StarterPlayer -> StarterPlayerScripts (Lógica del Jugador)
Crea estos **LocalScripts**:

*   **StatsGuiManager**: Crea y actualiza las etiquetas sobre la cabeza de los brainrots.
*   **InteractionManager**: Muestra la interfaz de botones (Recoger/Mejorar).

## 4. Workspace
Crea una carpeta llamada **Platforms** directamente en el Workspace. Aquí es donde el script `PlatformManager` pondrá las plataformas.

---

### Resumen de Nombres y Tipos:
| Nombre del Archivo | Tipo en Roblox | Ubicación Recomendada |
| :--- | :--- | :--- |
| `BrainrotData` | ModuleScript | ReplicatedStorage > Shared |
| `Events` | ModuleScript | ReplicatedStorage > Shared |
| `Utils` | ModuleScript | ReplicatedStorage > Shared |
| `PlatformManager` | Script | ServerScriptService |
| `BrainrotManager` | Script | ServerScriptService |
| `ProgressionService`| Script | ServerScriptService |
| `DataService` | Script | ServerScriptService |
| `RemoteSetup` | Script | ServerScriptService |
| `StatsGuiManager` | LocalScript | StarterPlayerScripts |
| `InteractionManager`| LocalScript | StarterPlayerScripts |
