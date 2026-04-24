const modules = [
    // --- ÁREA: BUILDING (11 Módulos) ---
    {
        id: 1, area: 'building', name: 'Mastering the Studio Workspace', level: 'Básico',
        goal: 'Dominar el ecosistema de Roblox Studio a nivel profesional.',
        skills: ['Custom Layouts', 'Advanced Navigation', 'Selection Groups', 'Performance Tab']
    },
    {
        id: 2, area: 'building', name: 'Precision Part Manipulation', level: 'Básico',
        goal: 'Ir más allá de mover bloques; dominar el sistema de coordenadas y pivots.',
        skills: ['Pivot Points', 'Local vs World Space', 'Transform Tool', 'Align Tool']
    },
    {
        id: 3, area: 'building', name: 'Advanced Solid Modeling (CSG v3)', level: 'Básico',
        goal: 'Crear modelos complejos optimizados usando operaciones binarias.',
        skills: ['Union/Negate Precision', 'Smoothing Angle', 'Export as Mesh', 'Collision Fidelity']
    },
    {
        id: 4, area: 'building', name: 'Professional Terrain Engineering', level: 'Básico',
        goal: 'Esculpir biomas realistas con herramientas de pincel avanzado.',
        skills: ['Region Editing', 'Sea Level', 'Terrain Materials', 'Vegetation Painting']
    },
    {
        id: 5, area: 'building', name: 'MaterialService & PBR Texturing', level: 'Intermedio',
        goal: 'Uso de texturas de alta gama para realismo visual.',
        skills: ['PBR Materials', 'Normal Maps', 'Roughness', 'Organic Material Tiling']
    },
    {
        id: 6, area: 'building', name: 'High-End Lighting & Atmospherics', level: 'Intermedio',
        goal: 'Dominar la iluminación "Future" para crear moods envolventes.',
        skills: ['Future Lighting', 'Post-Processing Effects', 'Dynamic Skies', 'Volumetric Clouds']
    },
    {
        id: 7, area: 'building', name: 'Architectural Scale & Proportions', level: 'Intermedio',
        goal: 'Construir edificios siguiendo reglas de arquitectura y ergonomía de avatar.',
        skills: ['Modular Building', 'Human Scale (Studs)', 'Interior Culling', 'Floor Planning']
    },
    {
        id: 8, area: 'building', name: 'Blender to Roblox Pipeline', level: 'Intermedio',
        goal: 'Importar activos externos optimizados para el motor.',
        skills: ['Mesh Import', 'Automatic Skinning', 'Vertex Color', 'Optimized Topology']
    },
    {
        id: 9, area: 'building', name: 'Physics Constraints & Mechanics', level: 'Avanzado',
        goal: 'Mecanismos complejos basados en física real.',
        skills: ['Hinge/BallSocket', 'Prismatic Constraints', 'Springs', 'VectorForce']
    },
    {
        id: 10, area: 'building', name: 'Optimization & Technical Art', level: 'Avanzado',
        goal: 'Hacer que mapas gigantes corran en dispositivos de gama baja.',
        skills: ['StreamingEnabled', 'Instancing', 'LOD System', 'Draw Call Reduction']
    },
    {
        id: 11, area: 'building', name: 'Advanced Level Design & Pathing', level: 'Avanzado',
        goal: 'Crear flujos de juego que guíen al jugador orgánicamente.',
        skills: ['Flow Control', 'Visual Anchors', 'Navigation Mesh', 'Zone Planning']
    },

    // --- ÁREA: PROGRAMACIÓN (11 Módulos) ---
    {
        id: 12, area: 'programacion', name: 'Strict Luau & Type Safety', level: 'Básico',
        goal: 'Programar como un ingeniero de software profesional.',
        skills: ['Type Checking', 'Enums', 'Generic Types', 'Debugging Pro']
    },
    {
        id: 13, area: 'programacion', name: 'Memory & Performance Scripting', level: 'Intermedio',
        goal: 'Evitar Memory Leaks y optimizar el uso de CPU.',
        skills: ['Garbage Collection', 'Caching', 'Maid/Janitor Pattern', 'Script Profiler']
    },
    {
        id: 14, area: 'programacion', name: 'Modular Architecture & Require', level: 'Intermedio',
        goal: 'Crear sistemas escalables con ModuleScripts.',
        skills: ['Dependency Injection', 'Circular Dependencies', 'Cross-Module State', 'Replicación']
    },
    {
        id: 15, area: 'programacion', name: 'Advanced Event Signals', level: 'Intermedio',
        goal: 'Dominar la comunicación entre scripts.',
        skills: ['BindableEvents', 'Custom Signals', 'Connection Management', 'Deferred Events']
    },
    {
        id: 16, area: 'programacion', name: 'Secure Networking & Remotes', level: 'Avanzado',
        goal: 'Proteger tu juego contra exploits y hackers.',
        skills: ['RemoteEvent Validation', 'Anti-Cheat Logic', 'Server-Side Authority', 'Rate Limiting']
    },
    {
        id: 17, area: 'programacion', name: 'Persistent DataStore v2', level: 'Avanzado',
        goal: 'Guardar datos de millones de jugadores sin pérdidas.',
        skills: ['UpdateAsync', 'Session Locking', 'Data Versioning', 'Backup Systems']
    },
    {
        id: 18, area: 'programacion', name: 'Raycasting & Combat Systems', level: 'Avanzado',
        goal: 'Detección de colisiones para armas y proyectiles.',
        skills: ['Spatial Query', 'RaycastParams', 'FastCast API', 'Hitbox Logic']
    },
    {
        id: 19, area: 'programacion', name: 'Object-Oriented Programming (OOP)', level: 'Avanzado',
        goal: 'Usar metatablas para crear clases y objetos en Luau.',
        skills: ['Metatables', 'Inheritance', 'Polymorphism', 'Constructor Patterns']
    },
    {
        id: 20, area: 'programacion', name: 'The Modern Task Library', level: 'Básico',
        goal: 'Sustituir wait() por sistemas modernos de hilos.',
        skills: ['task.wait', 'task.spawn', 'task.defer', 'Parallel Luau']
    },
    {
        id: 21, area: 'programacion', name: 'Attributes & CollectionService', level: 'Intermedio',
        goal: 'Programación basada en etiquetas y metadatos.',
        skills: ['Tag Editor', 'GetInstanceAddedSignal', 'Custom Attributes', 'Metadata Logic']
    },
    {
        id: 22, area: 'programacion', name: 'Advanced NPC AI & Pathfinding', level: 'Avanzado',
        goal: 'Crear enemigos inteligentes que naveguen por el mapa.',
        skills: ['PathfindingService', 'Behavior Trees', 'Finite State Machines', 'Reaction Logic']
    },

    // --- ÁREA: DISEÑO UI/UX (11 Módulos) ---
    {
        id: 23, area: 'diseno', name: 'UI Principles for Games', level: 'Básico',
        goal: 'Entender la composición visual aplicada a videojuegos.',
        skills: ['Visual Hierarchy', 'Color Theory', 'Affordance', 'Typography']
    },
    {
        id: 24, area: 'diseno', name: 'Dynamic ScreenGui Systems', level: 'Básico',
        goal: 'Estructurar interfaces que funcionen en cualquier pantalla.',
        skills: ['AnchorPoint', 'Scale vs Offset', 'ZIndex Hierarchy', 'DisplayOrder']
    },
    {
        id: 25, area: 'diseno', name: 'Responsive Layouts & Constraints', level: 'Intermedio',
        goal: 'Soporte automático para Móvil, PC y Consola.',
        skills: ['UIAspectRatioConstraint', 'UISizeConstraint', 'UIListLayout', 'UIGridLayout']
    },
    {
        id: 26, area: 'diseno', name: 'TweenService & UI Animation', level: 'Intermedio',
        goal: 'Dar vida a los menús con movimientos suaves.',
        skills: ['Easing Styles', 'Sequential Tweens', 'Feedback Loops', 'Micro-animations']
    },
    {
        id: 27, area: 'diseno', name: 'Advanced Inventory Architectures', level: 'Avanzado',
        goal: 'Sistemas de ítems escalables y visualmente atractivos.',
        skills: ['ScrollingFrames', 'Template Cloning', 'Data Binding', 'Sorting Logic']
    },
    {
        id: 28, area: 'diseno', name: 'Shop & Monetization UI', level: 'Intermedio',
        goal: 'Maximizar conversiones con un diseño de tienda profesional.',
        skills: ['Game Pass Buttons', 'Developer Products', 'Currency HUD', 'Purchase Feedback']
    },
    {
        id: 29, area: 'diseno', name: 'ViewportFrames & 3D UI', level: 'Avanzado',
        goal: 'Renderizar modelos 3D directamente en la interfaz 2D.',
        skills: ['CurrentCamera', 'Model Rotation', 'Dynamic Lighting in UI', 'Custom Previews']
    },
    {
        id: 30, area: 'diseno', name: 'Health & Combat HUDs', level: 'Básico',
        goal: 'Crear barras de salud y daño que sientan el impacto.',
        skills: ['Clipping Descendants', 'Shield Overlays', 'Damage Popups', 'Vignettes']
    },
    {
        id: 31, area: 'diseno', name: 'Visual Identity & Branding', level: 'Intermedio',
        goal: 'Crear un estilo cohesivo para todo tu juego.',
        skills: ['Logo Design', 'Custom Font Import', 'Icon Sets', 'Loading Screens']
    },
    {
        id: 32, area: 'diseno', name: 'Interaction UX & Sound Design', level: 'Avanzado',
        goal: 'Combinar visuales con sonidos para una experiencia inmersiva.',
        skills: ['UI Sound Effects', 'Haptic Feedback', 'InputService Handling', 'Navigation Flow']
    },
    {
        id: 33, area: 'diseno', name: 'Advanced UI Particles & Effects', level: 'Avanzado',
        goal: 'Añadir "Juice" extremo con emisores de partículas en la UI.',
        skills: ['UIParticleEmitter', 'Confetti Systems', 'Neon Glow UI', 'Background Blur']
    },
];

// Generador de contenido ultra detallado
function generateClassesForModule(mod) {
    const detailTopics = [
        { title: "Foundations & Industry Standards", depth: "Análisis profundo de la arquitectura." },
        { title: "Advanced Implementation & Logic", depth: "Escribiendo código de producción." },
        { title: "Integration with Core Systems", depth: "Conectando con el resto del juego." },
        { title: "Performance & Stress Testing", depth: "Llevando el sistema al límite." },
        { title: "Security & Edge Case Handling", depth: "Protección y robustez total." },
        { title: "Polishing & Final Aesthetics", depth: "Añadiendo el toque premium final." },
        { title: "Capstone: Master Project", depth: "Construyendo un sistema real completo." }
    ];

    return detailTopics.map((item, i) => {
        const skill = mod.skills[i % mod.skills.length];
        return {
            id: i + 1,
            topic: item.title,
            explanation: `
                ${item.depth} En esta clase magistral, exploraremos ${mod.name} centrándonos específicamente en **${skill}**.
                No solo aprenderemos el "cómo", sino el "por qué" técnico detrás de cada decisión. Cubriremos la estructura interna de las clases de Roblox involucradas,
                la optimización de memoria y cómo este sistema debe escalar para miles de jugadores simultáneos.
                Es vital entender el flujo de datos y el ciclo de vida de los objetos en esta etapa.
            `,
            script: `
                [Instructor]: "¡Hola a todos! Bienvenidos a la sesión ${i + 1} de ${mod.name}.
                Hoy vamos a elevar el nivel. Abran su Explorador y su Ventana de Propiedades, porque vamos a desglosar **${skill}**.
                Fíjense bien en mi pantalla: lo primero que haremos será configurar el entorno para que sea eficiente.
                Si están en la parte de programación, activen el 'Strict Mode' de Luau. Si están en Building, activen las 'Constraint Visualizations'.
                Vamos a construir esto paso a paso, no se salten nada, porque cada pequeño detalle cuenta para el rendimiento final del juego."
            `,
            exercise: `
                Implementa un sistema de alto rendimiento que utilice **${skill}**.
                El sistema debe ser modular, fácil de leer y estar preparado para recibir actualizaciones futuras sin romper el código base.
                Aplica los principios de DRY (Don't Repeat Yourself) y SOLID vistos anteriormente.
            `,
            code: generateRealisticCode(mod, skill, i),
            errors: `
                - Error de Referencia Nula: Intentar acceder a un objeto que no ha cargado (usa WaitForChild).
                - Memory Leak: No desconectar eventos .Connected cuando el objeto es destruido.
                - Lag de Red: Enviar demasiada información por RemoteEvents (Data Saturation).
            `,
            challenge: `
                Extiende tu ejercicio para incluir un sistema de 'Logging' avanzado y optimización automática
                dependiendo del dispositivo del usuario (Mobile vs PC).
            `
        };
    });
}

function generateRealisticCode(mod, skill, index) {
    if (mod.area === 'building') {
        return `-- Arquitectura de Construcción Pro\n-- Implementando: ${skill}\n-- Configuración de Pivot y Propiedades Físicas\n\nlocal Model = script.Parent\nModel:SetAttribute("LevelOfDetail", "High")\n\n-- Ajuste dinámico de Colisiones para rendimiento\nfor _, part in ipairs(Model:GetDescendants()) do\n    if part:IsA("BasePart") then\n        part.CollisionFidelity = Enum.CollisionFidelity.Optimal\n        part.Massless = true\n    end\nend`;
    } else if (mod.area === 'programacion') {
        return `--!strict\n-- Servicio Profesional de ${mod.name}\n-- Implementando: ${skill}\n\nlocal ReplicatedStorage = game:GetService("ReplicatedStorage")\nlocal Task = require(ReplicatedStorage.Utils.TaskModule)\n\nlocal Service = {}\nService.__index = Service\n\nfunction Service.new()\n    local self = setmetatable({}, Service)\n    self._isActive = true\n    return self\nend\n\nfunction Service:Initialize()\n    task.spawn(function() \n        -- Lógica optimizada con ${skill}\n        print("Service Initialized Successfully")\n    end)\nend\n\nreturn Service`;
    } else {
        return `-- UI Framework v4.0\n-- Módulo: ${mod.name}\n-- Animando: ${skill}\n\nlocal TweenService = game:GetService("TweenService")\nlocal UIElement = script.Parent\n\nlocal function applyMotion()\n    local info = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)\n    local tween = TweenService:Create(UIElement, info, {\n        Size = UDim2.fromScale(1.1, 1.1),\n        ImageColor3 = Color3.fromRGB(0, 242, 255)\n    })\n    tween:Play()\nend`;
    }
}

// --- LÓGICA DE RENDERIZADO Y UI ---

const modulesContainer = document.getElementById('modules-container');
const viewer = document.getElementById('class-viewer');
const classData = document.getElementById('class-data');
const closeViewer = document.getElementById('close-viewer');
const navbar = document.querySelector('.navbar');

function renderModules(filter = 'all') {
    modulesContainer.innerHTML = '';
    const filtered = filter === 'all' ? modules : modules.filter(m => m.area === filter);

    filtered.forEach((mod, index) => {
        const card = document.createElement('div');
        card.className = 'module-card reveal';
        card.style.transitionDelay = `${index * 0.05}s`;

        card.innerHTML = `
            <div class="card-inner">
                <span class="area-tag">${mod.area} • ${mod.level}</span>
                <h3>${mod.name}</h3>
                <p>${mod.goal}</p>
                <div class="skills-tags">
                    ${mod.skills.map(s => `<span class="s-tag">#${s}</span>`).join(' ')}
                </div>
                <div class="card-footer">
                    <span class="c-count">7 LECCIONES</span>
                    <button class="btn-glow" onclick="openModule(${mod.id})">Explorar <i class="fas fa-chevron-right"></i></button>
                </div>
            </div>
        `;
        modulesContainer.appendChild(card);
    });

    observeElements();
}

function observeElements() {
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
}

window.openModule = (id) => {
    const mod = modules.find(m => m.id === id);
    const classes = generateClassesForModule(mod);

    document.body.style.overflow = 'hidden';
    viewer.classList.remove('hidden');

    classData.innerHTML = `
        <div class="modal-header-premium">
            <div class="m-info">
                <span class="badge-premium">${mod.area.toUpperCase()} SPECIALIZATION</span>
                <h2>${mod.name}</h2>
                <p>${mod.goal}</p>
            </div>
        </div>
        <div class="classes-scroll-area">
            ${classes.map(c => `
                <div class="class-step">
                    <div class="step-sidebar">
                        <div class="step-line"></div>
                        <div class="step-node">${c.id}</div>
                    </div>
                    <div class="step-content">
                        <h3>${c.topic}</h3>
                        <div class="instructor-script-premium">
                            <div class="i-avatar"><i class="fas fa-user-tie"></i></div>
                            <div class="i-text">${c.script}</div>
                        </div>
                        <div class="explanation-box">
                            <h4><i class="fas fa-book-open"></i> Marco Teórico</h4>
                            <p>${c.explanation}</p>
                        </div>
                        <div class="exercise-box">
                            <h4><i class="fas fa-flask"></i> Laboratorio Práctico</h4>
                            <p>${c.exercise}</p>
                        </div>
                        <div class="code-header">
                            <span>SINTAXIS MODERN LUAU</span>
                            <button class="copy-btn"><i class="far fa-copy"></i> Copiar</button>
                        </div>
                        <pre><code>${c.code}</code></pre>
                        <div class="debug-grid">
                            <div class="debug-item error">
                                <h5><i class="fas fa-exclamation-triangle"></i> EVITAR SIEMPRE</h5>
                                <p>${c.errors}</p>
                            </div>
                            <div class="debug-item challenge">
                                <h5><i class="fas fa-trophy"></i> RETO DE CERTIFICACIÓN</h5>
                                <p>${c.challenge}</p>
                            </div>
                        </div>
                    </div>
                </div>
            `).join('')}
        </div>
    `;
};

closeViewer.addEventListener('click', () => {
    viewer.classList.add('hidden');
    document.body.style.overflow = 'auto';
});

window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
        navbar.classList.add('scrolled');
    } else {
        navbar.classList.remove('scrolled');
    }
});

document.querySelectorAll('.filter-pill').forEach(pill => {
    pill.addEventListener('click', (e) => {
        document.querySelector('.filter-pill.active').classList.remove('active');
        pill.classList.add('active');
        renderModules(pill.dataset.area);
    });
});

document.addEventListener('DOMContentLoaded', () => {
    renderModules();
    observeElements();
});
