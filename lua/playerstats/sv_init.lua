AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

PSTATS = {}
PEVENTS = {}

--[[
	Base functions
]]

function PLAYERSTATS:TryLuck(a, b)
    return math.random(a, b) == 3 
end

function PLAYERSTATS:Initialize()
	for id, name in pairs(file.Find("playerstats/stats/*", "LUA")) do
		include("playerstats/stats/" .. name)
	end

	for id, name in pairs(file.Find("playerstats/events/*", "LUA")) do
		include("playerstats/events/" .. name)
	end

	for id, name in pairs(file.Find("playerstats/other/*", "LUA")) do
		include("playerstats/other/" .. name)
	end

	for id, func in pairs(PSTATS) do
		timer.Create("PlayerStat" .. id, 1, 0, func)
	end
	
	for id, func in pairs(PEVENTS) do
		hook.Add("EntityTakeDamage", "PlayerEvent" .. id, func)
	end
end
