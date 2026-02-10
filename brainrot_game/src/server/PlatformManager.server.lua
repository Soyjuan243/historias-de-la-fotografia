local Workspace = game:GetService("Workspace")
local PlatformsFolder = Workspace:WaitForChild("Platforms")

local PLATFORM_COUNT = 5
local SPACING = 15

local function createPlatform(index)
    local platform = Instance.new("Part")
    platform.Name = "Platform_" .. index
    platform.Size = Vector3.new(10, 1, 10)
    platform.Position = Vector3.new(index * SPACING, 0.5, 0)
    platform.Anchored = true
    platform.BrickColor = BrickColor.new("Medium stone grey")
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.Parent = PlatformsFolder

    -- Attributes for state management
    platform:SetAttribute("PlatformIndex", index)
    platform:SetAttribute("IsOccupied", false)
    platform:SetAttribute("BrainrotID", "")

    return platform
end

for i = 1, PLATFORM_COUNT do
    createPlatform(i)
end

print("[Server] Platforms initialized.")
