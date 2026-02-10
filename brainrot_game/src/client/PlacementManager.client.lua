local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared:WaitForChild("Events"))

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local Platforms = Workspace:WaitForChild("Platforms")

mouse.Button1Down:Connect(function()
    if not _G.SelectedBrainrot then return end

    local target = mouse.Target
    if not target then return end

    -- Check if target is a platform or a child of a platform
    local platform = nil
    if target:IsDescendantOf(Platforms) then
        if target.Parent == Platforms then
            platform = target
        else
            platform = target.Parent
        end
    end

    if platform and platform:IsA("BasePart") and not platform:GetAttribute("IsOccupied") then
        print("Intentando colocar " .. _G.SelectedBrainrot .. " en " .. platform.Name)
        Events.get("PlaceBrainrot"):FireServer(platform, _G.SelectedBrainrot)

        -- Deselect after placing
        _G.SelectedBrainrot = nil
    end
end)

print("[Client] Placement Manager ready.")
