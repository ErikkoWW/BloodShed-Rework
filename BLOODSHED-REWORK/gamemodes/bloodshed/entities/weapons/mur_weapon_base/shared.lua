AddCSLuaFile()
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.DrawWeaponInfoBox = false
SWEP.Author = "HarionPlayZ"
SWEP.UseHands = true
SWEP.ViewModel = "models/murdered/weapons/c_pd2lordglekglock.mdl"
SWEP.WorldModel = "models/murdered/weapons/w_pd2lordglekglock.mdl"
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Delay = 0.2
SWEP.Primary.Throw = 2
SWEP.Primary.Damage = 30
SWEP.Primary.Spread = 4
SWEP.Primary.AimSpread = 1
SWEP.Primary.Recoil = 0.1
SWEP.Primary.Sound = "murdered/weapons/m9/m9_suppressed_fp.wav"
SWEP.EquipSound = "light"
SWEP.PenetrationPower = 1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IronsightPos = Vector(-1, -1.85, 1.1)
SWEP.IronsightFOV = 80
SWEP.RunPos = Vector(0, 4, -8)
SWEP.RunAng = Angle(-50, 0, 10)
SWEP.WorldModelPosition = Vector(0, -1, 0)
SWEP.WorldModelAngle = Angle(180, 180, 0)
SWEP.HoldType = "pistol"
SWEP.AimHoldType = "revolver"
SWEP.RunHoldType = "normal"

function SWEP:Deploy(wep)
	self:SendWeaponAnim(ACT_VM_DRAW)

	if self.EquipSound == "heavy" then
		self:EmitSound("murdered/weapons/universal/uni_weapon_draw_0" .. math.random(1, 3) .. ".wav", 40, math.random(90, 110))
	elseif self.EquipSound == "light" then
		self:EmitSound("murdered/weapons/universal/uni_pistol_draw_0" .. math.random(1, 3) .. ".wav", 40, math.random(90, 110))
	end
end

function SWEP:MakeRecoil()
	if SERVER then return end
	if not IsFirstTimePredicted() then return end

	local testx = {
		[-1] = -1,
		[0] = -1,
		[1] = -1,
		[2] = -1
	}

	local testy = {
		[-1] = -1,
		[0] = -1,
		[1] = 1,
		[2] = 1
	}

	local ang = self:GetOwner():EyeAngles()
	local x, y = testx[math.Round(util.SharedRandom("a", -1, 1))], testy[math.Round(util.SharedRandom("b", -1, 1, 1))]
	local recoil = (Angle(x, y / 3, 0) * self.Primary.Recoil / 2) * 3
	recoil.z = 0
	self:GetOwner():SetEyeAngles(ang + recoil)
end

function SWEP:Initialize()
	if CLIENT then
		self.IronsightScale = 0
		self.RunScale = 0
	else
		self.FOVAim = false
	end
end

function SWEP:IsAiming()
	return self:GetNWBool('Aiming')
end

function SWEP:IsRunning()
	return self:GetNWBool('Running')
end

function SWEP:IsReloading()
	return self:GetNWBool('Reloading')
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() or self:IsRunning() then return end

	if SERVER then
		self.Owner:SetLagCompensated(true)
	end

	self:EmitSound(self.Primary.Sound, 100, math.random(90, 110))
	local spread = self.Primary.Spread / 100

	if self:IsAiming() then
		spread = self.Primary.AimSpread / 100
	end

	self.CurrentPenetrationPower = self.PenetrationPower
	self:ShootBullet(self.Primary.Damage, 1, spread)

	if CLIENT then
		local angle = Angle(-self.Primary.Throw, 0, 0)
		self.Owner:ViewPunchClient(angle)
	end

	self:TakePrimaryAmmo(1)
	self:MakeRecoil()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if SERVER then
		self.Owner:SetLagCompensated(false)
	end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Think()
	local ow = self:GetOwner()

	if CLIENT then
	else
		self:SetNWBool('Aiming', ow:KeyDown(IN_ATTACK2) and not ow:IsSprinting())
		self:SetNWBool('Running', ow:IsSprinting())

		if self:IsAiming() then
			self:SetHoldType(self.AimHoldType)

			if not self.FOVAim then
				ow:SetFOV(self.IronsightFOV, 0.5)
				self.FOVAim = true
			end
		else
			if self:IsRunning() then
				self:SetHoldType(self.RunHoldType)
			else
				self:SetHoldType(self.HoldType)
			end

			if self.FOVAim then
				ow:SetFOV(0, 0.5)
				self.FOVAim = false
			end
		end
	end
end

function SWEP:Holster()
	local ow = self:GetOwner()

	if IsValid(ow) then
		ow:SetFOV(0, 0.1)
	end

	return true
end

function SWEP:OnRemove()
	local ow = self:GetOwner()

	if IsValid(ow) then
		ow:SetFOV(0, 0.1)
	end

	if CLIENT and IsValid(self.WM) then
		self.WM:Remove()
	end
end

function SWEP:CalcViewModelView(ViewModel, OldEyePos, OldEyeAng, EyePos, EyeAng)
	if self:IsAiming() then
		self.IronsightScale = math.min(self.IronsightScale + FrameTime(), 1)
	else
		self.IronsightScale = math.max(self.IronsightScale - FrameTime(), 0)
	end

	if self:IsRunning() then
		self.RunScale = math.min(self.RunScale + FrameTime(), 1)
	else
		self.RunScale = math.max(self.RunScale - FrameTime(), 0)
	end

	if IsValid(self:GetOwner()) then
		local iron = self.IronsightPos
		local runp, runa = self.RunPos, self.RunAng
		local pos = EyePos + (EyeAng:Forward() * iron.x + EyeAng:Right() * iron.y + EyeAng:Up() * iron.z) * self.IronsightScale

		if self.RunScale > 0 then
			pos = EyePos + (EyeAng:Forward() * runp.x + EyeAng:Right() * runp.y + EyeAng:Up() * runp.z) * self.RunScale
			EyeAng = EyeAng + Angle(runa.x * self.RunScale, runa.y * self.RunScale, runa.z * self.RunScale)
		end

		return pos, EyeAng
	end
end

if CLIENT then
	function SWEP:DrawWorldModel()
		local Owner = self:GetOwner()

		if IsValid(self.WM) then
			local wm = self.WM

			if IsValid(Owner) then
				local offsetVec = self.WorldModelPosition
				local offsetAng = self.WorldModelAngle
				local boneid = Owner:LookupBone("ValveBiped.Bip01_R_Hand")
				if not boneid then return end
				local matrix = Owner:GetBoneMatrix(boneid)
				if not matrix then return end
				local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())
				wm:SetPos(newPos)
				wm:SetAngles(newAng)
				wm:SetupBones()
			else
				wm:SetPos(self:GetPos())
				wm:SetAngles(self:GetAngles())
			end

			wm:DrawModel()
		else
			self.WM = ClientsideModel(self.WorldModel)
			self.WM:SetNoDraw(true)
		end
	end

	------------------------------------------------------------------------------------------------------------
	local function CleanINS2ProxyHands()
		local HandsEnt = INS2_HandsEnt

		if IsValid(HandsEnt) then
			HandsEnt:RemoveEffects(EF_BONEMERGE)
			HandsEnt:RemoveEffects(EF_BONEMERGE_FASTCULL)
			HandsEnt:SetParent(NULL)
			HandsEnt:Remove()
		end
	end

	local function tryParentHands(Hands, ViewModel, Player, Weapon)
		if not IsValid(ViewModel) or not IsValid(Weapon) or not Weapon.InsurgencyHands then
			CleanINS2ProxyHands()

			return
		end

		if not IsValid(Hands) then return end

		if ViewModel:LookupBone("R ForeTwist") and not ViewModel:LookupBone("ValveBiped.Bip01_R_Hand") then
			local HandsEnt = INS2_HandsEnt

			if not IsValid(HandsEnt) then
				INS2_HandsEnt = ClientsideModel("models/murdered/c_ins2_pmhands.mdl")
				INS2_HandsEnt:SetNoDraw(true)
				HandsEnt = INS2_HandsEnt
			end

			HandsEnt:SetParent(ViewModel)
			HandsEnt:SetPos(ViewModel:GetPos())
			HandsEnt:SetAngles(ViewModel:GetAngles())

			if not HandsEnt:IsEffectActive(EF_BONEMERGE) then
				HandsEnt:AddEffects(EF_BONEMERGE)
				HandsEnt:AddEffects(EF_BONEMERGE_FASTCULL)
			end

			Hands:SetParent(HandsEnt)
		else
			CleanINS2ProxyHands()
		end
	end

	hook.Add("PreDrawPlayerHands", "MuR_INSHandsFuck", tryParentHands)
end

----------------------------------------------------------PENETRATION
local matEasyPen = {
	[MAT_GLASS] = 0,
	[MAT_WOOD] = 1,
	[MAT_PLASTIC] = 1,
}

local function PenetrationShit(ent, data)
	local wep = ent:GetActiveWeapon()

	if IsValid(wep) and wep.Base == "mur_weapon_base" then
		if wep.CurrentPenetrationPower >= 0 then
			data.Damage = data.Damage / 1.5

			data.Callback = function(ent, tr, dmg)
				data.Src = tr.HitPos + data.Dir * 4

				if matEasyPen[tr.MatType] then
					wep.CurrentPenetrationPower = wep.CurrentPenetrationPower - matEasyPen[tr.MatType]
				else
					wep.CurrentPenetrationPower = wep.CurrentPenetrationPower - 2
				end

				if tr.Entity and (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then
					wep.CurrentPenetrationPower = wep.CurrentPenetrationPower - 1
					data.IgnoreEntity = tr.Entity
				end

				if wep.CurrentPenetrationPower >= 0 and not tr.HitSky then
					PenetrationShit(ent, data)
				end
			end

			ent:FireBullets(data)
		end
	end
end

hook.Add("EntityFireBullets", "MuR.WeaponBase", function(ent, data)
	if ent:IsPlayer() then
		local wep = ent:GetActiveWeapon()

		if IsValid(wep) and wep.Base == "mur_weapon_base" and wep.CurrentPenetrationPower == wep.PenetrationPower then
			data.Callback = function(ent, tr, dmg)
				if tr.Entity and (tr.Entity:IsPlayer() or tr.Entity:IsNPC()) then
					wep.CurrentPenetrationPower = wep.CurrentPenetrationPower - 1
					data.IgnoreEntity = tr.Entity
				end

				if matEasyPen[tr.MatType] then
					wep.CurrentPenetrationPower = wep.CurrentPenetrationPower - matEasyPen[tr.MatType]
				else
					wep.CurrentPenetrationPower = wep.CurrentPenetrationPower - 2
				end

				if wep.CurrentPenetrationPower >= 0 and not tr.HitSky then
					data.Src = tr.HitPos + data.Dir * 4
					PenetrationShit(ent, data)
				end
			end

			return true
		end
	end
end)