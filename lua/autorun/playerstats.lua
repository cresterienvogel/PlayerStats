AddCSLuaFile("playerstats/cl_init.lua") 

if SERVER then 
    include("playerstats/sv_init.lua")
    PLAYERSTATS:Initialize()
else
    include("playerstats/cl_init.lua")
end