-- SharinganServer (Script)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sharinganEvent = ReplicatedStorage:WaitForChild("SharinganEvent")

local function createEyeDecals(character)
    local head = character:WaitForChild("Head")

    if head:FindFirstChild("LeftSharingan") then return end

    local leftEye = Instance.new("Decal")
    leftEye.Name = "LeftSharingan"
    leftEye.Face = Enum.NormalId.Front
    leftEye.Position = Vector3.new(-0.2, 0, 0.5)
    leftEye.Size = Vector3.new(0.4, 0.4, 0.1)
    leftEye.Visible = false
    leftEye.Parent = head

    local rightEye = Instance.new("Decal")
    rightEye.Name = "RightSharingan"
    rightEye.Face = Enum.NormalId.Front
    rightEye.Position = Vector3.new(0.2, 0, 0.5)
    rightEye.Size = Vector3.new(0.4, 0.4, 0.1)
    rightEye.Visible = false
    rightEye.Parent = head
end

local function onSharinganToggled(player, textureId, isVisible)
    local character = player.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local leftEye = head:FindFirstChild("LeftSharingan")
    local rightEye = head:FindFirstChild("RightSharingan")

    if not leftEye or not rightEye then return end

    leftEye.Texture = textureId
    rightEye.Texture = textureId
    leftEye.Visible = isVisible
    rightEye.Visible = isVisible
end

sharinganEvent.OnServerEvent:Connect(onSharinganToggled)

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(createEyeDecals)
end)

print("SharinganServer script loaded")
