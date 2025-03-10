local pl = FindMetaTable("Player")

local execIDTab = {
	["pistol"] = {"03", "04", "21", "22",},
	["knife"] = {"01", "23", "24", "33",},
	["hatchet"] = {"19", "20",},
	["club"] = {"15", "16", "17",},
	["fist"] = {"25", "26", "27", "28", "29", "30", "31", "32",},
	["rifle"] = {"07", "08",},
	["sniper"] = {"13", "14",},
	["shotgun"] = {"09", "10", "11", "12",},
}

local MuRTakedowns = {
	["01"] = {
		deathtime = 3,
		deathtime_laststand = 2.6,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_001_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_001_laststand.wav", 50)
			end)
		end,
	},
	["03"] = {
		deathtime = 3,
		deathtime_laststand = 2.6,
		effect = function(att, tar)
			timer.Simple(0.2, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_003_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.2, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_003_laststand.wav", 50)
			end)
		end,
	},
	["04"] = {
		deathtime = 2.7,
		deathtime_laststand = 3.4,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_004_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_004_laststand.wav", 50)
			end)
		end,
	},
	["07"] = {
		deathtime = 2.8,
		deathtime_laststand = 2.8,
		effect = function(att, tar)
			timer.Simple(0.1, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_007_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.15, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_007_laststand.wav", 50)
			end)
		end,
	},
	["08"] = {
		deathtime = 2.6,
		deathtime_laststand = 2.6,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_008_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.5, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_008_laststand.wav", 50)
			end)
		end,
	},
	["09"] = {
		deathtime = 3.2,
		deathtime_laststand = 2.6,
		effect = function(att, tar)
			timer.Simple(0.4, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_009_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.4, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_009_laststand.wav", 50)
			end)
		end,
	},
	["10"] = {
		deathtime = 2.7,
		deathtime_laststand = 2.7,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_010_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.4, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_010_laststand.wav", 50)
			end)
		end,
	},
	["11"] = {
		deathtime = 2.8,
		deathtime_laststand = 2.8,
		effect = function(att, tar)
			timer.Simple(0.6, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_011_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.4, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_011_laststand.wav", 50)
			end)
		end,
	},
	["12"] = {
		deathtime = 2.8,
		deathtime_laststand = 2.8,
		effect = function(att, tar)
			timer.Simple(0.8, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_012_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.1, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_012_laststand.wav", 50)
			end)
		end,
	},
	["13"] = {
		deathtime = 1.8,
		deathtime_laststand = 2,
		effect = function(att, tar)
			timer.Simple(0.1, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_013_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_013_laststand.wav", 50)
			end)
		end,
	},
	["14"] = {
		deathtime = 1.7,
		deathtime_laststand = 2,
		effect = function(att, tar)
			timer.Simple(0.8, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_014_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_014_laststand.wav", 50)
			end)
		end,
	},
	["15"] = {
		deathtime = 2.8,
		deathtime_laststand = 2.8,
		effect = function(att, tar)
			timer.Simple(0.5, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_015_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.4, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_015_laststand.wav", 50)
			end)
		end,
	},
	["16"] = {
		deathtime = 2,
		deathtime_laststand = 2.2,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_016_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.4, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_016_laststand.wav", 50)
			end)
		end,
	},
	["17"] = {
		deathtime = 3,
		deathtime_laststand = 3,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_017_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.1, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_017_laststand.wav", 50)
			end)
		end,
	},
	["19"] = {
		deathtime = 3.2,
		deathtime_laststand = 3,
		effect = function(att, tar)
			timer.Simple(0.4, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_019_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.4, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_019_laststand.wav", 50)
			end)
		end,
	},
	["20"] = {
		deathtime = 3,
		deathtime_laststand = 3,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_020_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_020_laststand.wav", 50)
			end)
		end,
	},
	["21"] = {
		deathtime = 2.4,
		deathtime_laststand = 2.4,
		effect = function(att, tar)
			timer.Simple(0.5, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_021_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_021_laststand.wav", 50)
			end)
		end,
	},
	["22"] = {
		deathtime = 2.8,
		deathtime_laststand = 2.8,
		effect = function(att, tar)
			timer.Simple(0.2, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_022_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_022_laststand.wav", 50)
			end)
		end,
	},
	["23"] = {
		deathtime = 2.6,
		deathtime_laststand = 2.8,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_023_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_023_laststand.wav", 50)
			end)
		end,
	},
	["24"] = {
		deathtime = 3,
		deathtime_laststand = 3,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_024_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_024_laststand.wav", 50)
			end)
		end,
	},
	["25"] = {
		deathtime = 3,
		deathtime_laststand = 3,
		effect = function(att, tar)
			timer.Simple(0.2, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_025_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_025_laststand.wav", 50)
			end)
		end,
	},
	["26"] = {
		deathtime = 3,
		deathtime_laststand = 3,
		effect = function(att, tar)
			timer.Simple(0.2, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_026_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_026_laststand.wav", 50)
			end)
		end,
	},
	["27"] = {
		deathtime = 3,
		deathtime_laststand = 3,
		effect = function(att, tar)
			timer.Simple(0.2, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_027_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_027_laststand.wav", 50)
			end)
		end,
	},
	["28"] = {
		deathtime = 3,
		deathtime_laststand = 3,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_028_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_028_laststand.wav", 50)
			end)
		end,
	},
	["29"] = {
		deathtime = 3,
		deathtime_laststand = 3,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_029_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_029_laststand.wav", 50)
			end)
		end,
	},
	["30"] = {
		deathtime = 2.3,
		deathtime_laststand = 2.3,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_030_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.2, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_030_laststand.wav", 50)
			end)
		end,
	},
	["31"] = {
		deathtime = 2.4,
		deathtime_laststand = 2.8,
		effect = function(att, tar)
			timer.Simple(0, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_031_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(1.6, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_031_laststand.wav", 50)
			end)
		end,
	},
	["32"] = {
		deathtime = 3,
		deathtime_laststand = 3,
		effect = function(att, tar)
			timer.Simple(0.5, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_032_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.2, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_032_laststand.wav", 50)
			end)
		end,
	},
	["33"] = {
		deathtime = 3,
		deathtime_laststand = 3,
		effect = function(att, tar)
			timer.Simple(0.1, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_033_stand.wav", 50)
			end)
		end,
		effect_laststand = function(att, tar)
			timer.Simple(0.8, function()
				if not IsValid(att) or not att.Takedowning then return end
				att:EmitSound(")murdered/takedowns/execution_033_laststand.wav", 50)
			end)
		end,
	},
}

hook.Add("PlayerButtonDown", "MuR_Takedown", function(ply, but)
	if ply:Alive() and but == KEY_V then
		ply:Takedown()
	end
end)

hook.Add("Think", "MuR_Takedown", function()
	for _, ply in ipairs(player.GetAll()) do
		if ply.Takedowning and (not ply:Alive() or not ply.TakedownIsFinished and (not IsValid(ply.TakedowningTarget) or ply.TakedowningTarget:Health() <= 0 or IsValid(ply.TakedowningTarget:GetRD()))) then
			ply.Takedowning = false
			ply:SetSVAnimation("")
			ply:Freeze(false)
		elseif ply:IsBot() and ply.Takedowning and IsValid(ply.TakedowningTarget) then
			ply:SetPos(ply.TakedowningTarget:GetPos())
			ply:SetVelocity(-ply:GetVelocity())
			ply:SetEyeAngles(ply.TakedowningTarget:EyeAngles())
		end
	end
end)

function pl:Takedown(forceentity)
	local downed = false
	local tr = self:GetEyeTrace()
	local ent = tr.Entity
	local dist = tr.StartPos:Distance(tr.HitPos) < 96

	if forceentity then
		dist = true
		ent = forceentity
	end

	if ent.isRDRag then
		local pos = MuR:BoneData(ent, "ValveBiped.Bip01_Pelvis")
		downed = MuR:CheckHeight(ent, pos) < 24 and true or false
		ent = ent.Owner 
	end

	if not ent:IsPlayer() or self:GetNWFloat("Stamina") < 50 or (self:Team() == 2 or self:GetNWString("Class") == "SWAT" or self:GetNWString("Class") == "Terrorist2" or self:GetNWString("Class") == "Zombie" or self:GetNWString("Class") == "Attacker") or IsValid(self:GetRD()) or ent.Takedowning or self.Takedowning or (not ent:OnGround() and not downed) or not self:OnGround() or (not self:IsAtBack(ent) and not downed) or not dist then return end
	local float = "00"
	local wep, type = self:GetActiveWeapon(), ""

	if not IsValid(wep) or wep:GetClass() == "mur_hands" then
		type = "fist"
	elseif IsValid(wep) and wep.TakedownType then
		type = wep.TakedownType
	elseif IsValid(wep) and wep:GetMaxClip1() > 0 then
		if wep:GetPrimaryAmmoType() == 1 or wep:GetPrimaryAmmoType() == 4 then
			type = "rifle"
		elseif (wep:GetPrimaryAmmoType() == 3 or wep:GetPrimaryAmmoType() == 5) and (wep:GetHoldType() == "pistol" or wep:GetHoldType() == "revolver") then
			type = "pistol"
		elseif (wep:GetPrimaryAmmoType() == 13 or wep:GetPrimaryAmmoType() == 14 or wep:GetPrimaryAmmoType() == 5) and (wep:GetHoldType() != "pistol" and wep:GetHoldType() != "revolver") then
			type = "sniper"
		elseif wep:GetPrimaryAmmoType() == 7 then
			type = "shotgun"
		end
	end

	if execIDTab[type] then
		float = table.Random(execIDTab[type])
	end

	if not MuRTakedowns[float] then return end

	if not isnumber(float) then
		anim1, anim2 = "execution_" .. float .. "_attacker_stand", "execution_" .. float .. "_victim_stand"

		if downed then
			anim1, anim2 = "execution_" .. float .. "_attacker_laststand", "execution_" .. float .. "_victim_laststand"
		end
	end

	local delay1 = select(2, self:LookupSequence(anim1))
	local delay2 = MuRTakedowns[float].deathtime

	if downed then
		delay2 = MuRTakedowns[float].deathtime_laststand
	end

	if downed then
		ent:StopRagdolling(false, false)
	end

	timer.Simple(0.001, function()
		if !IsValid(ent) or !IsValid(self) then return end
		
		local ang1 = self:EyeAngles()
		local pos1 = self:GetPos()
		self:Freeze(true)
		self:SetEyeAngles(ang1)
		ent:SetPos(self:GetPos())
		ent:SetEyeAngles(ang1)
		self:SetSVAnimation(anim1)
		self.TakedowningTarget = ent
		self.Takedowning = true
		self.TakedownIsFinished = false
		self:SetNWFloat("Stamina", self:GetNWFloat("Stamina") - 50)
		ent.TakedowningTarget = self
		ent.Takedowning = true
		ent.TakedownIsFinished = false
		ent:SetSVAnimation(anim2)
		ent:Freeze(true)

		if downed then
			MuRTakedowns[float].effect_laststand(self, ent)
		else
			MuRTakedowns[float].effect(self, ent)
		end

		timer.Simple(delay2, function()
			if IsValid(ent) and IsValid(self) and self.Takedowning then
				self.TakedownIsFinished = true
				ent:Freeze(false)

				if type == "fist" and not downed then
					ent:StartRagdolling()
					ent:TakeDamage(30)
				else
					ent:StartRagdolling()

					ent:TakeDamage(ent:Health() + ent:Armor(), self, wep)
				end

				ent.Takedowning = false
				ent.TakedowningTarget = nil
				ent:SetSVAnimation("")
			end
		end)

		timer.Simple(delay1, function()
			if IsValid(self) and self.Takedowning then
				self:Freeze(false)
				self:SetEyeAngles(ang1)
				self:SetPos(pos1 + Vector(0, 0, 16))
				self.Takedowning = false
				self:SetSVAnimation("")
			end
		end)
	end)
end