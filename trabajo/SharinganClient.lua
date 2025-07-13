-- SharinganClient (LocalScript)

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local head = character:WaitForChild("Head")

local sharinganEvent = ReplicatedStorage:WaitForChild("SharinganEvent")

local sharinganStates = {
    { key = Enum.KeyCode.C, texture = "rbxassetid://73760846204665" }, -- 1 Tomoe
    { key = Enum.KeyCode.Two, texture = "rbxassetid://100524412974648" }, -- 2 Tomoe
    { key = Enum.KeyCode.Three, texture = "rbxassetid://88056592285402" }, -- 3 Tomoe
    { key = Enum.KeyCode.Four, texture = "rbxassetid://92017912349423" }  -- Mangekyou (usando la tecla 4 para simplificar)
}

local currentSharinganState = 0

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

local function setSharinganState(stateIndex)
    if stateIndex > 0 then
        local state = sharinganStates[stateIndex]
        leftEye.Texture = state.texture
        rightEye.Texture = state.texture
        leftEye.Visible = true
        rightEye.Visible = true
        sharinganEvent:FireServer(state.texture, true)
        print("Sharingan evolucionado a estado " .. stateIndex)
    else
        leftEye.Visible = false
        rightEye.Visible = false
        sharinganEvent:FireServer("", false)
        print("Sharingan desactivado")
    end
    currentSharinganState = stateIndex
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.C then
        if currentSharinganState == 0 then
            setSharinganState(1)
        else
            setSharinganState(0)
        end
    elseif input.KeyCode == Enum.KeyCode.Two and UserInputService:IsKeyDown(Enum.KeyCode.C) then
        setSharinganState(2)
    elseif input.KeyCode == Enum.KeyCode.Three and UserInputService:IsKeyDown(Enum.KeyCode.C) then
        setSharinganState(3)
    elseif input.KeyCode == Enum.KeyCode.Four and UserInputService:IsKeyDown(Enum.KeyCode.C) then
        setSharinganState(4)
    end
end)

print("SharinganClient script loaded")
