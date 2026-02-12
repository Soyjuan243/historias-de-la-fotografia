local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
if not Remotes then
    Remotes = ReplicatedStorage:WaitForChild("Remotes")
end

local Events = {}

function Events.get(name)
    if not name then
        return nil
    end

    local remote = Remotes:WaitForChild(name, 10)
    if not remote then
        -- En producción no queremos warns, pero si falla algo crítico, necesitamos que espere
        remote = Remotes:WaitForChild(name)
    end

    return remote
end

return Events
