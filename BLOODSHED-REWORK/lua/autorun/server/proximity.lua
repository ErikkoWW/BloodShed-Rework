CreateConVar("proximity_deadtalk", 0, { FCVAR_ARCHIVE,FCVAR_REPLICATED }, "Can dead people talk? Huh?", 0, 1)
CreateConVar("proximity_radius", 3000, { FCVAR_ARCHIVE,FCVAR_REPLICATED }, "Radius, in which players can hear each other.")
CreateConVar("proximity_mute", 0.3, { FCVAR_ARCHIVE,FCVAR_REPLICATED }, "Volume of players, when they're behind the walls. (0-1)", 0, 1)
CreateConVar("proximity_enabled", 1, { FCVAR_ARCHIVE,FCVAR_REPLICATED }, "Switches between global and proximity voice chat.", 0, 1)

hook.Add( "PlayerCanHearPlayersVoice", "Maximum Range", function(listener, talker)
    local canSpec = GetConVar("proximity_deadtalk"):GetInt()
    local maxDistance = GetConVar("proximity_radius"):GetInt()
    local proximityEnabled = GetConVar("proximity_enabled"):GetInt()
	
	if canSpec == 1 and not talker:Alive() then
		return false, false
	end

    if MuR.GameStarted and MuR.TimeCount + 12 > CurTime() or MuR.Ending then 
        proximityEnabled = 0
        return true, false 
    end

    if not talker:Alive() and not listener:Alive () then 
        proximityEnabled = 0
        return true, false
    end

    if not talker:Alive() and listener:Alive() then return false end

    if proximityEnabled == 0 then
		return true, false
	end
	
	local ply = listener
	if IsValid(listener:GetObserverTarget()) then ply = listener:GetObserverTarget() end
	
    local distance = ply:GetPos():Distance(talker:GetPos())

    if distance > maxDistance then
        return false, false
    end

    return true, true
end)