local validator = {}

function validator.validate(input, expected)
    if not input or not expected then return false, "Input o solución faltante." end

    -- Normalize whitespace
    local function normalize(s)
        s = s:gsub("^%s*", ""):gsub("%s*$", "") -- trim
        s = s:gsub("%s+", " ") -- collapse internal spaces
        return s
    end

    local normInput = normalize(input)
    local normExpected = normalize(expected)

    if normInput == normExpected then
        return true, "¡Correcto!"
    end

    -- Heuristic checks
    if normInput == "" then
        return false, "El campo no puede estar vacío."
    end

    -- More complex validation can be added here (patterns, etc)

    return false, "Incorrecto. Revisa la sintaxis o los valores."
end

return validator
