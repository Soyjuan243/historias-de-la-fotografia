# 🚀 GUÍA DEFINITIVA: BRAINROT GAME

---

## ⚠️ AVISO IMPORTANTE SOBRE EL CÓDIGO PYTHON
El código que empieza por `import math` y tiene `def calculate_stats` **NO ES PARA ROBLOX STUDIO**.
Ese es un script de **Python** que yo uso para calcular que el dinero del juego esté equilibrado. **No lo pongas en ningún sitio de tu juego**, ignóralo para la instalación.

---

## 🛠️ INSTRUCCIONES DE INSTALACIÓN (SISTEMA DE PRODUCCIÓN)

### 1. ReplicatedStorage > Shared (ModuleScripts ⚙️)
Crea una carpeta llamada **Shared** y pon estos 3:
*   **BrainrotData**
*   **Events**
*   **Utils**

### 2. ServerScriptService (Scripts 📜)
**Crea primero el ModuleScript (azul):**
*   **BrainrotManager**

**Crea estos Scripts normales (pergamino):**
*   **Main** (El que activa todo)
*   **RemoteSetup**
*   **PlatformManager**
*   **SpawningService**
*   **ProgressionService**
*   **DataService**

### 3. StarterPlayer > StarterPlayerScripts (LocalScripts 📜 personita)
*   **PlacementManager**
*   **StatsGuiManager**
*   **InteractionManager**

---

## 🎮 CÓMO JUGAR
1.  **Recoger:** Camina hacia un personaje en el suelo y usa **E**. Se te pondrá automáticamente en el inventario de abajo (herramientas).
2.  **Colocar:** Saca el personaje a tu mano (equípalo), acércate a una base vacía y presiona **E**.
3.  **Cobrar:** Pasa por encima de la plataforma verde de tu base.
4.  **Mejorar:** Acércate a tu personaje trabajando y aparecerá el menú en pantalla.

---

### 💡 SOLUCIÓN AL ERROR 'gsub'
He añadido protecciones. Si ves ese error, es porque algún personaje en tu lista de `BrainrotData` no tiene un **Name**. Revisa que todos tengan nombre.

Recuerda activar **"Enable Studio Access to API Services"** en Game Settings -> Security.
