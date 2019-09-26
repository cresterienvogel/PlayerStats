CreateConVar("playerstats_oxygen", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Enable or disable Oxygen module.")

local InWater = {}
table.insert(PSTATS, function()
	if not GetConVar("playerstats_oxygen"):GetBool() then 
		return 
	end

	for _, ply in pairs(player.GetAll()) do
		if ply:IsValid() then
			if ply:WaterLevel() > 2 and ply:Alive() then
				if InWater[ply:SteamID()] == nil or InWater[ply:SteamID()] == 0 then 
					InWater[ply:SteamID()] = 0 
				end

				InWater[ply:SteamID()] = InWater[ply:SteamID()] + 1
			else
				InWater[ply:SteamID()] = nil
				ply:SetNWBool("isOutbreath", false)
			end

			if InWater[ply:SteamID()] != nil and InWater[ply:SteamID()] > 5 and ply:Alive() then
				ply:SetNWBool("isOutbreath", true)

				if math.random(1, 5) == 5 then 
					ply:EmitSound("player/pl_drown" .. math.random(2, 3) .. ".wav", 100, math.random(100, 120)) 
				end
			end
			
			if InWater[ply:SteamID()] != nil and InWater[ply:SteamID()] > 19 and ply:Alive() then
				ply:SetHealth(ply:Health() - math.random(4, 6))

				if InWater[ply:SteamID()] == 20 then
					ply:EmitSound("player/pl_drown1.wav") 
				end

				if math.random(1, 3) == 3 then
					ply:EmitSound("player/pl_drown" .. math.random(1, 2) .. ".wav", 100, math.Clamp(v:Health() * 1.2, 70, 100)) 
				end

				if ply:Health() <= 0 then
					ply:SetHealth(0)
					ply:Kill() 
					ply:EmitSound("player/pl_drown3.wav")
					ply:SetNWBool("isOutbreath", false)
				end
			end	
		end
	end
end)