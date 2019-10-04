CreateConVar("playerstats_poison", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Enable or disable Poison module.")

local cough = {
	"ambient/voices/cough1.wav",
	"ambient/voices/cough2.wav",
	"ambient/voices/cough3.wav",
	"ambient/voices/cough4.wav"
}

table.insert(PEVENTS, function(ply, dmginfo)
	if not GetConVar("playerstats_poison"):GetBool() then 
		return 
	end

	if IsValid(ply) then
		if dmginfo:IsDamageType(DMG_POISON) or dmginfo:IsDamageType(DMG_RADIATION) or dmginfo:IsDamageType(DMG_ACID) then
			ply:SetNWBool("isPoisoned", true)

			timer.Create("PoisonFlash" .. ply:EntIndex(), 4, 0, function()
				if IsValid(ply) then
					ply:ScreenFade(bit.bor(SCREENFADE.OUT, SCREENFADE.PURGE), Color(255, 222, 102, 60), 1, 0)
					ply:EmitSound(table.Random(cough), 80, 100)
				end
			end)

			timer.Simple(60, function()
				ply:SetNWBool("isPoisoned", false)
				timer.Destroy("PoisonFlash" .. ply:EntIndex())
			end)
		end
	end
end)
