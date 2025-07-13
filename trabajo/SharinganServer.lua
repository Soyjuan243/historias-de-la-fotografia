-- SharinganServer (Script)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sharinganEvent = ReplicatedStorage:WaitForChild("SharinganEvent")

local function onSharinganToggled(player, textureId)
    local character = player.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local face = head:FindFirstChildOfClass("Decal")
    if not face then return end

    face.Texture = textureId
    print("Textura de cara actualizada para " .. player.Name)
end

sharinganEvent.OnServerEvent:Connect(onSharinganToggled)

print("SharinganServer script loaded")
