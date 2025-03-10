AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Adrenaline"
SWEP.Slot = 5

SWEP.WorldModel = "models/murdered/adrenaline/syringe/syringe_blood.mdl"
SWEP.ViewModel = "models/murdered/heroin/darky_m/c_syringe_v2.mdl"
SWEP.BandageSound = "murdered/medicals/syringe_adrenaline.wav"

SWEP.WorldModelPosition = Vector(4, -2, -2)
SWEP.WorldModelAngle =  Angle(90, 0, 0)

SWEP.ViewModelPos = Vector(0, 0, -2)
SWEP.ViewModelAng = Angle(0, 0, 0)
SWEP.ViewModelFOV = 65

SWEP.HoldType = "slam"

SWEP.VElements = {
	["adrenaline"] = { type = "Model", model = "models/murdered/adrenaline/syringe/syringe_blood.mdl", bone = "main", rel = "", pos = Vector(0, -7.72, -0.288), angle = Angle(0, 90, -30), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
	["main"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["button"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["cap"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["capup"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

function SWEP:Deploy( wep )
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetHoldType(self.HoldType)
end

function SWEP:CustomPrimaryAttack()
	if self.Used then return end
	self.Used = true
	self:SendWeaponAnim(ACT_VM_THROW)
	local ow = self:GetOwner()
	local ind = ow:EntIndex()
	if SERVER then
		ow:EmitSound(self.BandageSound)
		timer.Simple(2.4, function()
			if !IsValid(self) or !IsValid(ow) then return end
			MuR:GiveMessage("adrenaline_use", ow)
			timer.Create("AdrenalineUse"..ind, 0.05, 600, function()
				if !IsValid(ow) or !ow:Alive() then 
					timer.Remove("AdrenalineUse"..ind)
					return
				end
				ow:SetNWFloat('Stamina', ow:GetNWFloat('Stamina')+1)
			end)
			self:Remove()
		end)
	end 
end

function SWEP:OnDrop()
	if self.Used then
		self:Remove()
	end
end

function SWEP:CustomInit() 
	self.Used = false
end

function SWEP:CustomSecondaryAttack() 
	if self.Used then return end
	local ow = self:GetOwner()
	local tr = util.TraceLine({
		start = ow:GetShootPos(),
		endpos = ow:GetShootPos() + ow:GetAimVector() * 64,
		filter = ow,
		mask = MASK_SHOT_HULL
	})
	local tar = tr.Entity
	if tar.isRDRag and IsValid(tar.Owner) then
		tar = tar.Owner
	end
	if IsValid(tar) and tar:IsPlayer() then
		local ind = tar:EntIndex()
		self.Used = true
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		if SERVER then
			ow:EmitSound(self.BandageSound)
			timer.Simple(2.4, function()
				if !IsValid(self) or !IsValid(ow) then return end
				MuR:GiveMessage("adrenaline_use_target", ow)
				timer.Create("AdrenalineUse"..ind, 0.05, 600, function()
					if !IsValid(tar) or !tar:Alive() then 
						timer.Remove("AdrenalineUse"..ind)
						return
					end
					tar:SetNWFloat('Stamina', tar:GetNWFloat('Stamina')+1)
				end)
				self:Remove()
			end)
		end 
	end 
end

function SWEP:DrawHUD()
	local ply = self:GetOwner()
	draw.SimpleText(MuR.Language["loot_medic_left"], "MuR_Font1", ScrW()/2, ScrH()-He(100), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(MuR.Language["loot_medic_right"], "MuR_Font1", ScrW()/2, ScrH()-He(85), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end