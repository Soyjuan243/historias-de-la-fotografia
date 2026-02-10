local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared:WaitForChild("Events"))

local function displaySystemMessage(text)
    -- Intentar usar el sistema moderno (TextChatService)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        -- En TextChatService, los mensajes del sistema se pueden enviar a canales
        -- Pero DisplaySystemMessage es un método del canal.
        -- Buscamos el canal general
        local generalChannel = TextChatService:WaitForChild("TextChannels"):FindFirstChild("RBXGeneral")
        if generalChannel then
            generalChannel:DisplaySystemMessage("<font color='#FFD700'>[SISTEMA]</font> " .. text)
        else
            -- Fallback si no hay canal general
            warn("[ChatManager] No se encontró el canal RBXGeneral")
        end
    else
        -- Sistema antiguo (Legacy Chat)
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[SISTEMA] " .. text,
            Color = Color3.fromRGB(255, 215, 0), -- Oro
            Font = Enum.Font.FredokaOne,
            TextSize = 18
        })
    end
end

-- Escuchar eventos del servidor
Events.get("SystemMessage").OnClientEvent:Connect(displaySystemMessage)

print("[Client] Chat Manager: Active.")
