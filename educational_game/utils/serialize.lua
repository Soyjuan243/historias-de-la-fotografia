-- Simple JSON-like serializer for the educational game
local json = {}

function json.encode(t)
    local function serialize(val)
        if type(val) == "table" then
            local res = "{"
            local first = true
            for k, v in pairs(val) do
                if not first then res = res .. "," end
                local key = type(k) == "string" and string.format("%q", k) or k
                res = res .. string.format("[%s]=%s", key, serialize(v))
                first = false
            end
            return res .. "}"
        elseif type(val) == "string" then
            return string.format("%q", val)
        elseif type(val) == "number" or type(val) == "boolean" then
            return tostring(val)
        else
            return "nil"
        end
    end
    return serialize(t)
end

function json.decode(s)
    -- This is a very unsafe hacky way using load, but works for local save files in this context
    -- In a real production app, use a proper parser.
    -- We need to convert the JSON-like string back to a Lua table definition if it was encoded with [key]=value
    -- Or if we used standard JSON format we'd need a real parser.
    -- Let's stick to Lua table serialization for simplicity in this sandbox.
    local f = load("return " .. s)
    if f then return f() end
    return nil
end

return json
