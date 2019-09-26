CreateConVar("playerstats_stamina", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Enable or disable Stamina module.")

hook.Add("PlayerInitialSpawn", "SetUpDefaultValues", function(ply)
	ply.DefaultRun = ply:GetRunSpeed()
	ply.DefaultWalk = ply:GetWalkSpeed()
	ply.DefaultJump = ply:GetJumpPower()
end)

hook.Add("PlayerTick", "DoStaminaSystem", function(ply)
	if not GetConVar("playerstats_stamina"):GetBool() then 
		return 
	end
	
	if not ply:Alive() then 
		return 
	end

	local numup = 0
	if not ply:OnGround() then 
		numup = 0.1 
	else 
		numup = 0.25 
	end

	ply:SetNWFloat("Stamina", math.Clamp(ply:GetNWFloat("Stamina", ply:GetNWInt("staminacap", 100)) + numup, 0, 100))

	if ply:IsSprinting() and ply:GetRunSpeed() == ply.DefaultRun and ply:GetVelocity():Length() >= ply.DefaultWalk and ply:OnGround() then
		if not ply:GetNWBool("isInspired") or not ply:GetNWBool("isFurious") then
			ply:SetNWFloat("Stamina", math.Clamp(ply:GetNWFloat("Stamina") - 0.3, 0, 100))
		end
	elseif ply:WaterLevel() >= 2 then
		if ply:IsSprinting() then
			if not ply:GetNWBool("isInspired") or not ply:GetNWBool("isFurious") then
				ply:SetNWFloat("Stamina", math.Clamp(ply:GetNWFloat("Stamina") - 0.2, 0, 100))
			end
		end
	end

	if ply:GetNWFloat("Stamina") <= 25 then
		if not ply:IsSprinting() or ply:GetNWFloat("Stamina") == 0 then
			ply:SetWalkSpeed(ply.DefaultWalk / 1.5)
			ply:SetRunSpeed(ply.DefaultRun / 1.5)
		end

		ply:SetJumpPower(ply.DefaultJump / 1.3)
	else
		if ply:GetNWBool("isInspired") then
			ply:SetWalkSpeed(ply.DefaultWalk * 1.2)
			ply:SetRunSpeed(ply.DefaultRun * 1.2)
			ply:SetJumpPower(ply.DefaultJump * 1.2)
		elseif ply:GetNWBool("isFurious") then
			ply:SetWalkSpeed(ply.DefaultWalk * 1.2)
			ply:SetRunSpeed(ply.DefaultRun * 1.2)
			ply:SetJumpPower(ply.DefaultJump * 1.2)			
		elseif ply:GetNWBool("isInjured") then
			ply:SetWalkSpeed(ply.DefaultWalk / 1.35)
			ply:SetRunSpeed(ply.DefaultRun / 1.35)
			ply:SetJumpPower(ply.DefaultJump / 1.35)
		elseif ply:GetNWBool("isDrowning") then
			ply:SetWalkSpeed(ply.DefaultWalk / 1.6)
			ply:SetRunSpeed(ply.DefaultRun / 1.6)
			ply:SetJumpPower(ply.DefaultJump / 1.6)			
		else
			ply:SetWalkSpeed(ply.DefaultWalk)
			ply:SetRunSpeed(ply.DefaultRun)
			ply:SetJumpPower(ply.DefaultJump)		
		end
	end

	if ply:GetNWFloat("Stamina") <= 25 then
		ply:SetNWBool("isWornout", true)
	else
		ply:SetNWBool("isWornout", false)
	end
end)

hook.Add("KeyPress", "DecreaseStaminaOnJump", function(ply, key)
	if not GetConVar("playerstats_stamina"):GetBool() then 
		return 
	end

	if not ply:Alive() then 
		return 
	end

	if not ply:OnGround() then 
		return 
	end

	if ply:InVehicle() then 
		return 
	end

	if key == IN_JUMP then
		ply:SetNWFloat("Stamina", math.Clamp(ply:GetNWFloat("Stamina") - 7, 0, 100))
	end
end)

hook.Add("PlayerDeath", "ResetStamina", function(ply)
	ply:SetNWFloat("Stamina", 100)
end)