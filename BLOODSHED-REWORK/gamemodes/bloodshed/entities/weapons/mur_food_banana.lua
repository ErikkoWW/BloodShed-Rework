AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Banana"
SWEP.Slot = 5

SWEP.WorldModel = "models/murdered/loot/bananna.mdl"
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.Hunger = 15
SWEP.EatSound = "murdered/eat.wav"

SWEP.WorldModelPosition = Vector(3.227, -3, -2.6)
SWEP.WorldModelAngle =  Angle(180, 180, -41.991)

SWEP.ViewModelPos = Vector(1.399, 4, 0)
SWEP.ViewModelAng = Angle(0, 0, 20)

SWEP.HoldType = "slam"

SWEP.VElements = {
	["banana"] = { type = "Model", model = "models/murdered/loot/bananna.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(-0.239, -0.491, -4.321), angle = Angle(157.259, 131.141, -80.457), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
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