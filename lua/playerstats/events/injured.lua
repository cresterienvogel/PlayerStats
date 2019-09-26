CreateConVar("playerstats_injure", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Enable or disable Injure module.")

table.insert(PEVENTS, function(victim, attacker)
    if not GetConVar("playerstats_injure"):GetBool() then 
        return 
    end

    local attacker = attacker:GetAttacker()
    if not IsValid(victim) then
        return 
    end
    
    if victim:IsPlayer() then
        if victim == attacker then
            return 
        end

        if victim:GetNWBool("isInspired") or victim:GetNWBool("isFurious") or victim:GetNWBool("isInjured") then 
            return 
        end

        if PLAYERSTATS:TryLuck(1, 12) then
            victim:SetNWBool("isInjured", true)
            victim:SendLua([[hook.Add("HUDPaint", "MotionBlur", function() DrawMotionBlur(0.3, 0.5, 0.01) end)]])
            
            timer.Simple(15, function()
                victim:SetNWBool("isInjured", false)
                victim:SendLua([[hook.Remove("HUDPaint", "MotionBlur")]])
            end)
        end
    end
end)