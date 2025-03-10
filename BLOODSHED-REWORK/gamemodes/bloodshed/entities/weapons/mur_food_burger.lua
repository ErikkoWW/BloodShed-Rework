AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Burger"
SWEP.Slot = 5

SWEP.WorldModel = "models/murdered/loot/mcdburger.mdl"
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.Hunger = 45
SWEP.EatSound = "murdered/eat.wav"

SWEP.WorldModelPosition = Vector(3, -3, -1)
SWEP.WorldModelAngle =  Angle(190, 180, 0)

SWEP.ViewModelPos = Vector(1.399, 2, 2)
SWEP.ViewModelAng = Angle(0, 0, 20)

SWEP.HoldType = "slam"

SWEP.VElements = {
	["burger"] = { type = "Model", model = "models/murdered/loot/mcdburger.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(0.19, 0.51, -2.549), angle = Angle(157.259, 137.486, 64.644), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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