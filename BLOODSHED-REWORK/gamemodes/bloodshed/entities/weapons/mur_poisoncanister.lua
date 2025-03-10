AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Poison Canister"
SWEP.Slot = 5

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/props_junk/garbage_metalcan001a.mdl"

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["models/props_junk/garbage_metalcan001a.mdl"] = { type = "Model", model = "models/props_junk/garbage_metalcan001a.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(0, 0, -2.494), angle = Angle(180, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WorldModelPosition = Vector(3, -2, -1)
SWEP.WorldModelAngle =  Angle(170, 90, 0)

SWEP.ViewModelPos = Vector(0, 1, 3)
SWEP.ViewModelAng = Angle(10, 0, 0)
SWEP.ViewModelFOV = 70

SWEP.HoldType = "slam"

function SWEP:Deploy( wep )
	self:SetHoldType(self.HoldType)
end

function SWEP:CustomPrimaryAttack()
	if self.Used then return end 
	local ow = self:GetOwner()
	local tr = util.TraceLine({
		start = ow:GetShootPos(),
		endpos = ow:GetShootPos() + ow:GetAimVector() * 64,
		filter = ow,
		mask = MASK_SHOT_HULL
	})
	local tar = tr.Entity
	if IsValid(tar) and tar:IsWeapon() then
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		self.Used = true
		self:EmitSound("physics/cardboard/cardboard_box_impact_soft1.wav", 40)

		if CLIENT then return end

		timer.Simple(0.5, function()
			if !IsValid(self) or !IsValid(ow) then return end
			if IsValid(tar) then
				tar.Poison = true
			end
			MuR:GiveMessage("poison_use", ow)
			self:Remove()
		end)
	end
end

function SWEP:CustomInit() 
	self.Used = false
end

function SWEP:OnDrop()
	if self.Used then
		self:Remove()
	end
end

function SWEP:DrawHUD()
	local ply = self:GetOwner()
	draw.SimpleText(MuR.Language["loot_poison"], "MuR_Font1", ScrW()/2, ScrH()-He(100), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end