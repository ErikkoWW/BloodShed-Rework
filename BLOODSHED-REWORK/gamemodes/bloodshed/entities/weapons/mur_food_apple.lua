AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Apple"
SWEP.Slot = 5

SWEP.WorldModel = "models/murdered/loot/apple1.mdl"
SWEP.ViewModel = "models/weapons/c_bugbait.mdl"
SWEP.Hunger = 10
SWEP.EatSound = "murdered/eat.wav"

SWEP.WorldModelPosition = Vector(3, -3, 2)
SWEP.WorldModelAngle =  Angle(190, 180, 0)

SWEP.ViewModelPos = Vector(1.399, 2, 2)
SWEP.ViewModelAng = Angle(0, 0, 20)

SWEP.HoldType = "slam"

SWEP.VElements = {
	["apple"] = { type = "Model", model = "models/murdered/loot/apple1.mdl", bone = "ValveBiped.cube3", rel = "", pos = Vector(-0.3, 3, -0.5), angle = Angle(0, -15, -90), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
	["ValveBiped.cube3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

function SWEP:Deploy( wep )
	self:SendWeaponAnim(ACT_VM_DRAW)
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