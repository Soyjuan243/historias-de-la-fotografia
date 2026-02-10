local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared:WaitForChild("Events"))

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local Platforms = Workspace:WaitForChild("Platforms")

mouse.Button1Down:Connect(function()
    local character = player.Character
    if not character then return end

    local tool = character:FindFirstChildWhichIsA("Tool")
    if not tool or not tool:GetAttribute("IsBrainrotTool") then return end

    local typeID = tool:GetAttribute("BrainrotType")
    local target = mouse.Target
    if not target then return end

    local platform = nil
    if target:IsDescendantOf(Platforms) then
        if target.Parent == Platforms then
            platform = target
        else
            platform = target.Parent
        end
    end

    if platform and platform:IsA("BasePart") and not platform:GetAttribute("IsOccupied") then
        print("Placing " .. typeID .. " from tool on " .. platform.Name)
        Events.get("PlaceBrainrot"):FireServer(platform, typeID)
    end
end)

print("[Client] Placement Manager ready (Tool-based).")
