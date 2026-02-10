local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local Events = {}

function Events.get(name)
    return Remotes:WaitForChild(name)
end

return Events
