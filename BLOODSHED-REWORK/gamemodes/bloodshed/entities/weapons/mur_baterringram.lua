AddCSLuaFile()
SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Baterring Ram"
SWEP.Slot = 5
SWEP.NeverDrop = true
SWEP.WorldModel = "models/murdered/swep_battering_ram/w_battering_ram.mdl"
SWEP.ViewModel = "models/murdered/swep_battering_ram/c_battering_ram.mdl"
SWEP.WorldModelPosition = Vector(4, 40, 15)
SWEP.WorldModelAngle = Angle(0, 0, 90)
SWEP.ViewModelPos = Vector(0, -1, -2)
SWEP.ViewModelAng = Angle(0, 0, 5)
SWEP.ViewModelFOV = 80
SWEP.HoldType = "shotgun"

function SWEP:Deploy(wep)
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetHoldType(self.HoldType)
end

function SWEP:CustomPrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 2)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	timer.Simple(0.4, function()
		if not IsValid(self) or not IsValid(self:GetOwner()) or CLIENT then return end

		local tr = util.TraceLine({
			start = self:GetOwner():GetShootPos(),
			endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 64,
			filter = self:GetOwner(),
			mask = MASK_SHOT_HULL
		})

		if IsValid(tr.Entity) then
			if string.match(tr.Entity:GetClass(), "_door") then
				tr.Entity:TakeDamage(200, self:GetOwner())
				self:GetOwner():EmitSound("physics/concrete/rock_impact_hard" .. math.random(1, 3) .. ".wav")
			else
				tr.Entity:TakeDamage(40, self:GetOwner())
				self:GetOwner():EmitSound("physics/body/body_medium_impact_hard" .. math.random(1, 6) .. ".wav")
			end
		end
	end)
end

function SWEP:CustomSecondaryAttack()
end

function SWEP:CustomInit()
end