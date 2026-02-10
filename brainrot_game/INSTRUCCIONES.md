# 🚀 GUÍA DEFINITIVA: BRAINROT GAME (INVENTARIO Y 'E')

---

## 🛠️ CAMBIOS CLAVE (SISTEMA DE PRODUCCIÓN)
1.  **Mochila de Roblox (Backpack):** Ya no hay menús lentos. Los personajes que recojas o compres aparecerán directamente en tu inventario de herramientas (el de abajo).
2.  **Auto-Equipamiento:** Al agarrar un personaje del suelo, **se te pondrá en la mano solo**.
3.  **Colocar con "E":**
    *   Sujeta al personaje en tu mano (equípalo).
    *   Camina hacia una base vacía.
    *   Presiona **E** para colocarlo.
4.  **Multijugador Seguro:** Solo TÚ puedes ver los botones de mejora en TUS personajes, y solo tú puedes cobrar de TUS bases.
5.  **Cobro Táctil:** Pasa por encima de la plataforma verde para recibir tu dinero.

---

## 🎨 PREPARACIÓN DEL MAPA
*   **spawn1:** Crea bloques llamados `spawn1` donde quieras que aparezcan personajes.
*   **Platforms:** Mete tus bases en una carpeta llamada `Platforms`.

---

## 🚀 UBICACIÓN DE LOS SCRIPTS

| Script | Tipo | Ubicación |
| :--- | :--- | :--- |
| **BrainrotManager** | ModuleScript | ServerScriptService |
| **Main** | Script | ServerScriptService |
| **RemoteSetup** | Script | ServerScriptService |
| **PlatformManager** | Script | ServerScriptService |
| **SpawningService** | Script | ServerScriptService |
| **ProgressionService** | Script | ServerScriptService |
| **DataService** | Script | ServerScriptService |
| **PlacementManager** | LocalScript | StarterPlayerScripts |
| **StatsGuiManager** | LocalScript | StarterPlayerScripts |
| **InteractionManager**| LocalScript | StarterPlayerScripts |

---

### 💡 NOTA PARA EL DESARROLLADOR:
Si ves el error `gsub (string expected, got nil)`, asegúrate de que todos los personajes que hayas añadido a la lista `BrainrotData.Types` tengan un **Name** válido.

Recuerda activar **"Enable Studio Access to API Services"** en Game Settings -> Security.
