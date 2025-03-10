AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Red Bull"
SWEP.Slot = 5

SWEP.WorldModel = "models/murdered/loot/sodacanc01.mdl"
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.Hunger = 15
SWEP.EatSound = "murdered/soda.wav"

SWEP.WorldModelPosition = Vector(3.5, -2.5, -2)
SWEP.WorldModelAngle =  Angle(160, 70, 0)

SWEP.ViewModelPos = Vector(1.399, 2, 2)
SWEP.ViewModelAng = Angle(0, 0, 20)

SWEP.HoldType = "slam"

SWEP.VElements = {
	["redbull"] = { type = "Model", model = "models/murdered/loot/sodacanc01.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(-0.018, -0.152, -4), angle = Angle(-1.17, 105.165, 162.468), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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