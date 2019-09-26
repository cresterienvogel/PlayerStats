table.insert(PSTATS, function()
	if not GetConVar("playerstats_oxygen"):GetBool() then 
		return 
	end

	for _, ply in pairs(player.GetAll()) do
		if ply:IsValid() then
			if ply:WaterLevel() > 2 then
				if ply:GetNWBool("isOutbreath") then
					timer.Simple(3, function()
						ply:SetNWBool("isDrowning", true)
						ply:ScreenFade(bit.bor(SCREENFADE.OUT, SCREENFADE.PURGE), Color(0, 0, 200, 60), 0.8, 1)
					end)
				else
					ply:SetNWBool("isDrowning", false)
				end
			end
		end
	end
end)