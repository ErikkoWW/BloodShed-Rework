
hook.Add("PlayerFootstep", "bloodshed:MakeCrouchSilent", function(ply)
    if ply:Crouching() then
        return true
    end
end )