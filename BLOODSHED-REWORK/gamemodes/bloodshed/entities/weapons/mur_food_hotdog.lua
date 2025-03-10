AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Hotdog"
SWEP.Slot = 5

SWEP.WorldModel = "models/murdered/loot/hotdog.mdl"
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.Hunger = 30
SWEP.EatSound = "murdered/eat.wav"

SWEP.WorldModelPosition = Vector(3, -2, -2)
SWEP.WorldModelAngle =  Angle(0, 10, 90)

SWEP.ViewModelPos = Vector(1.399, 2, 2)
SWEP.ViewModelAng = Angle(0, 0, 20)

SWEP.HoldType = "slam"

SWEP.VElements = {
	["hotdog"] = { type = "Model", model = "models/murdered/loot/hotdog.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(0.19, -0.125, -2.549), angle = Angle(172.582, 97.859, -52.521), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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