# 🚀 GUÍA DEFINITIVA: BRAINROT GAME (OPTIMIZADO)

---

## ⚠️ AVISO IMPORTANTE SOBRE EL CÓDIGO PYTHON
El código que empieza por `import math` y tiene `def calculate_stats` **NO ES PARA ROBLOX STUDIO**.
Es una herramienta externa para calcular el equilibrio económico. **Ignóralo para la instalación**.

---

## 🛠️ INSTRUCCIONES DE INSTALACIÓN (SISTEMA DE PRODUCCIÓN)

### 1. ReplicatedStorage > Shared (ModuleScripts ⚙️)
Crea una carpeta llamada **Shared** y pon estos 3:
*   **BrainrotData** (Datos de los 32+ personajes)
*   **Events**
*   **Utils**

### 2. ServerScriptService (Scripts 📜)
**Crea primero el ModuleScript (azul):**
*   **BrainrotManager**

**Crea estos Scripts normales (pergamino):**
*   **Main** (El que activa todo)
*   **RemoteSetup**
*   **PlatformManager**
*   **SpawningService** (Controla spawns y temporizadores)
*   **ProgressionService**
*   **DataService**
*   **AdminCommands** (Comando /spawn)

### 3. StarterPlayer > StarterPlayerScripts (LocalScripts 📜 personita)
*   **PlacementManager**
*   **StatsGuiManager** (Gestión de etiquetas sobre la cabeza)
*   **InteractionManager**
*   **MoneyHud** (HUD de dinero animado)

---

## 🔄 CÓMO ROTAR PERSONAJES (INDIVIDUALMENTE)
Si un modelo específico se ve mal (como el de la captura), ahora puedes corregirlo sin afectar a los demás:

1. Abre **Shared > BrainrotData**.
2. Busca el ID del personaje (ej: `Common1`).
3. Ajusta el valor de `RotationOffset = Vector3.new(X, Y, Z)`.
   - Ejemplo: `Vector3.new(0, 90, 0)` rotará ese personaje 90 grados extra.
   - Estos valores se suman al fix global de `-89.5, 180, 0`.

---

## 💰 SISTEMA DE VENTA (EL COMPRADOR)
He añadido un NPC llamado **Comprador** al Workspace (si no existe, se crea un bloque azul automáticamente).
1.  **Equipa** el personaje que quieras vender.
2.  Acércate al **Comprador**.
3.  Aparecerá un botón verde: **"VENDER MANO"**.
4.  Recibirás el 50% del valor base del personaje.

---

## 🚪 BOTÓN DE SALIDA
Hay un botón de **SALIR** en la esquina superior derecha de la pantalla.
- Te teletransporta al Spawn inicial del juego.

---

## 📺 MEJORAS VISUALES (UI)
He configurado las GUIs (nombres, niveles, dinero) para que **no se amplíen** cuando te alejas. Ahora mantienen su tamaño real respecto al personaje, lo que evita que la pantalla se llene de texto gigante y buegado.

---

## 👑 COMANDOS DE ADMINISTRADOR
*   **Uso:** `/spawn ID` (Ejemplo: `/spawn CommonGold1`).
*   **Efecto:** Aparece un personaje aleatoriamente en `spawn1` o `spawn2`.

### Cómo añadir administradores:
1. Abre el script **AdminCommands**.
2. Añade los IDs de usuario en la tabla `AUTHORIZED_IDS = {123, 456}`.

---

## 🎮 CÓMO JUGAR
1.  **Recoger:** Acércate a un personaje en el suelo y presiona **E**.
2.  **Colocar:** Saca el personaje a tu mano, acércate a una base vacía y presiona **E**.
3.  **Cobrar:** Camina sobre la plataforma verde de tu base.
4.  **Mejorar:** Acércate a tu personaje trabajando y usa el menú flotante.

---

### 💡 SOLUCIÓN AL ERROR 'gsub'
He añadido protecciones. Si ves ese error, revisa que todos tus personajes en `BrainrotData` tengan un **Name** definido.

Recuerda activar **"Enable Studio Access to API Services"** en Game Settings -> Security.
