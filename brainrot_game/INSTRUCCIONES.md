# 🚀 GUÍA PASO A PASO: BRAINROT GAME

---

## 🛠️ CAMBIOS RECIENTES
1.  **Aparición Aleatoria:** Los personajes ahora aparecen en cualquier parte del mapa (sobre la Baseplate). Ya no necesitas poner `spawn1` (aunque si los pones, también funcionarán).
2.  **Personajes de Pie:** Todos los modelos aparecerán rectos y anclados al suelo.
3.  **Nueva Interfaz (UI):**
    *   **Botón de Cobrar:** Aparecerá pegado al suelo sobre la plataforma y será visible siempre. ¡Haz clic en él para recoger tus ganancias!
    *   **Botón de Mejorar:** Solo aparecerá cuando te acerques mucho a un personaje trabajando.

---

## 🎨 CÓMO USAR TUS MODELOS
1.  Busca **ReplicatedStorage** -> Crea una carpeta llamada **Models**.
2.  Pon tus modelos dentro con estos nombres: **Common1, Common2, Common3, Common4, Common5, Secret1, Secret2**.
3.  Asegúrate de que tus modelos tengan un **PrimaryPart** configurado para que la interfaz aparezca en el sitio correcto.

---

## 🚀 UBICACIÓN DE LOS SCRIPTS (TABLA DE REFERENCIA)

| Script | Tipo | Ubicación |
| :--- | :--- | :--- |
| **BrainrotManager** | ModuleScript | ServerScriptService |
| **Main** | Script | ServerScriptService |
| **RemoteSetup** | Script | ServerScriptService |
| **PlatformManager** | Script | ServerScriptService |
| **SpawningService** | Script | ServerScriptService |
| **ProgressionService** | Script | ServerScriptService |
| **DataService** | Script | ServerScriptService |
| **InventoryManager** | LocalScript | StarterPlayerScripts |
| **PlacementManager** | LocalScript | StarterPlayerScripts |
| **StatsGuiManager** | LocalScript | StarterPlayerScripts |
| **InteractionManager**| LocalScript | StarterPlayerScripts |

---

### 💡 NOTA IMPORTANTE:
Para que el juego funcione correctamente, asegúrate de tener una parte llamada **Baseplate** en el Workspace para que el script sepa el tamaño de tu mapa y dónde hacer aparecer los personajes.

Recuerda activar **"Enable Studio Access to API Services"** en Game Settings -> Security.
