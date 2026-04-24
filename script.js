const modules = [
    // BUILDING
    { id: 1, area: 'building', name: 'Intro a Roblox Studio', level: 'Básico', goal: 'Dominar la interfaz y navegación.', skills: ['Navegación 3D', 'Vistas', 'Configuración de entorno'] },
    { id: 2, area: 'building', name: 'Partes y Transformaciones', level: 'Básico', goal: 'Entender el átomo de Roblox: La Part.', skills: ['Escalado', 'Rotación', 'Pivot points', 'Colisiones'] },
    { id: 3, area: 'building', name: 'Modelado con Solid Modeling', level: 'Básico', goal: 'Crear formas complejas uniendo partes.', skills: ['Union', 'Negate', 'Intersect', 'Separar'] },
    { id: 4, area: 'building', name: 'Editor de Terreno Pro', level: 'Básico', goal: 'Crear mundos naturales realistas.', skills: ['Generación', 'Esculpir', 'Pintar materiales', 'Agua'] },
    { id: 5, area: 'building', name: 'Iluminación y Atmósfera', level: 'Intermedio', goal: 'Cambiar el mood del juego.', skills: ['Lighting settings', 'Post-processing', 'Skyboxes', 'Sunrays'] },
    { id: 6, area: 'building', name: 'Arquitectura de Interiores', level: 'Intermedio', goal: 'Diseñar espacios funcionales.', skills: ['Proporción humana', 'Detallado', 'MaterialService'] },
    { id: 7, area: 'building', name: 'Optimización de Mapas', level: 'Avanzado', goal: 'Hacer que el juego corra en móviles.', skills: ['StreamingEnabled', 'LODs', 'CollisionFidelity'] },
    { id: 8, area: 'building', name: 'Uso de Meshes Externos', level: 'Intermedio', goal: 'Importar desde Blender.', skills: ['FBX import', 'Texturizado', 'PBR Materials'] },
    { id: 9, area: 'building', name: 'Constraints y Física', level: 'Avanzado', goal: 'Crear mecanismos móviles.', skills: ['Hinges', 'Springs', 'Ropes', 'Prismatic'] },
    { id: 10, area: 'building', name: 'Plugins para Builders', level: 'Intermedio', goal: 'Acelerar el flujo de trabajo.', skills: ['Archimedes', 'Building Tools by F3X', 'GapFill'] },
    { id: 11, area: 'building', name: 'Modelado Orgánico', level: 'Avanzado', goal: 'Crear vegetación y rocas.', skills: ['Instancia', 'Procedural building'] },

    // PROGRAMACIÓN
    { id: 12, area: 'programacion', name: 'Fundamentos de Luau', level: 'Básico', goal: 'Escribir tu primera línea de código.', skills: ['Variables', 'Strings', 'Numbers', 'Booleans'] },
    { id: 13, area: 'programacion', name: 'Control de Flujo', level: 'Básico', goal: 'Darle lógica al juego.', skills: ['If/Else', 'Loops (For, While, Repeat)'] },
    { id: 14, area: 'programacion', name: 'Funciones y Alcance', level: 'Básico', goal: 'Organizar código reutilizable.', skills: ['Local vs Global', 'Return', 'Parámetros'] },
    { id: 15, area: 'programacion', name: 'Eventos y Señales', level: 'Básico', goal: 'Reaccionar a las acciones del jugador.', skills: ['Touched', 'MouseButton1Click', 'Connect'] },
    { id: 16, area: 'programacion', name: 'RemoteEvents y Red', level: 'Intermedio', goal: 'Comunicación Cliente-Servidor.', skills: ['FireServer', 'FireClient', 'Seguridad'] },
    { id: 17, area: 'programacion', name: 'DataStore Service', level: 'Avanzado', goal: 'Guardar progreso del jugador.', skills: ['SetAsync', 'UpdateAsync', 'Handling errors'] },
    { id: 18, area: 'programacion', name: 'Raycasting en Combate', level: 'Avanzado', goal: 'Detectar colisiones láser/balas.', skills: ['RaycastParams', 'Result detection', 'Visuals'] },
    { id: 19, area: 'programacion', name: 'ModuleScripts Avanzados', level: 'Avanzado', goal: 'Programación Orientada a Objetos.', skills: ['Require', 'Metatablas', 'Clases en Lua'] },
    { id: 20, area: 'programacion', name: 'Task Library y DeltaTime', level: 'Intermedio', goal: 'Timing perfecto.', skills: ['task.wait', 'task.spawn', 'task.delay'] },
    { id: 21, area: 'programacion', name: 'Atributos y Etiquetas', level: 'Intermedio', goal: 'Gestionar datos sin scripts.', skills: ['Attributes', 'CollectionService', 'Tags'] },
    { id: 22, area: 'programacion', name: 'IA Básica (NPCs)', level: 'Avanzado', goal: 'Crear enemigos que te persigan.', skills: ['PathfindingService', 'Humanoid states'] },

    // DISEÑO
    { id: 23, area: 'diseno', name: 'Principios de UI', level: 'Básico', goal: 'Entender la jerarquía visual.', skills: ['Composición', 'Color', 'Contraste'] },
    { id: 24, area: 'diseno', name: 'ScreenGui y Frames', level: 'Básico', goal: 'Estructurar tu interfaz.', skills: ['AnchorPoint', 'Scale vs Offset', 'ZIndex'] },
    { id: 25, area: 'diseno', name: 'Botones y UX', level: 'Básico', goal: 'Hacer que el jugador quiera hacer clic.', skills: ['Hover effects', 'Click feedback', 'States'] },
    { id: 26, area: 'diseno', name: 'TweenService para UI', level: 'Intermedio', goal: 'Animaciones suaves.', skills: ['EasingStyles', 'Transitions', 'Layouts'] },
    { id: 27, area: 'diseno', name: 'Sistemas de Inventario', level: 'Intermedio', goal: 'Listar ítems dinámicamente.', skills: ['ScrollingFrame', 'UIGridLayout', 'Templates'] },
    { id: 28, area: 'diseno', name: 'Tiendas e Iconografía', level: 'Intermedio', goal: 'Vender productos en el juego.', skills: ['ImageLabels', 'Custom icons', 'Layouts'] },
    { id: 29, area: 'diseno', name: 'ViewportFrames', level: 'Avanzado', goal: 'Mostrar objetos 3D en 2D.', skills: ['Camera in UI', 'Model rendering'] },
    { id: 30, area: 'diseno', name: 'HUD de Salud y Experiencia', level: 'Básico', goal: 'Barras de progreso animadas.', skills: ['Clipping', 'Bar logic'] },
    { id: 31, area: 'diseno', name: 'Diseño Adaptativo', level: 'Avanzado', goal: 'Que tu juego se vea bien en todo.', skills: ['UISizeConstraint', 'UIAspectRatioConstraint'] },
    { id: 32, area: 'diseno', name: 'Branding y Miniaturas', level: 'Intermedio', goal: 'Atraer jugadores desde la web.', skills: ['Game Icons', 'Thumbnails', 'Logos'] },
    { id: 33, area: 'diseno', name: 'Efectos de Partículas UI', level: 'Avanzado', goal: 'Añadir "Juice" al juego.', skills: ['Visual feedback', 'Particle emitters'] },
];

function generateClassesForModule(mod) {
    const classes = [];
    const topics = [
        "Introducción Teórica", "Herramientas Clave", "Configuración Inicial",
        "Implementación Paso a Paso", "Optimización y Pulido", "Casos de Uso Reales", "Revisión Final"
    ];

    for (let i = 1; i <= 7; i++) {
        classes.push({
            id: i,
            topic: `${topics[i-1]} en ${mod.name}`,
            explanation: `En esta clase aprenderemos a dominar los conceptos de ${mod.name} enfocándonos en ${mod.skills[i % mod.skills.length]}. Es fundamental entender cómo esto afecta el rendimiento y la experiencia del usuario.`,
            script: `¡Hola a todos! Bienvenidos a la clase ${i} del módulo ${mod.name}. Hoy vamos a ensuciarnos las manos. Abran su Roblox Studio y sigan mis pasos. No se preocupen si no sale a la primera, el desarrollo es ensayo y error. ¿Listos? ¡Vamos a darle!`,
            exercise: `Crea un sistema básico donde utilices ${mod.skills[0]} para lograr un efecto visual o lógico en tu mapa.`,
            errors: `Olvidar anclar las partes (Anchored) o no definir las variables locales adecuadamente.`,
            challenge: `Modifica el ejercicio anterior para que funcione automáticamente cada 5 segundos usando un bucle.`
        });
    }
    return classes;
}

const modulesContainer = document.getElementById('modules-container');
const viewer = document.getElementById('class-viewer');
const classData = document.getElementById('class-data');
const closeViewer = document.getElementById('close-viewer');

function renderModules(filter = 'all') {
    modulesContainer.innerHTML = '';
    const filtered = filter === 'all' ? modules : modules.filter(m => m.area === filter);

    filtered.forEach(mod => {
        const card = document.createElement('div');
        card.className = 'module-card';
        card.innerHTML = `
            <span class="area-badge">${mod.area} - ${mod.level}</span>
            <h3>${mod.name}</h3>
            <p>${mod.goal}</p>
            <div style="margin-top: 1rem; font-size: 0.8rem; color: #8b5cf6;">
                ${mod.skills.map(s => `#${s}`).join(' ')}
            </div>
            <button class="btn-primary" style="margin-top: 1.5rem; width: 100%;" onclick="openModule(${mod.id})">Ver Clases</button>
        `;
        modulesContainer.appendChild(card);
    });
}

window.openModule = (id) => {
    const mod = modules.find(m => m.id === id);
    const classes = generateClassesForModule(mod);

    viewer.classList.remove('hidden');
    classData.innerHTML = `
        <h2 style="color: #00f2ff; margin-bottom: 0.5rem;">${mod.name}</h2>
        <p style="margin-bottom: 2rem; color: #94a3b8;">${mod.goal}</p>
        <div class="classes-list">
            ${classes.map(c => `
                <div class="class-item" style="border-bottom: 1px solid #334155; padding: 2rem 0;">
                    <h3 style="color: #8b5cf6;">Clase ${c.id}: ${c.topic}</h3>
                    <div class="instructor-script">
                        <strong>🎙️ Guion del Instructor:</strong>
                        "${c.script}"
                    </div>
                    <div class="content-section">
                        <h4>📖 Explicación</h4>
                        <p>${c.explanation}</p>
                    </div>
                    <div class="content-section" style="margin-top: 1rem;">
                        <h4>🧪 Ejercicio Práctico</h4>
                        <p>${c.exercise}</p>
                    </div>
                    ${mod.area === 'programacion' ? `
                    <pre><code>-- Ejemplo de código para la clase
local function onEventTriggered(player)
    print("Acción ejecutada por: " .. player.Name)
    -- Implementación de ${mod.skills[0]}
    task.wait(1)
end</code></pre>` : ''}
                    <div style="background: rgba(239, 68, 68, 0.1); padding: 1rem; border-radius: 8px; margin: 1rem 0;">
                        <strong style="color: #ef4444;">⚠️ Error Común:</strong> ${c.errors}
                    </div>
                    <div style="background: rgba(34, 197, 94, 0.1); padding: 1rem; border-radius: 8px;">
                        <strong style="color: #22c55e;">🎯 Mini Reto:</strong> ${c.challenge}
                    </div>
                </div>
            `).join('')}
        </div>
    `;
};

closeViewer.addEventListener('click', () => {
    viewer.classList.add('hidden');
});

document.querySelectorAll('.filter-btn').forEach(btn => {
    btn.addEventListener('click', (e) => {
        document.querySelector('.filter-btn.active').classList.remove('active');
        btn.classList.add('active');
        renderModules(btn.dataset.area);
    });
});

// Inicializar
renderModules();
