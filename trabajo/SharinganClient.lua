-- SharinganClient (LocalScript)

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

local sharinganEvent = ReplicatedStorage:WaitForChild("SharinganEvent")

local sharinganStates = {
    { key = Enum.KeyCode.C, texture = "rbxassetid://73760846204665" }, -- 1 Tomoe
    { key = Enum.KeyCode.Two, texture = "rbxassetid://100524412974648" }, -- 2 Tomoe
    { key = Enum.KeyCode.Three, texture = "rbxassetid://88056592285402" }, -- 3 Tomoe
    { key = Enum.KeyCode.Four, texture = "rbxassetid://92017912349423" }  -- Mangekyou (usando la tecla 4 para simplificar)
}

local currentSharinganState = 0
local originalFace = ""

local function setSharinganState(stateIndex)
    local character = player.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local face = head:FindFirstChildOfClass("Decal")
    if not face then return end

    if stateIndex > 0 then
        if originalFace == "" then
            originalFace = face.Texture
        end
        local state = sharinganStates[stateIndex]
        face.Texture = state.texture
        sharinganEvent:FireServer(state.texture)
        print("Sharingan evolucionado a estado " .. stateIndex)
    else
        if originalFace ~= "" then
            face.Texture = originalFace
            sharinganEvent:FireServer(originalFace)
            print("Sharingan desactivado")
        end
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
