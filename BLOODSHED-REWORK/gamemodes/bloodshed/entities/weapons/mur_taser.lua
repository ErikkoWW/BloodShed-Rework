AddCSLuaFile()
SWEP.Base = "mur_weapon_base"
SWEP.PrintName = "Taser"
SWEP.Slot = 1
SWEP.DisableSuicide = true
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/murdered/weapons/c_taser.mdl"
SWEP.WorldModel = "models/murdered/weapons/w_taser.mdl"
SWEP.SwayScale = 0.6
SWEP.BobScale = 0.7
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "GaussEnergy"
SWEP.IronsightPos = Vector(-2, -7.25, 2)
SWEP.IronsightFOV = 80
SWEP.RunPos = Vector(0, 4, -8)
SWEP.RunAng = Angle(-50, 0, 10)
SWEP.WorldModelPosition = Vector(6, -1.5, -2)
SWEP.WorldModelAngle = Angle(90, 90, 0)
SWEP.HoldType = "pistol"
SWEP.AimHoldType = "revolver"
SWEP.RunHoldType = "normal"
SWEP.HitDistance = 275

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	local ow = self:GetOwner()

	if CLIENT and IsFirstTimePredicted() then
		local angle = Angle(-self.Primary.Throw, 0, 0)
		self:GetOwner():ViewPunchClient(angle)
	end

	if SERVER then
		ow:EmitSound("murdered/other/taser.wav", 60)

		local tr = util.TraceLine({
			start = ow:GetShootPos(),
			endpos = ow:GetShootPos() + ow:GetAimVector() * self.HitDistance,
			filter = ow,
			mask = MASK_SHOT_HULL
		})

		local i = 0
		local tar = tr.Entity
		if IsValid(tar) and tar.isRDRag then
			tar = tar.Owner
		end

		if IsValid(tar) and tar:IsPlayer() then
			local ind = tar:EntIndex()
			tar:StartRagdolling()

			timer.Create("Tasered" .. ind, 0.01, 300, function()
				i = i + 1

				if not IsValid(tar) or not tar:Alive() then
					timer.Remove("Tasered" .. ind)

					return
				end

				if IsValid(tar:GetRD()) then
					tar:GetRD():StruggleBone()
					tar.IsRagStanding = false
				end
				local rnd = tar:EyeAngles() + AngleRand(-10, 10)
				rnd.z = 0
				tar:SetEyeAngles(rnd)
			end)
		end

		self:TakePrimaryAmmo(1)
		self:SetNextPrimaryFire(CurTime() + 2)
	end
end