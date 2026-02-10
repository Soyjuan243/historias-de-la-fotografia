local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create the Remotes folder if it doesn't exist
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not Remotes then
    Remotes = Instance.new("Folder")
    Remotes.Name = "Remotes"
    Remotes.Parent = ReplicatedStorage
end

local function createRemote(name, className)
    if not Remotes:FindFirstChild(name) then
        local remote = Instance.new(className or "RemoteEvent")
        remote.Name = name
        remote.Parent = Remotes
    end
end

createRemote("CollectMoney")
createRemote("UpgradeBrainrot")
createRemote("PlaceBrainrot")
createRemote("RequestInventory")
createRemote("CollectSpawn")

print("[Server] Remote events initialized.")
