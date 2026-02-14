local Utils = {}

local SUFFIXES = {"", "k", "M", "B", "T", "qd", "Qn", "sx", "Sp", "Oc", "Nn", "dc"}

function Utils.formatNumber(n)
    if n < 1000 then return tostring(math.floor(n)) end

    local index = math.floor(math.log10(n) / 3)
    local suffix = SUFFIXES[index + 1] or "e" .. (index * 3)

    local value = n / (10 ^ (index * 3))
    return string.format("%.2f %s", value, suffix):gsub("%.00", "")
end

return Utils
