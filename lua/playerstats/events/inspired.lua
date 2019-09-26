CreateConVar("playerstats_inspire", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Enable or disable Inspiration module.")

table.insert(PEVENTS, function(victim, attacker)
    local attackerg = attacker:GetAttacker()
    
    if not IsValid(victim) then 
        return 
    end

    if not GetConVar("playerstats_inspire"):GetBool() then 
        return 
    end

    if victim:IsPlayer() then
        if victim == attackerg then 
            return 
        end

        if victim:GetNWBool("isInspired") then
            attacker:ScaleDamage(0.95)
        end

        if attackerg:GetNWBool("isInspired") or attackerg:GetNWBool("isFurious") then 
            return 
        end

        if PLAYERSTATS:TryLuck(1, 85) then
            attackerg:SetNWBool("isInjured", false)
            attackerg:SetNWBool("isInspired", true)

            timer.Simple(10, function()
                attackerg:SetNWBool("isInspired", false)
            end)
        end
    end
end)