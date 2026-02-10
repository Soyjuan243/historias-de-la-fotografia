-- Initialize all server modules
local ServerScriptService = game:GetService("ServerScriptService")

require(ServerScriptService:WaitForChild("BrainrotManager"))
require(ServerScriptService:WaitForChild("ProgressionService"))
require(ServerScriptService:WaitForChild("DataService"))
require(ServerScriptService:WaitForChild("SpawningService"))

print("[Server] All services initialized.")
