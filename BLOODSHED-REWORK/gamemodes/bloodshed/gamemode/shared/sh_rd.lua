local pl = FindMetaTable("Player")

if SERVER then
	function pl:SetSVAnimation(anim, autostop)
		self:SetNWString('SVAnim', anim)
		self:SetNWFloat('SVAnimDelay', select(2, self:LookupSequence(anim)))
		self:SetNWFloat('SVAnimStartTime', CurTime())
		self:SetCycle(0)

		if autostop and anim ~= "" then
			local delay = select(2, self:LookupSequence(anim))

			timer.Simple(delay, function()
				if not IsValid(self) then return end
				local anim2 = self:GetNWString('SVAnim')

				if anim == anim2 then
					self:SetSVAnimation("")
				end
			end)
		end

		return select(2, self:LookupSequence(anim))
	end

	hook.Add("PlayerDeath", "SVanimFix", function(ply)
		ply:SetSVAnimation("")
	end)
end

function pl:CanGetUp()
	local tr = util.TraceHull({
		start = self:GetPos() + Vector(0, 0, 32),
		endpos = self:GetPos() + Vector(0, 0, 32),
		filter = function(ent)
			if ent:GetClass() == "prop_ragdoll" or ent == self or ent:GetClass() == "murwep_ragdoll_weapon" or ent:GetClass() == "murwep_ragdoll_melee" then
				return false
			else
				return true
			end
		end,
		mins = self:OBBMins(),
		maxs = self:OBBMaxs(),
		mask = MASK_SHOT_HULL,
	})

	return not tr.Hit
end

function pl:GetSVAnimation()
	return self:GetNWString('SVAnim')
end

function pl:TimeGetUpChange(time, isset)
	local rag = self:GetRD()

	if IsValid(rag) then
		if isset then
			self:SetNWFloat('RD_GetUpTime', CurTime() + time)
		else
			self:SetNWFloat('RD_GetUpTime', self:GetNWFloat('RD_GetUpTime') + time)
		end
	end
end

function pl:TimeGetUp(check)
	if check then
		return self:GetNWFloat('RD_GetUpTime') < CurTime()
	else
		return self:GetNWFloat('RD_GetUpTime')
	end
end

function MuR:BoneData(ent, bone)
	local boneid = ent:LookupBone(bone)
	local pos, ang = ent:GetBonePosition(boneid)

	return pos, ang
end

function MuR:CheckHeight(ent, pos)
	local tr = util.TraceLine({
		start = pos,
		endpos = pos - Vector(0, 0, 999999),
		filter = function(tar)
			if IsValid(ent.Weapon) and tar == ent.Weapon or ent == tar then
				return false 
			else
				return true
			end	
		end,
		mask = MASK_PLAYERSOLID,
	})

	return (pos - tr.HitPos):Length()
end

hook.Add("CalcMainActivity", "!TDMAnims", function(ply, vel)
	local str = ply:GetNWString('SVAnim')
	local num = ply:GetNWFloat('SVAnimDelay')
	local st = ply:GetNWFloat('SVAnimStartTime')

	if str ~= "" then
		ply:SetCycle((CurTime() - st) / num)

		return -1, ply:LookupSequence(str)
	end
end)