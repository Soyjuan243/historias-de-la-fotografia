local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for the Remotes folder to be created by the server
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)

if not Remotes then
    warn("[Shared] Remotes folder not found. Waiting longer...")
    Remotes = ReplicatedStorage:WaitForChild("Remotes")
end

local Events = {}

function Events.get(name)
    return Remotes:WaitForChild(name)
end

return Events
