local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

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
