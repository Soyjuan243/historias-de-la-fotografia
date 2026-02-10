local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local lastUpdate = os.clock()

RunService.Heartbeat:Connect(function()
    if os.clock() - lastUpdate >= 1 then
        lastUpdate = os.clock()

        local platforms = Workspace:FindFirstChild("Platforms")
        if not platforms then return end

        for _, platform in ipairs(platforms:GetChildren()) do
            for _, child in ipairs(platform:GetChildren()) do
                if child:GetAttribute("IsBrainrot") then
                    local income = child:GetAttribute("Income") or 0
                    local currentGenerated = child:GetAttribute("GeneratedMoney") or 0
                    child:SetAttribute("GeneratedMoney", currentGenerated + income)
                end
            end
        end
    end
end)

print("[Server] Progression Service started.")
