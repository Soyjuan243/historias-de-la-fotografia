# 🚀 GUÍA DEFINITIVA: BRAINROT GAME (ECONOMÍA AJUSTADA)

---

## ⚠️ AVISO IMPORTANTE SOBRE EL CÓDIGO PYTHON
El código que empieza por `import math` y tiene `def calculate_stats` **NO ES PARA ROBLOX STUDIO**.
Ese es un script de **Python** que yo uso para calcular que el dinero del juego esté equilibrado. **No lo pongas en ningún sitio de tu juego**, ignóralo para la instalación.

---

## 🛠️ INSTRUCCIONES DE INSTALACIÓN (SISTEMA DE PRODUCCIÓN)

### 1. ReplicatedStorage > Shared (ModuleScripts ⚙️)
Crea una carpeta llamada **Shared** y pon estos 3:
*   **BrainrotData** (Contiene los 32+ personajes con sus nuevos nombres y precios)
*   **Events**
*   **Utils**

### 2. ServerScriptService (Scripts 📜)
**Crea primero el ModuleScript (azul):**
*   **BrainrotManager** (Contiene la nueva fórmula de progresión suave: x1.1 Ingreso, x1.12 Costo)

**Crea estos Scripts normales (pergamino):**
*   **Main** (El que activa todo)
*   **RemoteSetup**
*   **PlatformManager**
*   **SpawningService** (Zonas spawn1 y spawn2 configuradas con probabilidades)
*   **ProgressionService**
*   **DataService**
*   **AdminCommands** (Comando /spawn habilitado)

### 3. StarterPlayer > StarterPlayerScripts (LocalScripts 📜 personita)
*   **PlacementManager**
*   **StatsGuiManager** (Colores de rareza: Verde, Azul, Morado, Naranja, Rojo)
*   **InteractionManager**
*   **MoneyHud** (HUD de dinero animado)

---

## 👑 COMANDOS DE ADMINISTRADOR
*   **Uso:** Escribe en el chat `/spawn ID` (Ejemplo: `/spawn Common1`).
*   **Efecto:** El personaje aparecerá en una de las zonas de spawn aleatoriamente.
*   **Nota:** He eliminado el sistema de mensajes globales por chat para evitar saturación y errores, ahora el sistema es más limpio.

### Cómo añadir administradores:
1. Abre el script **AdminCommands** en `ServerScriptService`.
2. Busca la línea que dice `local AUTHORIZED_IDS = {`.
3. Añade los IDs de usuario dentro de las llaves, separados por comas.
   - Ejemplo: `local AUTHORIZED_IDS = {12345678, 87654321}`.
   - *Nota: El dueño del juego (tú) ya está autorizado automáticamente.*

---

## 📊 EQUILIBRIO ECONÓMICO (NUEVO)
He ajustado los precios para que el juego sea divertido y no "exagerado":
*   **Ingresos:** Suben un **10%** (x1.1) por cada nivel.
*   **Costes de Mejora:** Suben un **12%** (x1.12) por cada nivel.
*   Esto permite que incluso al nivel 100, los precios sean razonables y se puedan añadir muchos más personajes en el futuro sin romper el juego.

---

## 🎮 CÓMO JUGAR
1.  **Recoger:** Camina hacia un personaje en el suelo y usa **E**. Se te pondrá automáticamente en el inventario de abajo (herramientas).
2.  **Colocar:** Saca el personaje a tu mano (equípalo), acércate a una base vacía y presiona **E**.
3.  **Cobrar:** Pasa por encima de la plataforma verde de tu base.
4.  **Mejorar:** Acércate a tu personaje trabajando y aparecerá el menú en pantalla.

---

### 💡 SOLUCIÓN AL ERROR 'gsub'
He añadido protecciones en `Utils.lua`. Si ves ese error, es porque algún personaje en tu lista de `BrainrotData` no tiene un **Name**. He revisado los 32 actuales y todos están correctos.

Recuerda activar **"Enable Studio Access to API Services"** en Game Settings -> Security.
