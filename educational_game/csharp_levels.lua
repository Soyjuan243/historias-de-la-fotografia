local levels = {
    {
        title = "Nivel 1: Introducción a C# y Variables",
        theory = [[¡Bienvenido a la campaña de C#! C# es un lenguaje potente y tipado desarrollado por Microsoft,
        corazón del motor Unity. A diferencia de Luau, aquí cada variable debe tener un tipo definido.
        El tipo 'int' se usa para números enteros y 'string' para texto.
        Cada instrucción debe terminar obligatoriamente con un punto y coma (;).]],
        example = "int puntos = 10;",
        commonMistakes = "Olvidar el punto y coma (;) al final de la línea.",
        miniExercise = "Crea una variable entera 'vida' con valor 100.",
        puzzle = "Escribe el código para crear una variable de tipo entero llamada 'oro' con el valor 50.",
        solution = "int oro = 50;",
        explanation = "Especificamos 'int' (tipo), 'oro' (nombre), '=' (asignación), '50' (valor) y ';' (fin)."
    },
    {
        title = "Nivel 2: Cadenas de Texto (strings)",
        theory = [[En C#, el tipo 'string' se escribe en minúsculas. Las cadenas siempre deben ir
        entre comillas dobles ("").]],
        example = "string nombre = \"Unity\";",
        commonMistakes = "Usar comillas simples para strings (las simples son para el tipo 'char').",
        miniExercise = "Crea un string llamado 'mensaje'.",
        puzzle = "Crea una variable string llamada 'jugador' con el valor \"Alex\".",
        solution = "string jugador = \"Alex\";",
        explanation = "El tipo string define que la variable guardará texto."
    },
    {
        title = "Nivel 3: Números con Decimales (float)",
        theory = [[Para números con decimales usamos 'float'. En C#, al asignar un valor a un float,
        debemos añadir la letra 'f' al final del número para indicar que es un float literal.]],
        example = "float velocidad = 5.5f;",
        commonMistakes = "Olvidar la 'f' al final del número decimal.",
        miniExercise = "Crea un float llamado 'fuerza' con 10.2.",
        puzzle = "Crea una variable float 'altura' con el valor 1.75.",
        solution = "float altura = 1.75f;",
        explanation = "La 'f' es crucial para que el compilador no lo confunda con un 'double'."
    },
    {
        title = "Nivel 4: Booleanos (bool)",
        theory = [[El tipo 'bool' guarda valores true o false. Se usa para estados lógicos.]],
        example = "bool estaActivo = true;",
        commonMistakes = "Escribir True o False con mayúscula (C# es case-sensitive).",
        miniExercise = "Crea un bool 'enPausa' falso.",
        puzzle = "Crea una variable bool llamada 'estaVivo' y asígnale el valor true.",
        solution = "bool estaVivo = true;",
        explanation = "Sencillo y directo para control de flujo."
    },
    {
        title = "Nivel 5: Comentarios",
        theory = [[En C#, los comentarios de una línea usan doble barra diagonal (//).]],
        example = "// Esto es un comentario",
        commonMistakes = "Usar -- (esto es de Lua/Luau).",
        miniExercise = "Escribe un comentario que diga 'Inicio'.",
        puzzle = "Escribe un comentario que diga \"Fin del codigo\".",
        solution = "// Fin del codigo",
        explanation = "Ayuda a documentar el código sin afectar la ejecución."
    },
    {
        title = "Nivel 6: Operaciones Aritméticas",
        theory = [[C# soporta +, -, *, / y % (módulo). Puedes operar directamente al asignar.]],
        example = "int total = 10 + 20;",
        commonMistakes = "Dividir dos enteros y esperar un decimal (ej: 5/2 da 2 en C#, no 2.5).",
        miniExercise = "Multiplica 5 por 4.",
        puzzle = "Crea un int 'resultado' que sea la multiplicación de 10 por 5.",
        solution = "int resultado = 10 * 5;",
        explanation = "El asterisco (*) es el operador de multiplicación estándar."
    },
    {
        title = "Nivel 7: Concatenación de Strings",
        theory = [[En C# usamos el signo más (+) para unir textos. También podemos unir variables con texto.]],
        example = "string saludo = \"Hola \" + \"Mundo\";",
        commonMistakes = "Olvidar los espacios entre palabras.",
        miniExercise = "Une \"A\" y \"B\".",
        puzzle = "Une el string \"Nivel: \" con la variable 'num' en un string 'texto'.",
        solution = "string texto = \"Nivel: \" + num;",
        explanation = "C# convierte automáticamente 'num' a string para la unión."
    },
    {
        title = "Nivel 8: Estructuras Condicionales - IF",
        theory = [[La sentencia 'if' en C# requiere que la condición vaya entre paréntesis ().
        El bloque de código se encierra entre llaves {}.]],
        example = "if (puntos > 10) { ganar(); }",
        commonMistakes = "Olvidar los paréntesis () o usar 'then'/'end' de Lua.",
        miniExercise = "Haz un if para x == 5.",
        puzzle = "Escribe un if que verifique si 'vida' es 0 y llame a 'Morir();'.",
        solution = "if (vida == 0) { Morir(); }",
        explanation = "La sintaxis es estricta: paréntesis para la condición y llaves para el cuerpo."
    },
    {
        title = "Nivel 9: Condicionales - ELSE",
        theory = [['else' ejecuta un bloque si la condición del 'if' no se cumple.]],
        example = "if (x > 0) { ... } else { ... }",
        commonMistakes = "Olvidar cerrar la llave del if antes de empezar el else.",
        miniExercise = "Haz un if/else para 'activo'.",
        puzzle = "Si 'puntos' es mayor a 50 muestra \"Pro\", si no muestra \"Noob\" (usa Debug.Log).",
        solution = "if (puntos > 50) { Debug.Log(\"Pro\"); } else { Debug.Log(\"Noob\"); }",
        explanation = "Debug.Log es el equivalente a print en Unity/C#."
    },
    {
        title = "Nivel 10: PRIMER EXAMEN C# - Fundamentos",
        theory = [[Primer examen de C#. Debes recordar los tipos, el punto y coma, y la sintaxis del if. ¡Mucha suerte!]],
        example = "Repaso: float f = 1.0f; if (f > 0) { }",
        commonMistakes = "N/A",
        miniExercise = "N/A",
        puzzle = "Crea un int 'edad' de 18. Si es mayor o igual a 18, muestra \"Adulto\" con Debug.Log.",
        solution = "int edad = 18; if (edad >= 18) { Debug.Log(\"Adulto\"); }",
        explanation = "Integramos variable, condición y salida de consola."
    },
    {
        title = "Nivel 11: Condicionales - ELSE IF",
        theory = [[Para múltiples condiciones usamos 'else if' (dos palabras separadas).]],
        example = "if (a) { } else if (b) { }",
        commonMistakes = "Escribir 'elseif' todo junto (esto es de Lua).",
        miniExercise = "Usa else if para una tercera opción.",
        puzzle = "Si 'x' es 1 muestra \"Uno\", si es 2 muestra \"Dos\", si no muestra \"Otro\".",
        solution = "if (x == 1) { Debug.Log(\"Uno\"); } else if (x == 2) { Debug.Log(\"Dos\"); } else { Debug.Log(\"Otro\"); }",
        explanation = "Maneja múltiples estados de forma ordenada."
    },
    {
        title = "Nivel 12: Métodos Básicos (Funciones)",
        theory = [[En C#, las funciones se llaman métodos. Deben definir qué devuelven (o 'void' si no devuelven nada).
        También definen su visibilidad (ej: public, private).]],
        example = "void Saludar() { Debug.Log(\"Hola\"); }",
        commonMistakes = "Olvidar el tipo de retorno (void, int, etc).",
        miniExercise = "Crea un método void 'Test'.",
        puzzle = "Crea un método llamado 'Avisar' que no devuelva nada e imprima \"Cuidado\".",
        solution = "void Avisar() { Debug.Log(\"Cuidado\"); }",
        explanation = "Los métodos agrupan lógica reutilizable."
    },
    {
        title = "Nivel 13: Métodos con Parámetros",
        theory = [[Debes especificar el tipo de cada parámetro que recibe el método.]],
        example = "void Sumar(int a, int b) { ... }",
        commonMistakes = "No poner el tipo en los parámetros.",
        miniExercise = "Método que reciba un string 'n'.",
        puzzle = "Crea un método 'Doble' que reciba un int 'n' e imprima n * 2.",
        solution = "void Doble(int n) { Debug.Log(n * 2); }",
        explanation = "Los parámetros permiten pasar información al método."
    },
    {
        title = "Nivel 14: Métodos con Retorno",
        theory = [[Si el método devuelve algo, sustituimos 'void' por el tipo de dato y usamos 'return'.]],
        example = "int ObtenerCinco() { return 5; }",
        commonMistakes = "Decir que devuelve int pero no poner el 'return'.",
        miniExercise = "Método que retorne un bool.",
        puzzle = "Crea un método 'Area' que reciba un int 'lado' y retorne lado * lado.",
        solution = "int Area(int lado) { return lado * lado; }",
        explanation = "El valor retornado puede ser usado en otras expresiones."
    },
    {
        title = "Nivel 15: Arreglos (Arrays)",
        theory = [[Un array guarda múltiples elementos del mismo tipo. Se define con corchetes [].]],
        example = "int[] numeros = {10, 20, 30};",
        commonMistakes = "Intentar meter tipos distintos en el mismo array.",
        miniExercise = "Crea un array de strings.",
        puzzle = "Crea un array de int llamado 'notas' con los valores 5, 8, 10.",
        solution = "int[] notas = {5, 8, 10};",
        explanation = "Estructura básica para colecciones de datos fijas."
    },
    {
        title = "Nivel 16: Acceder a Arreglos",
        theory = [[Accedemos a los elementos usando el índice entre corchetes.
        ¡IMPORTANTE! En C#, los índices empiezan en 0, no en 1.]],
        example = "int primero = numeros[0];",
        commonMistakes = "Empezar en 1 (esto daría el segundo elemento).",
        miniExercise = "Obtén el segundo elemento (índice 1).",
        puzzle = "Crea una variable 'val' que obtenga el valor en la posición 0 del array 'data'.",
        solution = "int val = data[0];",
        explanation = "El primer elemento siempre es el índice 0 en lenguajes derivados de C."
    },
    {
        title = "Nivel 17: Listas Dinámicas (List)",
        theory = [[A diferencia de los arrays, las Listas pueden cambiar de tamaño.
        Usan genéricos <T> para definir el tipo.]],
        example = "List<int> lista = new List<int>();",
        commonMistakes = "Olvidar los paréntesis al final o el 'new'.",
        miniExercise = "Crea una lista de strings.",
        puzzle = "Crea una lista de int llamada 'puntos' usando new List<int>();",
        solution = "List<int> puntos = new List<int>();",
        explanation = "Las listas son mucho más flexibles para inventarios o enemigos."
    },
    {
        title = "Nivel 18: Añadir a Listas",
        theory = [[Usamos el método .Add() para añadir elementos al final de la lista.]],
        example = "lista.Add(10);",
        commonMistakes = "Intentar usar Add en un array fijo (no existe).",
        miniExercise = "Añade \"Item\" a la lista.",
        puzzle = "Añade el número 100 a la lista 'oro' usando el método Add.",
        solution = "oro.Add(100);",
        explanation = "La lista crece automáticamente al añadir elementos."
    },
    {
        title = "Nivel 19: Bucle FOR",
        theory = [[El bucle for en C# tiene tres partes: inicialización, condición e incremento.]],
        example = "for (int i = 0; i < 10; i++) { ... }",
        commonMistakes = "Usar comas en lugar de puntos y coma dentro del for.",
        miniExercise = "Haz un for del 0 al 4.",
        puzzle = "Haz un for que vaya de i=0 hasta i<3 e incremente i++.",
        solution = "for (int i = 0; i < 3; i++) { }",
        explanation = "Es la forma estándar de recorrer colecciones por índice."
    },
    {
        title = "Nivel 20: EXAMEN 2 C# - Listas y Bucles",
        theory = [[Segundo examen. Debes manejar índices (base 0), listas y la sintaxis del bucle for.]],
        example = "Repaso: for (int i=0; i < lista.Count; i++) { }",
        commonMistakes = "N/A",
        miniExercise = "N/A",
        puzzle = "Usa un for de 0 a 2 para añadir el valor de 'i' a la lista 'nums'.",
        solution = "for (int i = 0; i < 3; i++) { nums.Add(i); }",
        explanation = "Combinamos el control del bucle con la manipulación de una lista."
    },
    {
        title = "Nivel 21: Bucle WHILE",
        theory = [[Repite el código mientras la condición sea true.]],
        example = "while (vida > 0) { vida--; }",
        commonMistakes = "Crear un bucle infinito por no actualizar la condición.",
        miniExercise = "While mientras x < 10.",
        puzzle = "Crea un while que mientras 'energia' sea mayor a 0, llame a 'Trabajar();'.",
        solution = "while (energia > 0) { Trabajar(); }",
        explanation = "Útil cuando no sabes exactamente cuántas vueltas dará el bucle."
    },
    {
        title = "Nivel 22: Operadores Lógicos - AND",
        theory = [[En C#, el 'y' lógico se escribe con doble ampersand (&&).]],
        example = "if (a && b) { }",
        commonMistakes = "Usar 'and' (esto es de Lua).",
        miniExercise = "Verifica si x e y son 10.",
        puzzle = "Si 'nivel' > 5 y 'esPremium' es true, muestra \"OK\".",
        solution = "if (nivel > 5 && esPremium == true) { Debug.Log(\"OK\"); }",
        explanation = "Ambas condiciones deben ser verdaderas."
    },
    {
        title = "Nivel 23: Operadores Lógicos - OR",
        theory = [[El 'o' lógico se escribe con doble barra vertical (||).]],
        example = "if (a || b) { }",
        commonMistakes = "Usar 'or'.",
        miniExercise = "Verifica si color es \"Red\" o \"Blue\".",
        puzzle = "Si 'oro' > 100 o 'tienePase' es true, muestra \"Entra\".",
        solution = "if (oro > 100 || tienePase == true) { Debug.Log(\"Entra\"); }",
        explanation = "Basta con que una sea verdadera."
    },
    {
        title = "Nivel 24: Operador Lógico - NOT",
        theory = [[El 'no' lógico es el signo de exclamación (!).]],
        example = "if (!estaMuerto) { }",
        commonMistakes = "Usar 'not'.",
        miniExercise = "Invierte 'activo'.",
        puzzle = "Si 'estaCansado' NO es true, muestra \"Corre\".",
        solution = "if (!estaCansado) { Debug.Log(\"Corre\"); }",
        explanation = "Invierte el valor booleano."
    },
    {
        title = "Nivel 25: Clases y Objetos",
        theory = [[C# es orientado a objetos. Una 'class' es el molde para crear objetos.]],
        example = "class Player { public int vida; }",
        commonMistakes = "Olvidar las llaves o el nombre de la clase.",
        miniExercise = "Crea una clase vacía 'Enemigo'.",
        puzzle = "Crea una clase 'Arma' con un campo public int 'daño'.",
        solution = "class Arma { public int daño; }",
        explanation = "Las clases definen propiedades y comportamientos."
    },
    {
        title = "Nivel 26: Instanciar Objetos (new)",
        theory = [[Para crear un objeto a partir de una clase usamos la palabra 'new'.]],
        example = "Player p = new Player();",
        commonMistakes = "Olvidar los paréntesis al final.",
        miniExercise = "Crea un objeto de 'Enemigo'.",
        puzzle = "Crea una variable 'miEspada' de tipo 'Arma' usando new Arma();",
        solution = "Arma miEspada = new Arma();",
        explanation = "Esto crea una instancia única en memoria."
    },
    {
        title = "Nivel 27: Constructores",
        theory = [[Un constructor es un método especial que se ejecuta al crear el objeto.
        Se llama igual que la clase.]],
        example = "public Player() { vida = 100; }",
        commonMistakes = "Ponerle un tipo de retorno (los constructores no llevan, ni siquiera void).",
        miniExercise = "Crea un constructor para 'Arma'.",
        puzzle = "En la clase 'Item', crea un constructor public Item() que asigne 1 a 'id'.",
        solution = "public Item() { id = 1; }",
        explanation = "Sirve para inicializar el estado del objeto."
    },
    {
        title = "Nivel 28: Herencia",
        theory = [[Una clase puede heredar de otra usando los dos puntos (:).]],
        example = "class Guerrero : Player { }",
        commonMistakes = "Invertir el orden (Hijo : Padre).",
        miniExercise = "Haz que 'Mago' herede de 'Player'.",
        puzzle = "Crea una clase 'Espada' que herede de 'Arma'.",
        solution = "class Espada : Arma { }",
        explanation = "Permite reutilizar código de clases base."
    },
    {
        title = "Nivel 29: El modificador 'static'",
        theory = [['static' significa que algo pertenece a la clase en sí, no a los objetos individuales.]],
        example = "public static int totalJugadores;",
        commonMistakes = "Intentar usar 'this' o miembros no estáticos dentro de algo estático.",
        miniExercise = "Crea un int estático 'cuenta'.",
        puzzle = "Crea una variable public static int 'instancias' en la clase 'Global'.",
        solution = "public static int instancias;",
        explanation = "Muy útil para contadores globales o utilidades."
    },
    {
        title = "Nivel 30: EXAMEN 3 C# - Objetos",
        theory = [[Examen intermedio. Debes dominar clases, herencia y la creación de objetos.]],
        example = "Repaso: class A : B { } A obj = new A();",
        commonMistakes = "N/A",
        miniExercise = "N/A",
        puzzle = "Crea una clase 'Coche' con un constructor que asigne 4 a 'ruedas'.",
        solution = "class Coche { public int ruedas; public Coche() { ruedas = 4; } }",
        explanation = "Integramos definición de clase, campo y constructor."
    },
    {
        title = "Nivel 31: Propiedades (Getters y Setters)",
        theory = [[Las propiedades permiten controlar el acceso a los campos de una clase.]],
        example = "public int Vida { get; set; }",
        commonMistakes = "N/A",
        miniExercise = "Crea una propiedad 'Puntos'.",
        puzzle = "Crea una propiedad pública int 'Nivel' con get y set automáticos.",
        solution = "public int Nivel { get; set; }",
        explanation = "Es la forma recomendada de exponer datos en C#."
    },
    {
        title = "Nivel 32: Espacios de Nombres (namespaces)",
        theory = [[Los namespaces organizan el código y evitan conflictos de nombres.]],
        example = "namespace MiJuego { ... }",
        commonMistakes = "N/A",
        miniExercise = "Envuelve una clase en un namespace.",
        puzzle = "Crea un namespace llamado 'Juego' y cierra su llave.",
        solution = "namespace Juego { }",
        explanation = "Ayuda a mantener el proyecto estructurado."
    },
    {
        title = "Nivel 33: La directiva 'using'",
        theory = [['using' permite usar clases de otros namespaces sin escribir la ruta completa.]],
        example = "using UnityEngine;",
        commonMistakes = "Olvidar el punto y coma al final del using.",
        miniExercise = "Usa el namespace 'System'.",
        puzzle = "Escribe la directiva using para el namespace 'System.Collections.Generic'.",
        solution = "using System.Collections.Generic;",
        explanation = "Esencial para acceder a Listas y otras herramientas de C#."
    },
    {
        title = "Nivel 34: Enumeraciones (enum)",
        theory = [[Los enums definen un conjunto de constantes con nombre.]],
        example = "enum Estado { Idle, Run, Jump }",
        commonMistakes = "Poner punto y coma entre los elementos del enum (se usan comas).",
        miniExercise = "Crea un enum 'Rarity'.",
        puzzle = "Crea un enum 'Dificultad' con los valores Facil, Medio, Dificil.",
        solution = "enum Dificultad { Facil, Medio, Dificil }",
        explanation = "Hace que el código sea mucho más legible que usar números sueltos."
    },
    {
        title = "Nivel 35: Switch Statement",
        theory = [[Switch es una alternativa limpia a múltiples 'else if' cuando comparas la misma variable.]],
        example = "switch(x) { case 1: ... break; }",
        commonMistakes = "Olvidar el 'break;' después de cada caso.",
        miniExercise = "Haz un switch para una variable 'e'.",
        puzzle = "Haz un switch para 'estado' con un 'case 0:' que llame a 'Stop();' y su 'break;'.",
        solution = "switch (estado) { case 0: Stop(); break; }",
        explanation = "Estructura de control muy eficiente para máquinas de estado."
    },
    {
        title = "Nivel 36: Excepciones (try-catch)",
        theory = [[Permite manejar errores sin que el programa se detenga abruptamente.]],
        example = "try { ... } catch (Exception e) { ... }",
        commonMistakes = "No especificar el bloque catch.",
        miniExercise = "Crea un bloque try vacío.",
        puzzle = "Crea un bloque 'try { Abrir(); }' seguido de un 'catch { }'.",
        solution = "try { Abrir(); } catch { }",
        explanation = "Protege tu código contra fallos inesperados."
    },
    {
        title = "Nivel 37: Interfaces",
        theory = [[Una interfaz define un contrato que las clases deben cumplir. No tiene lógica, solo firmas.]],
        example = "interface IDañable { void RecibirDaño(int d); }",
        commonMistakes = "Intentar poner código dentro de los métodos de la interfaz.",
        miniExercise = "Crea una interfaz 'IItem'.",
        puzzle = "Crea una interfaz 'IInteractuable' con un método 'void Interactuar();'.",
        solution = "interface IInteractuable { void Interactuar(); }",
        explanation = "Permite el polimorfismo: tratar objetos distintos de la misma forma."
    },
    {
        title = "Nivel 38: Genéricos (Generics)",
        theory = [[Permiten crear clases o métodos que funcionan con cualquier tipo de dato.]],
        example = "class Caja<T> { public T contenido; }",
        commonMistakes = "Confundir T con un nombre de clase real.",
        miniExercise = "Método genérico <T>.",
        puzzle = "Crea una clase genérica 'Contenedor<T>' con un campo público 'T' llamado 'item'.",
        solution = "class Contenedor<T> { public T item; }",
        explanation = "Base de colecciones potentes como List<T>."
    },
    {
        title = "Nivel 39: LINQ - Introducción",
        theory = [[LINQ permite realizar consultas sobre colecciones de forma muy sencilla.]],
        example = "lista.Where(x => x > 5).ToList();",
        commonMistakes = "Olvidar importar System.Linq.",
        miniExercise = "Usa .Count() en una lista.",
        puzzle = "Usa .First() sobre la lista 'nombres' para obtener el primer elemento.",
        solution = "nombres.First();",
        explanation = "Ahorra muchísimas líneas de bucles manuales."
    },
    {
        title = "Nivel 40: EXAMEN 4 C# - Arquitectura",
        theory = [[Cuarto examen. Switch, Enums, Interfaces y Namespaces. ¡Casi terminas!]],
        example = "Repaso: enum E { } interface I { } switch(v) { }",
        commonMistakes = "N/A",
        miniExercise = "N/A",
        puzzle = "Crea una interfaz 'IArma' con 'int GetDaño();' y un enum 'Tipo' con 'Espada'.",
        solution = "interface IArma { int GetDaño(); } enum Tipo { Espada }",
        explanation = "Definiendo los contratos básicos de un sistema de juego."
    },
    {
        title = "Nivel 41: Corrutinas (Unity)",
        theory = [[Las corrutinas permiten pausar la ejecución de un método y retomarlo más tarde.]],
        example = "IEnumerator Test() { yield return new WaitForSeconds(1); }",
        commonMistakes = "Olvidar el 'yield return'.",
        miniExercise = "Crea un IEnumerator.",
        puzzle = "Crea un IEnumerator 'Espera' que haga 'yield return null;'.",
        solution = "IEnumerator Espera() { yield return null; }",
        explanation = "Fundamental para temporizadores y efectos visuales en Unity."
    },
    {
        title = "Nivel 42: Delegados y Eventos",
        theory = [[Los delegados son referencias a métodos. Los eventos permiten notificar cambios a otros scripts.]],
        example = "public delegate void AlMorir(); public event AlMorir OnMorir;",
        commonMistakes = "Lanzar el evento sin comprobar si alguien está escuchando (null check).",
        miniExercise = "Crea un delegado void.",
        puzzle = "Crea un 'public delegate void Cambio();' y un 'public event Cambio OnCambio;'.",
        solution = "public delegate void Cambio(); public event Cambio OnCambio;",
        explanation = "Esencial para desacoplar el código."
    },
    {
        title = "Nivel 43: Diccionarios (Dictionary)",
        theory = [[Guardan pares clave-valor. Muy rápidos para buscar datos por una clave.]],
        example = "Dictionary<string, int> inventario = new Dictionary<string, int>();",
        commonMistakes = "N/A",
        miniExercise = "Crea un diccionario int, string.",
        puzzle = "Crea un Dictionary con clave 'string' y valor 'float' llamado 'stats'.",
        solution = "Dictionary<string, float> stats = new Dictionary<string, float>();",
        explanation = "Ideal para bases de datos de items o configuraciones."
    },
    {
        title = "Nivel 44: Atributos",
        theory = [[Los atributos añaden metadatos al código. En Unity, [SerializeField] muestra variables privadas en el editor.]],
        example = "[SerializeField] private int vida;",
        commonMistakes = "N/A",
        miniExercise = "Usa [SerializeField].",
        puzzle = "Añade el atributo [SerializeField] a la variable 'private float velocidad;'.",
        solution = "[SerializeField] private float velocidad;",
        explanation = "Permite configurar scripts desde el editor de Unity sin romper la encapsulación."
    },
    {
        title = "Nivel 45: Métodos de Extensión",
        theory = [[Permiten añadir métodos a clases existentes sin modificarlas ni heredar de ellas.]],
        example = "public static void Test(this string s) { ... }",
        commonMistakes = "Olvidar que la clase y el método deben ser estáticos y usar 'this'.",
        miniExercise = "Crea un método de extensión para int.",
        puzzle = "Crea un 'public static void Grito(this string s) { }' en una clase estática.",
        solution = "public static void Grito(this string s) { }",
        explanation = "Muy útil para añadir utilidades personalizadas a tipos básicos."
    },
    {
        title = "Nivel 46: Programación Asíncrona (async/await)",
        theory = [[Permite realizar tareas en segundo plano sin bloquear el hilo principal (UI/Juego).]],
        example = "async Task Cargar() { await Task.Delay(1000); }",
        commonMistakes = "N/A",
        miniExercise = "Crea un método async.",
        puzzle = "Crea un 'async Task Tarea()' que contenga 'await Task.Yield();'.",
        solution = "async Task Tarea() { await Task.Yield(); }",
        explanation = "Moderniza el manejo de tareas pesadas o red."
    },
    {
        title = "Nivel 47: Estructuras (struct)",
        theory = [[Similares a las clases pero son tipos de valor. Ideales para datos pequeños y simples.]],
        example = "struct Vector2 { public float x, y; }",
        commonMistakes = "Intentar usar herencia con structs (no soportan herencia de clases/structs).",
        miniExercise = "Crea un struct 'Punto'.",
        puzzle = "Crea un struct 'Color' con 'public float r, g, b;'.",
        solution = "struct Color { public float r, g, b; }",
        explanation = "Más eficientes para datos que se crean y destruyen constantemente."
    },
    {
        title = "Nivel 48: Operador Null-conditional (?.)",
        theory = [[Evita errores de 'NullReferenceException' al acceder a miembros de objetos que podrían ser null.]],
        example = "jugador?.Atacar();",
        commonMistakes = "N/A",
        miniExercise = "Usa ?. en un objeto 'obj'.",
        puzzle = "Usa el operador ?. para llamar al método 'Save()' de la variable 'datos'.",
        solution = "datos?.Save();",
        explanation = "Hace el código mucho más robusto y limpio."
    },
    {
        title = "Nivel 49: Proyecto Final C# Parte 1",
        theory = [[Vamos a estructurar un sistema de combate básico con una interfaz y una clase.]],
        example = "interface I { } class C : I { }",
        commonMistakes = "N/A",
        miniExercise = "N/A",
        puzzle = "Crea la interfaz 'IDañable' con 'void Daño(int n);' y la clase 'Caja' que la implemente.",
        solution = "interface IDañable { void Daño(int n); } class Caja : IDañable { public void Daño(int n) { } }",
        explanation = "Sentando las bases de un sistema interactivo."
    },
    {
        title = "Nivel 50: DESAFÍO FINAL - Arquitecto C#",
        theory = [[¡Nivel Final! Crea un sistema de jugador con una propiedad Vida,
        un evento OnDeath y un método para recibir daño que lance el evento si vida <= 0.
        ¡Eres un Arquitecto de Unity!]],
        example = "public event Action OnDeath; ... OnDeath?.Invoke();",
        commonMistakes = "N/A",
        miniExercise = "N/A",
        puzzle = "Crea la clase 'Heroe' con 'public int vida = 100;', el evento 'public event Action AlMorir;' y el método 'public void Herir(int n) { vida -= n; if(vida <= 0) AlMorir?.Invoke(); }'.",
        solution = "class Heroe { public int vida = 100; public event Action AlMorir; public void Herir(int n) { vida -= n; if (vida <= 0) AlMorir?.Invoke(); } }",
        explanation = "¡Impresionante! Has completado el bootcamp de C#. Dominas la lógica, los objetos y los eventos."
    }
}

return levels
