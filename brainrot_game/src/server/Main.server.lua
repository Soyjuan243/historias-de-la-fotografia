-- Initialize Server Logic
local ServerScriptService = game:GetService("ServerScriptService")

-- We only require ModuleScripts.
-- Regular Scripts (like DataService, SpawningService) run automatically.
require(ServerScriptService:WaitForChild("BrainrotManager"))

-- print("[Server] Main logic initialized.")
