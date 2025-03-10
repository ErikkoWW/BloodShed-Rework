AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Cola Bottle"
SWEP.Slot = 5

SWEP.WorldModel = "models/murdered/loot/cola.mdl"
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.Hunger = 15
SWEP.EatSound = "murdered/soda.wav"

SWEP.WorldModelPosition = Vector(3, -3, -3)
SWEP.WorldModelAngle =  Angle(190, 180, 0)

SWEP.ViewModelPos = Vector(1.399, 2, 2)
SWEP.ViewModelAng = Angle(0, 0, 20)

SWEP.HoldType = "slam"

SWEP.VElements = {
	["colasmall"] = { type = "Model", model = "models/murdered/loot/cola.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(-0.51, -0.389, -3.978), angle = Angle(180, -32.996, -4.665), size = Vector(0.778, 0.778, 0.778), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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