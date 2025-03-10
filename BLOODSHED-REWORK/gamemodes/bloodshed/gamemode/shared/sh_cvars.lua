local meta = FindMetaTable('Player')
local meta2 = FindMetaTable('Entity')

function meta2:GetSVAnim()
	return self:GetNWString('SVAnim', '')
end

function meta2:IsProp()
	return self:GetClass() == "prop_dynamic" or self:GetClass() == "prop_physics" or self:GetClass() == "prop_physics_multiplayer" or self:GetClass() == "prop_physics_override"
end

function meta2:IsRolePolice()
	return self:GetNWString('Class') == "Riot" or self:GetNWString('Class') == "Officer" or self:GetNWString('Class') == "SWAT" or self:GetNWString('Class') == "ArmoredOfficer"
end

function meta2:HaveStability()
	return self:GetNWString('Class') == "Killer" or self:GetNWString('Class') == "Traitor"
end

function meta2:IsKiller()
	return self:GetNWString('Class') == "Shooter" or self:GetNWString('Class') == "Terrorist" or self:GetNWString('Class') == "Maniac" or self:GetNWString('Class') == "Killer" or self:GetNWString('Class') == "Traitor"
end

function meta2:IsActiveKiller()
	return self:GetNWString('Class') == "Shooter" or self:GetNWString('Class') == "Terrorist" or self:GetNWString('Class') == "Maniac"
end

function MuR:CheckCollision(pos, ply)
	if !isvector(pos) and IsValid(ply) then
		pos = ply:GetPos()
	end
	local tr = util.TraceHull({
		start = pos,
		endpos = pos,
		filter = function(ent)
			return ent:GetClass() != "prop_ragdoll" and (IsValid(ply) and ent != ply or !IsValid(ply))
		end,
		mins = Vector(-16, -16, 0),
		maxs = Vector(16, 16, 72),
		mask = MASK_PLAYERSOLID,
	})
	return tr.Hit, tr.Entity
end

function MuR:GetAlivePlayers()
	local tab, tab2 = {}, player.GetAll()

	for i = 1, #tab2 do
		if tab2[i]:Alive() then
			tab[#tab + 1] = tab2[i]
		end
	end

	return tab
end

function MuR:VisibleByNPCs(pos)
	local tab = ents.FindByClass("npc_combine_s")

	for i = 1, #tab do
		local ent = tab[i]

		local tr = util.TraceLine({
			start = ent:EyePos(),
			endpos = pos,
			filter = function(ent)
				if ent:IsPlayer() or ent:IsNPC() then
					return false
				else
					return true
				end
			end,
			mask = MASK_SHOT,
		})

		if not tr.Hit and pos:DistToSqr(ent:GetPos()) <= 500 ^ 2 then return true end
	end

	return false
end

function MuR:VisibleByPlayers(ply, ent1)
	local tab = MuR:GetAlivePlayers()

	for i = 1, #tab do
		local ent = tab[i]
		if ent == ply or ent == ent1 then continue end

		local tr = util.TraceLine({
			start = ent:EyePos(),
			endpos = ply:WorldSpaceCenter(),
			filter = function(ent)
				if ent:IsPlayer() or ent:IsNPC() then
					return false
				else
					return true
				end
			end,
			mask = MASK_SHOT,
		})

		if not tr.Hit then return true end
	end

	return false
end

function MuR:DisablesGamemode()
	return MuR.Gamemode == 5 or MuR.Gamemode == 6 or MuR.Gamemode == 11 or MuR.Gamemode == 12 or MuR.Gamemode == 13 or MuR.Gamemode == 14
end

function MuR:DisableWeaponLoot()
	return MuR.Gamemode == 2 or MuR.Gamemode == 3 or MuR.Gamemode == 10
end

function MuR:CountNPCPolice(alive)
	local count = MuR.NPC_To_Spawn
	if alive then
		count = 0
	end

	return count + #ents.FindByClass("npc_combine_s")
end

function MuR:CountPlayerPolice()
	local tab = player.GetAll()
	local alive = 0
	local dead = 0
	for i=1,#tab do
		local ply = tab[i]
		if ply:GetNWString('Class') == "ArmoredOfficer" or ply:GetNWString('Class') == 'Officer' then
			if ply:Alive() then
				alive = alive + 1
			else
				dead = dead + 1
			end
		end
	end
	return alive, dead
end

hook.Add("SetupMove", "MuR.AimSpeed", function(ply, mvd, cmd)
	local wep = ply:GetActiveWeapon()

	if IsValid(wep) and wep:GetNWBool('Aiming') then
		mvd:SetMaxSpeed(50)
		mvd:SetMaxClientSpeed(50)
	end
	if string.match(ply:GetSVAnim(), "sequence_ron_") then
		mvd:SetMaxSpeed(1)
		mvd:SetMaxClientSpeed(1)
	end
end)