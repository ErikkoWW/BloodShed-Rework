AddCSLuaFile()
SWEP.PrintName = "Ice Pick"
SWEP.Slot = 0
SWEP.DrawWeaponInfoBox = false
SWEP.Melee = true
SWEP.MeleeHealth = 70
SWEP.TakedownType = "hatchet"
SWEP.RagdollType = "IcePick"
SWEP.ViewModelFOV = 90
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/murdered/yurie/eft/weapons/dmm_rebel_adze_axe.mdl"
SWEP.WorldModel = "models/murdered/yurie/eft/weapons/world/dmm_rebel_adze_axe.mdl"
SWEP.BobScale = 2.5
SWEP.SwayScale = 1.8
SWEP.UseHands = true
SWEP.Primary.Ammo = "no"
SWEP.Primary.Delay = 1
SWEP.Primary.Throw = 8
SWEP.Primary.Damage = 17
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.WorldModelPosition = Vector(3, -2, -3.5)
SWEP.WorldModelAngle = Angle(180, 180, 0)
SWEP.HoldType = "melee"
SWEP.RunHoldType = "normal"
SWEP.HitDistance = 60

function SWEP:Initialize()
	if CLIENT then
		self.RunScale = 0
	end
end

function SWEP:Deploy(wep)
	local ply = self:GetOwner()
	ply:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_PLACE)
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:EmitSound("murdered/weapons/melee/knife_bayonet_equip.wav")
end

function SWEP:IsRunning()
	return self:GetNWBool('Running')
end

function SWEP:PrimaryAttack()
	local angle = Angle(-self.Primary.Throw, 3, 0)
	local ply = self:GetOwner()

	if CLIENT and IsFirstTimePredicted() then
		local angle = Angle(-self.Primary.Throw, 0, 0)
		self:GetOwner():ViewPunchClient(angle)
	end

	ply:SetAnimation(PLAYER_ATTACK1)
	ply:EmitSound("murdered/weapons/melee/crowbar_swing.mp3")

	if math.random(1, 2) == 1 then
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end

	if SERVER then
		timer.Simple(0.2, function()
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

				if ent.Armor and ent:Armor() > 0 then
					ply:EmitSound("murdered/weapons/melee/knife_bayonet_stab.wav")
				else
					ply:EmitSound("physics/body/body_medium_impact_hard" .. math.random(1, 5) .. ".wav")
				end
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

				ply:EmitSound("murdered/weapons/melee/knife_bayonet_hit_wall.wav")
			end
		end)
	end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:SecondaryAttack()
	local ply = self:GetOwner()
	ply:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_GIVE)
	self:SendWeaponAnim(ACT_VM_FIDGET)
	self:SetNextSecondaryFire(CurTime() + 3)

	return false
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