AddCSLuaFile()
SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Disassembly Tool"
SWEP.Slot = 5
SWEP.WorldModel = "models/murdered/weapons/w_barricadeswep.mdl"
SWEP.ViewModel = "models/murdered/weapons/c_barricadeswep.mdl"
SWEP.WorldModelPosition = Vector(4, -3, 3)
SWEP.WorldModelAngle = Angle(180, 10, 0)
SWEP.ViewModelPos = Vector(0, -1, -1)
SWEP.ViewModelAng = Angle(0, 0, 0)
SWEP.ViewModelFOV = 70
SWEP.HoldType = "melee"
SWEP.HitDistance = 56

function SWEP:Deploy(wep)
	self:SetHoldType(self.HoldType)
end

function SWEP:CustomPrimaryAttack()
	local ply = self:GetOwner()
	local tr = util.TraceLine({
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ply:GetAimVector() * self.HitDistance,
		filter = ply,
		mask = MASK_SHOT_HULL
	})
	local ent = tr.Entity

	if IsValid(ent) and ent:IsWeapon() and (ent:GetClass() == "mur_loot_phone" or string.match(ent:GetClass(), "tacrp")) and !IsValid(ent.BrokenAtt) then
		if SERVER then
			ent.BrokenAtt = ply 
			ply:EmitSound("physics/concrete/concrete_break2.wav", 50)
		end
		ply:SetAnimation(PLAYER_ATTACK1)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end

function SWEP:DrawHUD()
	local ply = self:GetOwner()
	draw.SimpleText(MuR.Language["loot_dis"], "MuR_Font1", ScrW() / 2, ScrH() - He(100), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SWEP:CustomSecondaryAttack()
end

if SERVER then
	hook.Add("EntityFireBullets", "MuR_CheckWeaponBroken", function(ent, data)
		if ent:IsPlayer() then
			ent = ent:GetActiveWeapon()
		end
		if ent:GetClass() == "murwep_ragdoll_weapon" and IsValid(ent.Weapon) then
			ent = ent.Weapon
		end
		if IsValid(ent) and ent:IsWeapon() and IsValid(ent.BrokenAtt) and IsValid(ent:GetOwner()) then
			timer.Simple(0.1, function()
				if !IsValid(ent) or !IsValid(ent.BrokenAtt) or !IsValid(ent:GetOwner()) then return end
				ParticleEffect("AC_grenade_explosion_air", ent:GetOwner():EyePos(), Angle(0,0,0))
				util.BlastDamage(ent.BrokenAtt, ent.BrokenAtt, ent:GetOwner():EyePos(), 400, 200)
				ent:GetOwner():EmitSound(")murdered/weapons/grenade/m67_explode.wav", 90, math.random(80,120))
				SafeRemoveEntity(ent, 0.01)
			end)
		end
	end)
end