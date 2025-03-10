AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Cola 1L Bottle"
SWEP.Slot = 5

SWEP.WorldModel = "models/murdered/loot/colabig.mdl"
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.Hunger = 25
SWEP.EatSound = "murdered/slurp.wav"

SWEP.WorldModelPosition = Vector(3, -3, -3)
SWEP.WorldModelAngle =  Angle(190, 180, 0)

SWEP.ViewModelPos = Vector(1.399, 2, 2)
SWEP.ViewModelAng = Angle(0, 0, 20)

SWEP.HoldType = "slam"

SWEP.VElements = {
	["colabig"] = { type = "Model", model = "models/murdered/loot/colabig.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(-0.018, -0.271, -4), angle = Angle(-178.219, 30.181, -9.75), size = Vector(0.656, 0.656, 0.656), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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