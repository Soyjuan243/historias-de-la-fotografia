# 🚀 GUÍA RÁPIDA: ¿DÓNDE PONER LOS SCRIPTS?

| Tipo de Script | Icono en Studio | Ubicación en el Explorer |
| :--- | :--- | :--- |
| **Script Normal** | 📜 Pergamino Azul | **ServerScriptService** |
| **LocalScript** | 📜 con Persona | **StarterPlayer > StarterPlayerScripts** |
| **ModuleScript** | ⚙️ Engranaje Azul | **Shared** o **ServerScriptService** |

---

## 🎨 NUEVO: CÓMO USAR TUS MODELOS
Si tienes modelos propios para los personajes (en lugar de bloques), haz esto:

1.  Busca **ReplicatedStorage** en el Explorer.
2.  Crea una carpeta llamada **Models**.
3.  Pon tus modelos dentro.
4.  **¡IMPORTANTE!** Cambia el nombre de los modelos para que coincidan con la ID:
    *   **Common1** (para el Skibidi Toilet)
    *   **Common2** (para el Sigma Boy)
    *   ... hasta el **Common5**, **Secret1** y **Secret2**.

*Nota: Si el script no encuentra un modelo con ese nombre, usará un bloque amarillo por defecto.*

---

## 🛠️ PASO A PASO DETALLADO

### 1. ServerScriptService (Scripts del Servidor)
Crea estos scripts (Botón derecho -> Insert Object):
*   **BrainrotManager** (¡Este debe ser un **ModuleScript**!)
*   **Main** (Script normal)
*   **RemoteSetup** (Script normal)
*   **PlatformManager** (Script normal)
*   **SpawningService** (Script normal)
*   **ProgressionService** (Script normal)
*   **DataService** (Script normal)

### 2. ReplicatedStorage > Shared (Lógica Compartida)
Crea una carpeta **Shared** y pon estos 3 **ModuleScripts**:
*   **BrainrotData**, **Events**, **Utils**.

### 3. StarterPlayerScripts (Scripts del Jugador)
Crea estos 4 **LocalScripts**:
*   **InventoryManager**, **PlacementManager**, **StatsGuiManager**, **InteractionManager**.

---

### 💡 ÚLTIMO PASO OBLIGATORIO:
Para que el dinero se guarde, ve a la pestaña **HOME** -> **Game Settings** -> **Security** y activa:
*   ✅ **Allow HTTP Requests**
*   ✅ **Enable Studio Access to API Services**
