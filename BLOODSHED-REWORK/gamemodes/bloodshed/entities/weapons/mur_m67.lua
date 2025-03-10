AddCSLuaFile()
SWEP.Base = "mur_loot_base"
SWEP.PrintName = "M67"
SWEP.Slot = 4
SWEP.WorldModel = "models/murdered/weapons/insurgency/w_m67.mdl"
SWEP.ViewModel = "models/murdered/weapons/insurgency/v_m67.mdl"
SWEP.IEDSound = "murdered/weapons/ied.wav"
SWEP.InsurgencyHands = true
SWEP.Primary.Delay = 3
SWEP.WorldModelPosition = Vector(3.5, -2, 2)
SWEP.WorldModelAngle = Angle(0, 60, 180)
SWEP.ViewModelPos = Vector(0, 1, 0)
SWEP.ViewModelAng = Angle(0, 0, 5)
SWEP.ViewModelFOV = 90
SWEP.HoldType = "grenade"

function SWEP:Deploy(wep)
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetHoldType(self.HoldType)
end

function SWEP:CustomPrimaryAttack()
	local vm = self:GetOwner():GetViewModel()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	if SERVER then
		self.Activated = true
		vm:SendViewModelMatchingSequence(vm:LookupSequence("pullbackhigh"))
		timer.Simple(0.5,function()
			if !IsValid(self) or !IsValid(self.Owner) then return end
			self:GetOwner():ViewPunch(Angle(2,2,0))
			self:GetOwner():EmitSound("murdered/weapons/grenade/f1_pinpull.wav", 60, math.random(90,110))
		end)
		timer.Simple(1.1,function()
			if !IsValid(self) or !IsValid(self.Owner) then return end
			self:GetOwner():ViewPunch(Angle(-5,-5,0))
		end)
		timer.Simple(1.3, function()
			if not IsValid(self) or not IsValid(self:GetOwner()) then return end
			vm:SendViewModelMatchingSequence(vm:LookupSequence("throw"))
			self:GetOwner():EmitSound("murdered/weapons/universal/uni_ads_in_0" .. math.random(2, 6) .. ".wav", 60, math.random(90, 110))
		end)
		timer.Simple(1.6, function()
			if not IsValid(self) or not IsValid(self:GetOwner()) then return end
			local ent = ents.Create("murwep_grenade")
			ent:SetPos(self:GetOwner():EyePos() + self:GetOwner():GetAimVector() * 4 + self:GetOwner():GetRight() * 4)
			ent.PlayerOwner = self:GetOwner()
			ent:Spawn()
			ent:GetPhysicsObject():SetVelocity(self:GetOwner():GetAimVector() * 1024)
			self:GetOwner():ViewPunch(Angle(10, 0, 0))
		end)

		timer.Simple(2.2, function()
			if not IsValid(self) then return end
			self:Remove()
		end)
	end
end

function SWEP:CustomSecondaryAttack()
	local vm = self:GetOwner():GetViewModel()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	if SERVER then
		self.Activated = true
		vm:SendViewModelMatchingSequence(vm:LookupSequence("pullbackhigh"))
		self:GetOwner():EmitSound("murdered/weapons/grenade/f1_pinpull.wav", 60, math.random(90, 110))
		self:GetOwner():ViewPunch(Angle(2,2,0))
		
		timer.Simple(0.8, function()
			if not IsValid(self) or not IsValid(self:GetOwner()) then return end
			local ent = ents.Create("murwep_grenade")
			ent:SetPos(self:GetOwner():GetPos())
			ent.PlayerOwner = self:GetOwner()
			ent.OwnerTrap = self:GetOwner()
			ent:Spawn()
			ent:GetPhysicsObject():SetVelocity(self:GetOwner():GetAimVector() * 1024)
			self:Remove()
		end)
	end
end

function SWEP:CustomInit()
	self.Activated = false
end

function SWEP:OnDrop()
	if self.Activated then
		self:Remove()
	end
end

function SWEP:DrawHUD()
	local ply = self:GetOwner()
	draw.SimpleText(MuR.Language["loot_grenade_1"], "MuR_Font1", ScrW()/2, ScrH()-He(100), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(MuR.Language["loot_grenade_2"], "MuR_Font1", ScrW()/2, ScrH()-He(85), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end