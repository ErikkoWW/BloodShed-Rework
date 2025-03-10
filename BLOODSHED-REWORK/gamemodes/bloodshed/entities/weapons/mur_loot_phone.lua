AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Phone"
SWEP.Slot = 0

SWEP.WorldModel = "models/murdered/catsenya/props_pocox3nfc/catsenya_pocox3nfc.mdl"
SWEP.ViewModel = "models/weapons/c_bugbait.mdl"

SWEP.WorldModelPosition = Vector(4, -3, 3)
SWEP.WorldModelAngle =  Angle(180, 10, 0)

SWEP.ViewModelPos = Vector(0, -6, -7)
SWEP.ViewModelAng = Angle(0, -10, -40)
SWEP.ViewModelFOV = 70

SWEP.HoldType = "slam"

SWEP.ViewModelBoneMods = {
	["ValveBiped.cube3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.VElements = {      
	["card"] = { type = "Model", model = "models/murdered/catsenya/props_pocox3nfc/catsenya_pocox3nfc.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 3, 3), angle = Angle(180, 0, 12), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Deploy( wep )
	self:SetHoldType(self.HoldType)
end

function SWEP:CustomPrimaryAttack()
    if self.Called then return end
    self.Called = true
    self.VElements["card"].skin = 1      
    if SERVER then
        self:GetOwner():EmitSound("murdered/other/phone_call.wav", 60)
        timer.Simple(2.5, function()
            if !IsValid(self) or !IsValid(self.BrokenAtt) or !IsValid(self:GetOwner()) then return end

            self:GetOwner():StopSound("murdered/other/phone_call.wav")

            self:EmitSound(")murdered/weapons/grenade/m67_explode.wav", 90, math.random(80,120))
            ParticleEffect("AC_grenade_explosion_air", self:GetOwner():EyePos(), Angle(0,0,0))
            util.BlastDamage(self.BrokenAtt, self.BrokenAtt, self:GetOwner():EyePos(), 128, 96)

            self:Remove()
        end)
        timer.Simple(8.5, function()
            if !IsValid(self) or !IsValid(self:GetOwner()) then return end

            if self:GetOwner().Male then
                self:GetOwner():EmitSound("vo/npc/male01/help01.wav", 80, math.random(90,110))
            else
                self:GetOwner():EmitSound("vo/npc/female01/help01.wav", 80, math.random(90,110))
            end
        end)
        timer.Simple(10, function()
            if !IsValid(self) or !IsValid(self:GetOwner()) then return end
            self:Remove()
            if MuR.PoliceState == 0 then
                MuR:CallPolice(0.6)
            else
                local del = (MuR.PoliceArriveTime-CurTime())/1.5
                MuR.PoliceArriveTime = CurTime()+del
            end
        end)
    end 
end

function SWEP:OnDrop()
    if self.Called then
        self:Remove()
    end
end

function SWEP:CustomSecondaryAttack() 

end