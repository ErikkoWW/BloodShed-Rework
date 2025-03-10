AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Doritos"
SWEP.Slot = 5

SWEP.WorldModel = "models/murdered/loot/chipsdoritos.mdl"
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.Hunger = 15
SWEP.EatSound = "murdered/chips.mp3"

SWEP.WorldModelPosition = Vector(5, -5, -3)
SWEP.WorldModelAngle =  Angle(-90, 20, 0)

SWEP.ViewModelPos = Vector(1.399, 2, 2)
SWEP.ViewModelAng = Angle(0, 0, 20)

SWEP.HoldType = "slam"

SWEP.VElements = {
	["doritos"] = { type = "Model", model = "models/murdered/loot/chipsdoritos.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(-0.018, 0.316, -4), angle = Angle(114.055, 23.898, -11.726), size = Vector(0.55, 0.55, 0.55), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

function SWEP:Deploy( wep )
	self:SetHoldType(self.HoldType)
end

function SWEP:CustomPrimaryAttack()
	if SERVER then
		self:GetOwner():EmitSound(self.EatSound)
		self:GetOwner():ChangeHunger(self.Hunger, self)
		self:Remove()
	end 
end

function SWEP:CustomInit() 

end

function SWEP:CustomSecondaryAttack() 

end