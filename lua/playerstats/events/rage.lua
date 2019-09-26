CreateConVar("playerstats_rage", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Enable or disable Rage module.")

table.insert(PEVENTS, function(victim, attacker)
    if not GetConVar("playerstats_rage"):GetBool() then 
        return 
    end

    local attackerg = attacker:GetAttacker()
    
    if not IsValid(victim) then 
        return 
    end

    if not GetConVar("playerstats_rage"):GetBool() then 
        return 
    end

    if victim:IsPlayer() then
        if victim == attackerg then 
            return 
        end

        if victim:GetNWBool("isFurious") then
            attacker:ScaleDamage(0.95)
        end

        if victim:GetNWBool("isInspired") or victim:GetNWBool("isFurious") then 
            return 
        end

        if PLAYERSTATS:TryLuck(1, 85) then
            victim:SetNWBool("isInjured", false)
            victim:SetNWBool("isFurious", true)

            timer.Simple(10, function()
                victim:SetNWBool("isFurious", false)
            end)
        end
    end
end)