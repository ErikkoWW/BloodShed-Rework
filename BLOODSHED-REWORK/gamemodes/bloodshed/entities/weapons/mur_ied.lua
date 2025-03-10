AddCSLuaFile()
SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Improvised Explosive Device"
SWEP.Slot = 4
SWEP.WorldModel = "models/murdered/saraphines/insurgency explosives/ied/insurgency_ied_phone.mdl"
SWEP.ViewModel = "models/murdered/weapons/insurgency/v_ied_ins.mdl"
SWEP.IEDSound = "murdered/weapons/grenade/ied.wav"
SWEP.InsurgencyHands = true
SWEP.Primary.Delay = 0
SWEP.Secondary.Delay = 1
SWEP.WorldModelPosition = Vector(7.5, 0, -16)
SWEP.WorldModelAngle = Angle(-10, 30, 180)
SWEP.ViewModelPos = Vector(0, 1, -1)
SWEP.ViewModelAng = Angle(0, 0, -5)
SWEP.ViewModelFOV = 90
SWEP.HoldType = "slam"

function SWEP:Deploy(wep)
	if self.DetonateDrawed then
		--local vm = self:GetOwner():GetViewModel()
		--vm:SendViewModelMatchingSequence(vm:LookupSequence("det_draw"))
	--else
		self:SendWeaponAnim(ACT_VM_DRAW)
	end

	self:SetHoldType(self.HoldType)
end

function SWEP:CustomPrimaryAttack()
	local vm = self:GetOwner():GetViewModel()
	if self.DetonateDrawed == true then return false end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self.DetonateDrawed = true

	if SERVER then
		self:SendWeaponAnim(ACT_VM_THROW)
		self:GetOwner():EmitSound("murdered/weapons/universal/uni_ads_in_0" .. math.random(2, 6) .. ".wav", 60, math.random(90, 110))
		self.ExplodeEntity = ents.Create("murwep_ied")
		self.ExplodeEntity:SetPos(self:GetOwner():EyePos() + self:GetOwner():GetAimVector() * 4 + self:GetOwner():GetRight() * 4)
		self.ExplodeEntity:Spawn()
		self.ExplodeEntity.PlayerOwner = self:GetOwner()
		self.ExplodeEntity:GetPhysicsObject():SetVelocity(self:GetOwner():GetAimVector() * 256)
		self:GetOwner():ViewPunch(Angle(10, 5, 0))

		timer.Simple(1, function()
			if not IsValid(self) or not IsValid(self:GetOwner()) then return end
			vm:SendViewModelMatchingSequence(vm:LookupSequence("det_draw"))
		end)
	end
end

function SWEP:CustomSecondaryAttack()
	local vm = self:GetOwner():GetViewModel()

	if self.DetonateDrawed == true then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

		if SERVER then
			vm:SendViewModelMatchingSequence(vm:LookupSequence("det_detonate"))

			timer.Simple(.15, function()
				if not IsValid(self) or not IsValid(self.ExplodeEntity) or not IsValid(self:GetOwner()) then return end
				self.ExplodeEntity:EmitSound(self.IEDSound, 60)
				self:GetOwner():ViewPunch(Angle(1, 0, 0))
			end)

			timer.Simple(1, function()
				if not IsValid(self) then return end

				if IsValid(self.ExplodeEntity) then
					self.ExplodeEntity:Explode()
				end

				self:Remove()
			end)
		end
	end
end

function SWEP:Reload()
	local tr = util.TraceLine({
		start = self:GetOwner():GetShootPos(),
		endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 64,
		filter = self:GetOwner(),
		mask = MASK_SHOT_HULL
	})

	if tr.Hit and tr.Entity ~= game.GetWorld() and not tr.Entity:IsPlayer() then
		local vm = self:GetOwner():GetViewModel()
		if self.DetonateDrawed == true then return false end
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
		self.DetonateDrawed = true

		if SERVER then
			self:SendWeaponAnim(ACT_VM_THROW)
			self:GetOwner():EmitSound("murdered/weapons/universal/uni_ads_in_0" .. math.random(2, 6) .. ".wav", 60, math.random(90, 110))
			self.ExplodeEntity = ents.Create("murwep_ied")
			self.ExplodeEntity:SetPos(tr.HitPos)
			self.ExplodeEntity:SetAngles(tr.HitNormal:Angle() + Angle(0, 270, 0))
			self.ExplodeEntity.PlayerOwner = self:GetOwner()
			self.ExplodeEntity:Spawn()
			self.ExplodeEntity:SetModelScale(0.3, 0)
			self.ExplodeEntity:SetNotSolid(true)
			self.ExplodeEntity.ExplosionDamageMult = 0.4
			self.ExplodeEntity:SetParent(tr.Entity)

			tr.Entity:CallOnRemove("Pizdec", function()
				if IsValid(self.ExplodeEntity) then
					self.ExplodeEntity:Explode()
				end
			end)

			self:GetOwner():ViewPunch(Angle(10, 5, 0))

			timer.Simple(1, function()
				if not IsValid(self) or not IsValid(self:GetOwner()) then return end
				vm:SendViewModelMatchingSequence(vm:LookupSequence("det_draw"))
			end)
		end
	end
end

function SWEP:CustomInit()
	self.DetonateDrawed = false
	self.ExplodeEntity = nil
end

function SWEP:DrawHUD()
	local ply = self:GetOwner()
	draw.SimpleText(MuR.Language["loot_ied_1"], "MuR_Font1", ScrW()/2, ScrH()-He(115), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(MuR.Language["loot_ied_2"], "MuR_Font1", ScrW()/2, ScrH()-He(100), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(MuR.Language["loot_ied_3"], "MuR_Font1", ScrW()/2, ScrH()-He(85), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end