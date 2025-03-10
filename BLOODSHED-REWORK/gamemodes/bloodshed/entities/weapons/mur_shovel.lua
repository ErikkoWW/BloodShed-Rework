AddCSLuaFile()
SWEP.PrintName = "Shovel"
SWEP.Slot = 0
SWEP.DrawWeaponInfoBox = false
SWEP.Melee = true
SWEP.MeleeHealth = 90
SWEP.TakedownType = "club"
SWEP.RagdollType = "Shovel"
SWEP.ViewModelFOV = 90
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/murdered/weapons/tfa_l4d_mw2019/melee/c_shovel.mdl"
SWEP.WorldModel = "models/murdered/weapons/tfa_l4d_mw2019/melee/w_shovel.mdl"
SWEP.BobScale = 2.5
SWEP.SwayScale = 1.8
SWEP.UseHands = true
SWEP.Primary.Ammo = "no"
SWEP.Primary.Delay = 1.3
SWEP.Primary.Throw = 15
SWEP.Primary.Damage = 20
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 2
SWEP.Secondary.Throw = 20
SWEP.Secondary.Damage = 30
SWEP.WorldModelPosition = Vector(3, -1.5, 0)
SWEP.WorldModelAngle = Angle(190, -110, 0)
SWEP.HoldType = "melee2"
SWEP.RunHoldType = "passive"
SWEP.HitDistance = 70

function SWEP:Initialize()
	if CLIENT then
		self.RunScale = 0
	end
end

function SWEP:Deploy(wep)
	local ply = self:GetOwner()
	ply:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_PLACE)
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:EmitSound("murdered/weapons/tfa_l4d_mw2019/shovel/guitar_deploy_1.wav")
end

function SWEP:IsRunning()
	return self:GetNWBool('Running')
end

function SWEP:PrimaryAttack()
	local angle = Angle(-self.Primary.Throw, 7, 0)
	local ply = self:GetOwner()

	if CLIENT and IsFirstTimePredicted() then
		local angle = Angle(-self.Primary.Throw, 0, 0)
		self:GetOwner():ViewPunchClient(angle)
	end

	ply:SetAnimation(PLAYER_ATTACK1)
	ply:EmitSound("murdered/weapons/tfa_l4d_mw2019/shovel/guitar_swing_miss" .. math.random(1, 2) .. ".wav")

	if math.random(1, 2) == 1 then
		self:SendWeaponAnim(ACT_VM_HITLEFT)
	else
		self:SendWeaponAnim(ACT_VM_HITRIGHT)
	end

	if SERVER then
		timer.Simple(0.3, function()
			if not IsValid(ply) or not IsValid(self) then return end

			local tr = util.TraceLine({
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos() + ply:GetAimVector() * self.HitDistance,
				filter = ply,
				mask = MASK_SHOT_HULL
			})

			if not IsValid(tr.Entity) then
				tr = util.TraceHull({
					start = ply:GetShootPos(),
					endpos = ply:GetShootPos() + ply:GetAimVector() * self.HitDistance,
					filter = ply,
					mins = Vector(-4, -4, -4),
					maxs = Vector(4, 4, 4),
					mask = MASK_SHOT_HULL
				})
			end

			local ent = tr.Entity

			if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or ent:GetClass() == "prop_ragdoll") then
				local ef = EffectData()
				ef:SetOrigin(tr.HitPos)
				ef:SetColor(0)
				util.Effect("BloodImpact", ef)
				local dm = DamageInfo()
				dm:SetDamage(self.Primary.Damage)
				dm:SetDamagePosition(tr.HitPos)
				dm:SetDamageType(DMG_SLASH)
				dm:SetAttacker(ply)
				dm:SetInflictor(self)
				ent:TakeDamageInfo(dm)
				ply:EmitSound("murdered/weapons/tfa_l4d_mw2019/shovel/melee_guitar_0" .. math.random(1, 2) .. ".wav")
			elseif string.match(ent:GetClass(), "_door") then
				ent:TakeDamage(150, self:GetOwner())
			elseif tr.Hit then
				if IsValid(ent) then
					local dm = DamageInfo()
					dm:SetDamage(self.Primary.Damage)
					dm:SetDamagePosition(tr.HitPos)
					dm:SetDamageType(DMG_SLASH)
					dm:SetAttacker(ply)
					dm:SetInflictor(self)
					ent:TakeDamageInfo(dm)
				end

				ply:EmitSound("murdered/weapons/tfa_l4d_mw2019/shovel/guitar_hit_world_0" .. math.random(1, 5) .. ".wav")
			end
		end)
	end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:SecondaryAttack()
	local angle2 = Angle(-self.Secondary.Throw, 0, 0)
	local ply = self:GetOwner()
	if CLIENT and IsFirstTimePredicted() then
		ply:ViewPunchClient(angle2)
	end
	ply:SetAnimation(PLAYER_ATTACK1)
	ply:DoAnimationEvent(ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND)
	ply:EmitSound("murdered/weapons/tfa_l4d_mw2019/shovel/guitar_swing_miss" .. math.random(1, 2) .. ".wav")
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	if SERVER then
		timer.Simple(0.35, function()
			if not IsValid(ply) or not IsValid(self) then return end

			local tr = util.TraceLine({
				start = ply:GetShootPos(),
				endpos = ply:GetShootPos() + ply:GetAimVector() * self.HitDistance,
				filter = ply,
				mask = MASK_SHOT_HULL
			})

			if not IsValid(tr.Entity) then
				tr = util.TraceHull({
					start = ply:GetShootPos(),
					endpos = ply:GetShootPos() + ply:GetAimVector() * self.HitDistance,
					filter = ply,
					mins = Vector(-4, -4, -4),
					maxs = Vector(4, 4, 4),
					mask = MASK_SHOT_HULL
				})
			end

			local ent = tr.Entity

			if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or ent:GetClass() == "prop_ragdoll") then
				local ef = EffectData()
				ef:SetOrigin(tr.HitPos)
				ef:SetColor(0)
				util.Effect("BloodImpact", ef)
				local dm = DamageInfo()
				dm:SetDamage(self.Secondary.Damage)
				dm:SetDamagePosition(tr.HitPos)
				dm:SetDamageType(DMG_SLASH)
				dm:SetAttacker(ply)
				dm:SetInflictor(self)
				ent:TakeDamageInfo(dm)
				ply:EmitSound("murdered/weapons/tfa_l4d_mw2019/shovel/melee_guitar_0" .. math.random(1, 2) .. ".wav")
			elseif tr.Hit then
				if IsValid(ent) then
					local dm = DamageInfo()
					dm:SetDamage(self.Secondary.Damage)
					dm:SetDamagePosition(tr.HitPos)
					dm:SetDamageType(DMG_SLASH)
					dm:SetAttacker(ply)
					dm:SetInflictor(self)
					ent:TakeDamageInfo(dm)
				end

				ply:EmitSound("murdered/weapons/tfa_l4d_mw2019/shovel/guitar_hit_world_0" .. math.random(1, 5) .. ".wav")
			end
		end)
	end

	self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:Think()
	local ow = self:GetOwner()

	if CLIENT then
		if self:IsRunning() then
			self.RunScale = math.min(self.RunScale + FrameTime() / 0.2, 1)
		else
			self.RunScale = math.max(self.RunScale - FrameTime() / 0.2, 0)
		end
	else
		self:SetNWBool('Running', ow:IsSprinting())

		if self:IsRunning() then
			self:SetHoldType(self.RunHoldType)
		else
			self:SetHoldType(self.HoldType)
		end
	end
end

function SWEP:Holster()
	return true
end

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local Owner = self:GetOwner()

		if IsValid(Owner) then
			local offsetVec = self.WorldModelPosition
			local offsetAng = self.WorldModelAngle
			local boneid = Owner:LookupBone("ValveBiped.Bip01_R_Hand")
			if not boneid then return end
			local matrix = Owner:GetBoneMatrix(boneid)
			if not matrix then return end
			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())
			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)
			WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end