CreateConVar("playerstats_extinguishing", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Enable or disable Extinguishing module.")

table.insert(PSTATS, function()
	if not GetConVar("playerstats_extinguishing"):GetBool() then 
		return 
	end

	for _, ply in pairs(player.GetAll()) do
		if ply:IsValid() then
			if ply:WaterLevel() > 2 and ply:IsOnFire() then
                ply:Extinguish()
                ply:SetNWBool("isHappy", true)

                timer.Simple(7, function()
                    ply:SetNWBool("isHappy", false)
                end)
			end
		end
	end
end)