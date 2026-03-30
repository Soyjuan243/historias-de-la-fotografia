local levels = {
    {
        title = "Nivel 1: Introducción a Luau y Variables",
        theory = [[¡Bienvenido a la campaña de Luau! Luau es una versión optimizada de Lua utilizada principalmente en Roblox.
        En programación, una variable es como una caja donde guardas información.
        Para crear una variable en Luau usamos la palabra clave 'local'.
        Esto asegura que la variable solo exista en la parte del código donde se creó, lo cual es una buena práctica.]],
        example = "local miMensaje = \"Hola Roblox\"",
        commonMistakes = "Olvidar escribir 'local' antes del nombre de la variable.",
        miniExercise = "Crea una variable local llamada 'oro' y asígnale el valor 100.",
        puzzle = "Escribe el código para crear una variable local llamada 'puntos' con el valor 50.",
        solution = "local puntos = 50",
        explanation = "Usamos 'local' para definir el alcance, 'puntos' como identificador y '=' para asignar el número 50."
    },
    {
        title = "Nivel 2: Tipos de Datos - Números",
        theory = [[Los números son fundamentales. En Luau, no necesitas especificar si un número es entero o decimal;
        el lenguaje lo maneja por ti. Puedes realizar operaciones matemáticas básicas como suma (+), resta (-),
        multiplicación (*) y división (/).]],
        example = "local suma = 10 + 5",
        commonMistakes = "Usar comas para decimales en lugar de puntos (usa 1.5, no 1,5).",
        miniExercise = "Calcula 20 por 3 en una variable local.",
        puzzle = "Crea una variable local 'total' que sea la suma de 25 y 75.",
        solution = "local total = 25 + 75",
        explanation = "Definimos 'total' y realizamos la operación aritmética directamente en la asignación."
    },
    {
        title = "Nivel 3: Tipos de Datos - Strings (Cadenas)",
        theory = [[Un 'string' es una secuencia de caracteres, básicamente texto.
        Para definir un string, debes envolver el texto en comillas dobles ("") o simples ('').
        Es importante ser consistente.]],
        example = "local nombre = \"Jules\"",
        commonMistakes = "Abrir con comilla doble y cerrar con comilla simple.",
        miniExercise = "Crea una variable con tu nombre.",
        puzzle = "Crea una variable local llamada 'juego' con el texto \"Bloxburg\".",
        solution = "local juego = \"Bloxburg\"",
        explanation = "El texto debe ir entre comillas para que el lenguaje lo reconozca como string y no como otra variable."
    },
    {
        title = "Nivel 4: Concatenación de Strings",
        theory = [[Concatenar significa unir dos o más textos. En Luau usamos dos puntos seguidos (..) para esto.
        Puedes unir variables con texto fijo o varias variables entre sí.]],
        example = "local saludo = \"Hola \" .. \"Mundo\"",
        commonMistakes = "Olvidar los espacios dentro del texto; \"Hola\" .. \"Juan\" resulta en \"HolaJuan\".",
        miniExercise = "Une \"A\" con \"B\".",
        puzzle = "Une la variable 'prefijo' (que vale \"Nivel \") con el número 1 en una variable 'resultado'.",
        solution = "local resultado = \"Nivel \" .. 1",
        explanation = "El operador .. convierte automáticamente el número a texto para unirlo."
    },
    {
        title = "Nivel 5: Booleanos (Verdadero o Falso)",
        theory = [[Los booleanos representan valores lógicos: true (verdadero) o false (falso).
        Son esenciales para la toma de decisiones en el código, como verificar si un jugador está vivo o tiene suficiente dinero.]],
        example = "local estaVivo = true",
        commonMistakes = "Escribir True o False con mayúscula (Luau distingue entre mayúsculas y minúsculas).",
        miniExercise = "Define una variable como falsa.",
        puzzle = "Crea una variable local 'esSocio' y asígnale el valor verdadero.",
        solution = "local esSocio = true",
        explanation = "En Luau, true y false son palabras reservadas y deben ir en minúsculas."
    },
    {
        title = "Nivel 6: Comentarios en el Código",
        theory = [[Los comentarios son notas que dejas para ti o para otros programadores.
        El ordenador ignora estas líneas. En Luau, un comentario de una sola línea empieza con dos guiones (--).]],
        example = "-- Esto es un comentario",
        commonMistakes = "Usar // o # para comentar (estos se usan en otros lenguajes).",
        miniExercise = "Escribe un comentario que diga 'Hola'.",
        puzzle = "Escribe un comentario que diga \"Fin del bloque\".",
        solution = "-- Fin del bloque",
        explanation = "Cualquier texto después de -- en la misma línea es ignorado por el motor de ejecución."
    },
    {
        title = "Nivel 7: Operadores de Comparación",
        theory = [[Usamos operadores para comparar valores: == (igual a), ~= (diferente de), > (mayor que), < (menor que).
        El resultado de una comparación siempre es un valor booleano (true o false).]],
        example = "local esIgual = (5 == 5) -- true",
        commonMistakes = "Confundir = (asignar valor) con == (comparar igualdad).",
        miniExercise = "Compara si 10 es mayor que 5.",
        puzzle = "Compara si 10 es diferente de 20 y guarda el resultado en 'esDiferente'.",
        solution = "local esDiferente = 10 ~= 20",
        explanation = "El operador ~= significa 'no es igual a'."
    },
    {
        title = "Nivel 8: Estructuras Condicionales - IF",
        theory = [[La sentencia 'if' permite ejecutar código solo si se cumple una condición.
        La estructura básica es: if [condición] then [código] end.
        Es fundamental cerrar siempre el bloque con la palabra 'end'.]],
        example = "if puntos > 10 then print(\"Ganaste\") end",
        commonMistakes = "Olvidar el 'then' o el 'end'.",
        miniExercise = "Haz un if que verifique si x es 5.",
        puzzle = "Escribe un if que verifique si 'vida' es 0 y entonces llame a 'morir()'.",
        solution = "if vida == 0 then morir() end",
        explanation = "La condición usa == para comparar, 'then' inicia el bloque y 'end' lo cierra."
    },
    {
        title = "Nivel 9: Condicionales - ELSE",
        theory = [['else' se usa junto con 'if' para ejecutar un bloque de código alternativo
        si la condición inicial resulta ser falsa. Se lee como 'si no...entonces'.]],
        example = "if vida > 0 then print(\"Vivo\") else print(\"Muerto\") end",
        commonMistakes = "Poner un 'end' antes del 'else'. Solo hay un 'end' al final de toda la estructura.",
        miniExercise = "Haz un if/else para puntos.",
        puzzle = "Si 'puntos' es mayor a 50 muestra \"Pro\", si no muestra \"Noob\" (usa print).",
        solution = "if puntos > 50 then print(\"Pro\") else print(\"Noob\") end",
        explanation = "El bloque else captura todos los casos donde la condición puntos > 50 es falsa."
    },
    {
        title = "Nivel 10: PRIMER EXAMEN - Fundamentos",
        theory = [[Has llegado al primer examen. Aquí demostras que dominas lo básico:
        variables, tipos de datos y condicionales simples. No hay pistas aquí, ¡buena suerte!]],
        example = "Repaso: local x = 10; if x == 10 then x = 20 end",
        commonMistakes = "N/A",
        miniExercise = "N/A",
        puzzle = "Crea una variable 'edad', asígnale 18. Si 'edad' es mayor o igual a 18, muestra \"Adulto\" con print.",
        solution = "local edad = 18 if edad >= 18 then print(\"Adulto\") end",
        explanation = "Combinamos la creación de variable con una comparación >= y una acción condicional."
    },
    {
        title = "Nivel 11: Estructuras Condicionales - ELSEIF",
        theory = [[Cuando tienes más de dos opciones, usas 'elseif'.
        Esto te permite encadenar múltiples condiciones de forma eficiente.]],
        example = "if x == 1 then ... elseif x == 2 then ... end",
        commonMistakes = "Escribir 'else if' (con espacio). En Luau es una sola palabra: 'elseif'.",
        miniExercise = "Usa elseif para una tercera opción.",
        puzzle = "Si 'monedas' es 10 muestra \"Poco\", si es 100 muestra \"Mucho\", si no muestra \"Nada\".",
        solution = "if monedas == 10 then print(\"Poco\") elseif monedas == 100 then print(\"Mucho\") else print(\"Nada\") end",
        explanation = "Encadenamos condiciones para manejar diferentes estados de la variable monedas."
    },
    {
        title = "Nivel 12: Funciones Básicas",
        theory = [[Las funciones son bloques de código reutilizables que realizan una tarea específica.
        Se definen con 'function' y se cierran con 'end'. Puedes 'llamarlas' por su nombre para ejecutarlas.]],
        example = "function saludar() print(\"Hola\") end",
        commonMistakes = "Definir la función pero olvidar llamarla (ejecutarla).",
        miniExercise = "Crea una función llamada 'test'.",
        puzzle = "Crea una función local llamada 'avisar' que imprima \"Cuidado\".",
        solution = "local function avisar() print(\"Cuidado\") end",
        explanation = "Usamos 'local function' para que la función sea local al script, lo cual es más eficiente."
    },
    {
        title = "Nivel 13: Funciones con Parámetros",
        theory = [[Los parámetros son variables que una función recibe para trabajar con ellos.
        Hacen que las funciones sean mucho más flexibles y potentes.]],
        example = "function sumar(a, b) print(a + b) end",
        commonMistakes = "No pasar el número correcto de argumentos al llamar la función.",
        miniExercise = "Función que reciba un nombre.",
        puzzle = "Crea una función 'doble' que reciba 'n' e imprima n * 2.",
        solution = "function doble(n) print(n * 2) end",
        explanation = "El parámetro 'n' actúa como una variable local dentro de la función que toma el valor que le pases."
    },
    {
        title = "Nivel 14: Funciones con Retorno (return)",
        theory = [[A veces no quieres que la función imprima algo, sino que te 'devuelva' un resultado
        para usarlo en otra parte del código. Para eso usamos la palabra 'return'.]],
        example = "function obtenerCinco() return 5 end",
        commonMistakes = "Escribir código después del 'return' dentro de la misma función (nunca se ejecutará).",
        miniExercise = "Función que retorne true.",
        puzzle = "Crea una función 'area' que reciba 'lado' y retorne lado * lado.",
        solution = "function area(lado) return lado * lado end",
        explanation = "El valor calculado es enviado de vuelta a quien llamó la función."
    },
    {
        title = "Nivel 15: Introducción a Tablas",
        theory = [[Las tablas son el único tipo de dato compuesto en Luau.
        Pueden usarse como listas (arrays) o como diccionarios. Se definen con llaves {}.]],
        example = "local lista = {10, 20, 30}",
        commonMistakes = "Olvidar que en Luau, las listas empiezan en el índice 1, no en 0.",
        miniExercise = "Crea una tabla vacía.",
        puzzle = "Crea una tabla local llamada 'colores' con \"Rojo\", \"Verde\" y \"Azul\".",
        solution = "local colores = {\"Rojo\", \"Verde\", \"Azul\"}",
        explanation = "Los elementos se separan por comas dentro de las llaves."
    },
    {
        title = "Nivel 16: Acceder a Elementos de una Tabla",
        theory = [[Para obtener un valor de una tabla tipo lista, usamos corchetes [] con el índice numérico.
        Recuerda: el primer elemento está en el índice 1.]],
        example = "local primerColor = colores[1]",
        commonMistakes = "Intentar acceder al índice 0.",
        miniExercise = "Obtén el segundo elemento de una tabla 'datos'.",
        puzzle = "Crea una variable 'tercero' que obtenga el valor en la posición 3 de la tabla 'numeros'.",
        solution = "local tercero = numeros[3]",
        explanation = "Usamos el nombre de la tabla seguido de [3] para extraer ese valor específico."
    },
    {
        title = "Nivel 17: Diccionarios (Tablas con Claves)",
        theory = [[Los diccionarios usan palabras (claves) en lugar de números para identificar los valores.
        Es ideal para guardar propiedades de un objeto.]],
        example = "local jugador = {vida = 100, nombre = \"Robloxian\"}",
        commonMistakes = "Olvidar los nombres de las claves o confundir con una lista.",
        miniExercise = "Crea un diccionario para una fruta con su color.",
        puzzle = "Crea una tabla 'arma' con las claves 'daño' (50) y 'tipo' (\"Espada\").",
        solution = "local arma = {daño = 50, tipo = \"Espada\"}",
        explanation = "Las claves permiten organizar la información de forma semántica y legible."
    },
    {
        title = "Nivel 18: Acceder a Diccionarios",
        theory = [[Puedes acceder a los valores de un diccionario usando el punto (.) si la clave es un nombre válido,
        o corchetes con el string de la clave.]],
        example = "print(jugador.vida) -- o jugador[\"vida\"]",
        commonMistakes = "Intentar usar el punto con una clave que empieza por número.",
        miniExercise = "Imprime la propiedad 'color' de 'fruta'.",
        puzzle = "Obtén el 'daño' de la tabla 'arma' y guárdalo en la variable 'puntosDaño'.",
        solution = "local puntosDaño = arma.daño",
        explanation = "La sintaxis de punto es la forma más común y limpia de acceder a diccionarios en Luau."
    },
    {
        title = "Nivel 19: Bucle FOR (Contador)",
        theory = [[Los bucles permiten repetir código. El bucle 'for' numérico se usa cuando sabes cuántas veces
        quieres repetir algo. Sintaxis: for i = inicio, fin, incremento do ... end.]],
        example = "for i = 1, 10 do print(i) end",
        commonMistakes = "Olvidar el 'do' o el 'end'.",
        miniExercise = "Haz un bucle del 1 al 5.",
        puzzle = "Haz un bucle que vaya del 1 al 3 e imprima \"Repetir\".",
        solution = "for i = 1, 3 do print(\"Repetir\") end",
        explanation = "El bloque de código entre 'do' y 'end' se ejecutará exactamente 3 veces."
    },
    {
        title = "Nivel 20: EXAMEN 2 - Tablas y Bucles",
        theory = [[Segundo gran examen. Debes demostrar que entiendes cómo organizar datos en tablas
        y cómo repetir tareas con bucles. ¡Sin ayudas!]],
        example = "Repaso: for i=1,#tabla do print(tabla[i]) end",
        commonMistakes = "N/A",
        miniExercise = "N/A",
        puzzle = "Crea una tabla 'nums' con 1, 2, 3. Usa un bucle for del 1 al 3 para imprimir cada elemento de 'nums'.",
        solution = "local nums = {1, 2, 3} for i = 1, 3 do print(nums[i]) end",
        explanation = "Combinamos la creación de una tabla con un bucle que usa el índice 'i' para acceder a cada valor."
    },
    {
        title = "Nivel 21: Bucle WHILE",
        theory = [[El bucle 'while' repite el código mientras una condición sea verdadera.
        Ten cuidado: si la condición nunca cambia a falso, el juego se congelará (bucle infinito).]],
        example = "while vida > 0 do vida = vida - 1 end",
        commonMistakes = "No actualizar la variable de la condición dentro del bucle.",
        miniExercise = "While que verifique si x < 10.",
        puzzle = "Crea un while que mientras 'energia' sea mayor a 0, llame a 'trabajar()'.",
        solution = "while energia > 0 do trabajar() end",
        explanation = "La función trabajar() debe, idealmente, reducir la energía en algún punto."
    },
    {
        title = "Nivel 22: Operadores Lógicos - AND",
        theory = [[El operador 'and' permite combinar dos condiciones.
        Ambas deben ser verdaderas para que el resultado total sea verdadero.]],
        example = "if tieneLlave and estaCerca then abrirPuerta() end",
        commonMistakes = "Usar && en lugar de la palabra 'and'.",
        miniExercise = "Verifica si x es 10 y y es 20.",
        puzzle = "Si 'nivel' es mayor a 5 y 'esPremium' es true, muestra \"Acceso\".",
        solution = "if nivel > 5 and esPremium == true then print(\"Acceso\") end",
        explanation = "Ambas partes de la expresión deben cumplirse simultáneamente."
    },
    {
        title = "Nivel 23: Operadores Lógicos - OR",
        theory = [[El operador 'or' resulta verdadero si al menos una de las condiciones es verdadera.]],
        example = "if esAdmin or esModerador then banear() end",
        commonMistakes = "Usar || en lugar de 'or'.",
        miniExercise = "Verifica si color es 'Rojo' o 'Azul'.",
        puzzle = "Si 'oro' es mayor a 100 o 'tienePase' es true, muestra \"Entrar\".",
        solution = "if oro > 100 or tienePase == true then print(\"Entrar\") end",
        explanation = "Basta con que se cumpla una de las dos condiciones para entrar al bloque."
    },
    {
        title = "Nivel 24: Operador Lógico - NOT",
        theory = [[El operador 'not' invierte un valor booleano. Lo que es true pasa a ser false y viceversa.]],
        example = "if not estaMuerto then print(\"Sigue luchando\") end",
        commonMistakes = "Usar ! en lugar de 'not'.",
        miniExercise = "Invierte el valor de una variable 'activo'.",
        puzzle = "Si 'estaCansado' NO es verdadero, muestra \"Correr\".",
        solution = "if not estaCansado then print(\"Correr\") end",
        explanation = "'not estaCansado' es equivalente a decir 'estaCansado == false'."
    },
    {
        title = "Nivel 25: El Operador de Longitud (#)",
        theory = [[Para saber cuántos elementos tiene una tabla (lista), usamos el símbolo # seguido del nombre de la tabla.]],
        example = "local total = #misAmigos",
        commonMistakes = "Intentar usar # en diccionarios (solo funciona con listas numéricas continuas).",
        miniExercise = "Obtén el tamaño de la tabla 'frutas'.",
        puzzle = "Crea una variable 'n' que guarde la cantidad de elementos en la tabla 'inventario'.",
        solution = "local n = #inventario",
        explanation = "Este operador es muy útil para recorrer tablas dinámicas con bucles for."
    },
    {
        title = "Nivel 26: Recorrer Tablas con ipairs",
        theory = [['ipairs' es un iterador especial para listas. Te devuelve el índice y el valor en cada paso del bucle.]],
        example = "for i, v in ipairs(lista) do print(v) end",
        commonMistakes = "Usar ipairs en diccionarios con claves de texto.",
        miniExercise = "Recorre 'nombres' con ipairs.",
        puzzle = "Usa ipairs para recorrer 'premios' e imprimir cada valor 'v'.",
        solution = "for i, v in ipairs(premios) do print(v) end",
        explanation = "Es la forma más segura y legible de procesar todos los elementos de una lista."
    },
    {
        title = "Nivel 27: Recorrer Diccionarios con pairs",
        theory = [['pairs' funciona de forma similar a ipairs, pero sirve para cualquier tabla, incluyendo diccionarios.]],
        example = "for clave, valor in pairs(jugador) do print(clave, valor) end",
        commonMistakes = "Asumir que pairs recorrerá la tabla en un orden específico (es aleatorio).",
        miniExercise = "Recorre un diccionario 'config'.",
        puzzle = "Usa pairs para recorrer la tabla 'stats' e imprimir cada 'clave' y 'valor'.",
        solution = "for clave, valor in pairs(stats) do print(clave, valor) end",
        explanation = "Pairs es universal para tablas, pero no garantiza el orden de los elementos."
    },
    {
        title = "Nivel 28: Insertar en Tablas",
        theory = [[La librería 'table' incluye funciones útiles. table.insert(tabla, valor) añade un elemento al final.]],
        example = "table.insert(miLista, \"Nuevo Item\")",
        commonMistakes = "Olvidar que el primer argumento es la tabla y el segundo el valor.",
        miniExercise = "Añade 500 a 'precios'.",
        puzzle = "Usa table.insert para añadir \"Diamante\" a la tabla 'mochila'.",
        solution = "table.insert(mochila, \"Diamante\")",
        explanation = "La tabla se modifica directamente añadiendo el valor en la siguiente posición disponible."
    },
    {
        title = "Nivel 29: Remover de Tablas",
        theory = [[table.remove(tabla, indice) elimina el elemento en esa posición y desplaza los demás para llenar el hueco.]],
        example = "table.remove(miLista, 1) -- Borra el primero",
        commonMistakes = "No especificar el índice si quieres borrar algo que no sea el último elemento.",
        miniExercise = "Borra el segundo elemento de 'cola'.",
        puzzle = "Elimina el primer elemento de la tabla 'tareas' usando table.remove.",
        solution = "table.remove(tareas, 1)",
        explanation = "Al remover el índice 1, el que estaba en el 2 pasa a ser el nuevo 1."
    },
    {
        title = "Nivel 30: EXAMEN 3 - Lógica Avanzada",
        theory = [[Has llegado al ecuador de la campaña. Aquí mezclaremos todo: lógica, tablas y bucles avanzados.]],
        example = "Repaso: table.insert(t, val); if #t > 10 then print(\"Lleno\") end",
        commonMistakes = "N/A",
        miniExercise = "N/A",
        puzzle = "Si la longitud de 'inventario' es menor a 3, añade \"Poción\" a la tabla.",
        solution = "if #inventario < 3 then table.insert(inventario, \"Poción\") end",
        explanation = "Combinamos el operador de longitud con una condición y la función de inserción."
    },
    {
        title = "Nivel 31: Manipulación de Strings - string.upper",
        theory = [[La librería 'string' permite manipular texto. string.upper(s) convierte todo a mayúsculas.]],
        example = "local grito = string.upper(\"hola\") -- \"HOLA\"",
        commonMistakes = "Olvidar que las funciones de string devuelven un nuevo valor, no modifican el original.",
        miniExercise = "Convierte 'nombre' a mayúsculas.",
        puzzle = "Crea una variable 'u' que sea la versión en mayúsculas de \"aviso\".",
        solution = "local u = string.upper(\"aviso\")",
        explanation = "Útil para normalizar entradas de usuario o resaltar mensajes importantes."
    },
    {
        title = "Nivel 32: Manipulación de Strings - string.lower",
        theory = [[string.lower(s) convierte un texto a minúsculas. Ideal para comparaciones de comandos.]],
        example = "local low = string.lower(\"BYE\") -- \"bye\"",
        commonMistakes = "N/A",
        miniExercise = "Convierte \"LUAU\" a minúsculas.",
        puzzle = "Convierte la variable 'entrada' a minúsculas y guárdala en 'comando'.",
        solution = "local comando = string.lower(entrada)",
        explanation = "Asegura que el código sea insensible a mayúsculas si así lo deseas."
    },
    {
        title = "Nivel 33: Longitud de String (string.len)",
        theory = [[Puedes usar string.len(s) o el operador # para saber cuántos caracteres tiene un string.]],
        example = "local largo = #\"hola\" -- 4",
        commonMistakes = "Confundir longitud de string con el valor numérico que pueda contener.",
        miniExercise = "Obtén el largo de 'password'.",
        puzzle = "Si el largo de 'nombre' es mayor a 10, muestra \"Largo\".",
        solution = "if #nombre > 10 then print(\"Largo\") end",
        explanation = "El operador # es la forma más rápida y común en Luau."
    },
    {
        title = "Nivel 34: Librería Matemática - math.random",
        theory = [[math.random(min, max) devuelve un número aleatorio entre los dos valores dados, ambos inclusive.]],
        example = "local dado = math.random(1, 6)",
        commonMistakes = "Poner el máximo antes que el mínimo.",
        miniExercise = "Genera un número entre 1 y 100.",
        puzzle = "Crea una variable 'suerte' con un valor aleatorio entre 1 y 10.",
        solution = "local suerte = math.random(1, 10)",
        explanation = "Esencial para juegos, loot, daño variable y muchas otras mecánicas."
    },
    {
        title = "Nivel 35: Redondeo - math.floor y math.ceil",
        theory = [[math.floor(n) redondea hacia abajo al entero más cercano. math.ceil(n) redondea hacia arriba.]],
        example = "math.floor(1.9) -- 1, math.ceil(1.1) -- 2",
        commonMistakes = "Confundir cuál va hacia arriba y cuál hacia abajo.",
        miniExercise = "Redondea hacia abajo 5.7.",
        puzzle = "Usa math.floor para redondear la variable 'precio' y guárdala en 'entero'.",
        solution = "local entero = math.floor(precio)",
        explanation = "Muy usado para mostrar barras de vida o niveles de experiencia sin decimales."
    },
    {
        title = "Nivel 36: Concatenación Avanzada - string.format",
        theory = [[string.format permite crear strings complejos insertando valores en un patrón.]],
        example = "string.format(\"Vida: %d\", 100) -- \"Vida: 100\"",
        commonMistakes = "Usar el tipo de formato incorrecto (%d para números, %s para strings).",
        miniExercise = "Formatea \"Nivel: %d\".",
        puzzle = "Usa string.format para crear \"Oro: 50\" usando la variable 'cantidad'.",
        solution = "string.format(\"Oro: %d\", cantidad)",
        explanation = "%d es un marcador para dígitos (números enteros)."
    },
    {
        title = "Nivel 37: Ámbito de Variables (Scope)",
        theory = [[Las variables 'local' solo existen dentro del bloque (do-end, function-end, if-end) donde se crean.]],
        example = "if true then local x = 5 end print(x) -- nil!",
        commonMistakes = "Intentar usar una variable local fuera de su bloque.",
        miniExercise = "Crea un bloque 'do end' con una variable local.",
        puzzle = "Escribe un bloque 'do' que contenga 'local a = 1' y termine.",
        solution = "do local a = 1 end",
        explanation = "Esto evita 'contaminar' el resto del código con variables que ya no necesitas."
    },
    {
        title = "Nivel 38: Valores Nil",
        theory = [['nil' representa la ausencia de valor. Si intentas usar una variable que no existe, su valor será nil.]],
        example = "local x = nil",
        commonMistakes = "Realizar operaciones matemáticas con nil (causará un error).",
        miniExercise = "Asigna nil a 'puntero'.",
        puzzle = "Si 'objeto' es igual a nil, muestra \"Vacio\".",
        solution = "if objeto == nil then print(\"Vacio\") end",
        explanation = "Es la forma estándar de verificar si algo ha sido inicializado o borrado."
    },
    {
        title = "Nivel 39: El Operador Modulo (%)",
        theory = [[El operador % devuelve el resto de una división. Es útil para saber si un número es par o impar.]],
        example = "10 % 3 -- 1",
        commonMistakes = "Confundir con el símbolo de porcentaje de descuento.",
        miniExercise = "Calcula 5 modulo 2.",
        puzzle = "Si 'num' % 2 es igual a 0, muestra \"Par\".",
        solution = "if num % 2 == 0 then print(\"Par\") end",
        explanation = "Cualquier número par dividido por 2 tiene resto 0."
    },
    {
        title = "Nivel 40: EXAMEN 4 - Librerías Estándar",
        theory = [[Cuarto examen. Verificaremos tu conocimiento sobre las librerías math, string y table. ¡Ánimo!]],
        example = "Repaso: math.random, string.upper, table.insert",
        commonMistakes = "N/A",
        miniExercise = "N/A",
        puzzle = "Crea un string en mayúsculas que diga \"HOLA \" seguido de un número aleatorio entre 1 y 5.",
        solution = "local s = string.upper(\"hola \") .. math.random(1, 5)",
        explanation = "Combinamos manipulación de strings, concatenación y generación aleatoria."
    },
    {
        title = "Nivel 41: Diccionarios con Funciones",
        theory = [[En Luau, puedes guardar funciones dentro de tablas. Esto es la base de la Programación Orientada a Objetos.]],
        example = "local npc = { hablar = function() print(\"Hola\") end }",
        commonMistakes = "Olvidar la coma entre elementos de la tabla si hay más de uno.",
        miniExercise = "Crea una tabla con una función 'test'.",
        puzzle = "Crea una tabla 'calc' con una función 'sumar' que reciba a, b y retorne a+b.",
        solution = "local calc = { sumar = function(a, b) return a + b end }",
        explanation = "Ahora puedes llamar a la función como calc.sumar(5, 10)."
    },
    {
        title = "Nivel 42: El parámetro implícito 'self'",
        theory = [[Cuando usas el punto (.) para llamar a una función de una tabla, no tienes acceso fácil a la tabla misma.
        Si usas dos puntos (:), Luau pasa la tabla automáticamente como un primer argumento invisible llamado 'self'.]],
        example = "function jugador:curar(v) self.vida += v end",
        commonMistakes = "Mezclar . y : al definir y llamar funciones.",
        miniExercise = "Define una función con : en una tabla.",
        puzzle = "Define una función 'subir' en la tabla 'stats' usando : que incremente self.nivel en 1.",
        solution = "function stats:subir() self.nivel = self.nivel + 1 end",
        explanation = "El uso de ':' hace que el código sea más limpio y orientado a objetos."
    },
    {
        title = "Nivel 43: Metatablas - Introducción",
        theory = [[Las metatablas permiten cambiar el comportamiento de las tablas.
        Por ejemplo, qué pasa cuando sumas dos tablas.]],
        example = "setmetatable(tabla, metatabla)",
        commonMistakes = "Intentar acceder directamente a la metatabla sin usar getmetatable.",
        miniExercise = "Usa setmetatable en una tabla vacía.",
        puzzle = "Usa setmetatable para asignar la tabla 'mt' a la tabla 't'.",
        solution = "setmetatable(t, mt)",
        explanation = "Esto abre la puerta a funcionalidades avanzadas como la herencia."
    },
    {
        title = "Nivel 44: El Metamétodo __index",
        theory = [[__index es el metamétodo más usado. Si buscas una clave en una tabla y no existe,
        Luau la buscará en la tabla definida en __index.]],
        example = "mt.__index = baseTabla",
        commonMistakes = "Olvidar asignar __index dentro de la metatabla.",
        miniExercise = "Asigna una tabla a __index.",
        puzzle = "En la metatabla 'mt', asigna la tabla 'plantilla' a la clave '__index'.",
        solution = "mt.__index = plantilla",
        explanation = "Es la técnica principal para implementar clases y herencia en Luau."
    },
    {
        title = "Nivel 45: Punteros y Referencias",
        theory = [[Las tablas en Luau se pasan por referencia. Si asignas una tabla a otra variable,
        ambas apuntan a la misma tabla en memoria.]],
        example = "local a = {}; local b = a; b.x = 1; print(a.x) -- 1",
        commonMistakes = "Pensar que asignar una tabla crea una copia independiente.",
        miniExercise = "Asigna t1 a t2.",
        puzzle = "Crea una tabla 'orig', asígnala a 'copia' y cambia copia.valor a 10.",
        solution = "local orig = {} local copia = orig copia.valor = 10",
        explanation = "Modificar 'copia' también modifica 'orig' porque son la misma tabla."
    },
    {
        title = "Nivel 46: Variadic Functions (Parámetros variables)",
        theory = [[Puedes hacer que una función acepte cualquier número de argumentos usando tres puntos (...).]],
        example = "function listar(...) local args = {...} end",
        commonMistakes = "Usar ... fuera de una función.",
        miniExercise = "Función que reciba ...",
        puzzle = "Crea una función 'cuenta' que reciba '...' y retorne el largo de la tabla '{...}'.",
        solution = "function cuenta(...) return #{...} end",
        explanation = "Esto permite funciones muy flexibles como print() que aceptan muchos valores."
    },
    {
        title = "Nivel 47: Type Checking (typeof)",
        theory = [[typeof(v) devuelve un string con el tipo del valor. Es más preciso que type() en Luau (Roblox).]],
        example = "typeof(Vector3.new()) -- \"Vector3\"",
        commonMistakes = "Esperar que devuelva el objeto mismo en lugar de un string.",
        miniExercise = "Usa typeof en un número.",
        puzzle = "Si typeof(x) es igual a \"table\", muestra \"Es tabla\".",
        solution = "if typeof(x) == \"table\" then print(\"Es tabla\") end",
        explanation = "Fundamental para validar que los datos que recibe una función son correctos."
    },
    {
        title = "Nivel 48: Task Library (Roblox)",
        theory = [[En Roblox Luau, usamos 'task.wait()' en lugar de 'wait()' por ser más eficiente y preciso.]],
        example = "task.wait(1) -- Espera 1 segundo",
        commonMistakes = "Usar task.wait() en scripts que no son de Roblox o Luau estándar.",
        miniExercise = "Espera 0.5 segundos.",
        puzzle = "Usa task.wait para esperar 2 segundos.",
        solution = "task.wait(2)",
        explanation = "Mantiene el rendimiento del juego al integrarse mejor con el motor de tareas."
    },
    {
        title = "Nivel 49: Proyecto Final Parte 1 - El Sistema",
        theory = [[Vamos a crear un sistema básico de inventario usando lo aprendido.
        Necesitamos una tabla, una función para añadir y una para listar.]],
        example = "table.insert(inv, item); for i,v in ipairs(inv) do ... end",
        commonMistakes = "N/A",
        miniExercise = "N/A",
        puzzle = "Crea una tabla 'inv'. Crea una función 'add(item)' que use table.insert para meterlo en 'inv'.",
        solution = "local inv = {} function add(item) table.insert(inv, item) end",
        explanation = "Estructura básica de gestión de datos."
    },
    {
        title = "Nivel 50: DESAFÍO FINAL - El Arquitecto Luau",
        theory = [[¡Nivel Final! Debes crear un objeto 'Jugador' con metatablas que tenga vida,
        un método para recibir daño y verifique si muere. Has demostrado ser un Senior,
        ¡conviértete en Arquitecto!]],
        example = "local p = setmetatable({vida = 100}, {__index = acciones})",
        commonMistakes = "N/A",
        miniExercise = "N/A",
        puzzle = "Crea una tabla 'pj' con vida 100. Crea una función pj:daño(n) que reste 'n' a self.vida y si es <= 0 imprima \"Fin\".",
        solution = "local pj = {vida = 100} function pj:daño(n) self.vida = self.vida - n if self.vida <= 0 then print(\"Fin\") end end",
        explanation = "¡Felicidades! Has dominado Luau. Este código integra tablas, funciones con self, condicionales y comparaciones."
    }
}

return levels
