# 🚀 GUÍA RÁPIDA: ¿DÓNDE PONER LOS SCRIPTS?

Si tienes dudas de dónde va cada cosa, mira esta tabla. Es lo más importante:

| Tipo de Script | Icono en Studio | Ubicación en el Explorer |
| :--- | :--- | :--- |
| **Script Normal** | 📜 Pergamino Azul | **ServerScriptService** |
| **LocalScript** | 📜 con Persona | **StarterPlayer > StarterPlayerScripts** |
| **ModuleScript** | ⚙️ Engranaje Azul | **ReplicatedStorage > Shared** |

---

## 🛠️ PASO A PASO DETALLADO

### 1. Los Scripts Normales (ServerScriptService)
**¿Dónde van?** Busca la carpeta que se llama **ServerScriptService** (está casi al final del Explorer).
**¿Qué hacen?** Son los que controlan el dinero, los niveles y el guardado.

Crea estos 6 scripts ahí dentro (Clic derecho en ServerScriptService -> Insert Object -> Script):
1.  **Main**: El código principal que arranca todo.
2.  **RemoteSetup**: Configura los eventos de red.
3.  **PlatformManager**: Controla las bases de tus personajes.
4.  **SpawningService**: Hace que aparezcan personajes en el suelo.
5.  **ProgressionService**: Maneja la ganancia de dinero.
6.  **DataService**: Guarda el progreso cuando el jugador se va.

*Nota: También debes crear el **ModuleScript** llamado **BrainrotManager** dentro de ServerScriptService.*

---

### 2. Los ModuleScripts (ReplicatedStorage)
**¿Dónde van?** Busca **ReplicatedStorage**, crea una carpeta llamada **Shared** y ponlos ahí.
**¿Qué hacen?** Guardan los datos de los personajes y funciones de utilidad.

Crea estos 3 (Insert Object -> ModuleScript):
*   **BrainrotData**
*   **Events**
*   **Utils**

---

### 3. Los LocalScripts (StarterPlayerScripts)
**¿Dónde van?** Busca la carpeta **StarterPlayer**, abre la flechita, y busca **StarterPlayerScripts**.
**¿Qué hacen?** Controlan lo que el jugador ve (Botones, Inventario, Textos flotantes).

Crea estos 4 (Insert Object -> LocalScript):
*   **InventoryManager**
*   **PlacementManager**
*   **StatsGuiManager**
*   **InteractionManager**

---

### 4. Configuración del Mapa (Workspace)
1.  Crea una Carpeta (`Folder`) llamada **Platforms** en el Workspace. Pon tus bases ahí dentro.
2.  Crea Partes (`Part`) sueltas en el suelo y cámbiales el nombre a **spawn1** para que aparezcan personajes ahí.

---

### 💡 ÚLTIMO PASO OBLIGATORIO:
Para que el dinero se guarde, ve a la pestaña **HOME** -> **Game Settings** -> **Security** y activa:
*   ✅ **Allow HTTP Requests**
*   ✅ **Enable Studio Access to API Services**
