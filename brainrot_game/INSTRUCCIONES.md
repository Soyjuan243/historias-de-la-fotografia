# 🚀 GUÍA ACTUALIZADA: BRAINROT GAME

---

## 🛠️ CAMBIOS EN ESTA VERSIÓN
1.  **Inventario de Herramientas (Tools):** Ahora los personajes se guardan en tu inventario de abajo. Para poner uno en una base, **equipa la herramienta** y haz clic en la base.
2.  **Cobro Automático:** Ya no hay botones flotantes para cobrar dinero. Ahora hay una **plataforma verde (CollectorPad)** en cada base. ¡Solo camina sobre ella para cobrar todo el dinero acumulado!
3.  **Spawn Controlado:** Los personajes vuelven a aparecer sobre las partes llamadas **spawn1**, pero ahora aparecerán en cualquier punto aleatorio de su superficie.
4.  **Anclaje Total:** Se ha reforzado el código para que los personajes **nunca se caigan** cuando los pones en la plataforma (están 100% anclados).

---

## 🛠️ PASO A PASO PARA EL MAPA
1.  **Spawn1:** Crea bloques en el suelo y ponles de nombre **spawn1**. Hazlos grandes si quieres que los personajes aparezcan en un área amplia.
2.  **Platforms:** Mete tus bases dentro de la carpeta **Platforms**. El script pondrá automáticamente la plataforma de cobro encima.

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

### 💡 NOTA IMPORTANTE:
El menú de "Mejorar" y "Quitar" seguirá apareciendo en tu pantalla cuando te acerques mucho a un personaje trabajando.

Recuerda activar **"Enable Studio Access to API Services"** en Game Settings -> Security para que se guarden tus personajes y tu dinero.
