local Workspace = game:GetService("Workspace")

-- This script now expects the user to have created a folder named "Platforms" in Workspace
-- and placed parts inside it.
local PlatformsFolder = Workspace:FindFirstChild("Platforms")

if not PlatformsFolder then
    warn("[Server] No 'Platforms' folder found in Workspace. Please create one.")
    -- Create one just in case so the game doesn't break, but don't add parts.
    PlatformsFolder = Instance.new("Folder")
    PlatformsFolder.Name = "Platforms"
    PlatformsFolder.Parent = Workspace
end

local function initializePlatform(platform, index)
    -- Rename platform to ensure uniqueness for data saving
    platform.Name = "Platform" .. index

    -- Attributes for state management
    platform:SetAttribute("PlatformIndex", index)
    platform:SetAttribute("IsOccupied", false)
    platform:SetAttribute("BrainrotID", "")
    platform:SetAttribute("OwnerID", 0)

    print("[Server] Initialized platform: " .. platform.Name)
end

local index = 1
for _, child in ipairs(PlatformsFolder:GetChildren()) do
    if child:IsA("BasePart") then
        initializePlatform(child, index)
        index = index + 1
    end
end

-- Listen for new platforms added at runtime (optional, but helpful)
PlatformsFolder.ChildAdded:Connect(function(child)
    if child:IsA("BasePart") then
        initializePlatform(child, #PlatformsFolder:GetChildren())
    end
end)

print("[Server] Platform Initialization logic ready.")
