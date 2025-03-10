AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Pepper Spray"
SWEP.Slot = 0
SWEP.DisableSuicide = true

SWEP.WorldModel = "models/murdered/weapons/pepperspray/pepperspray.mdl"
SWEP.ViewModel = "models/murdered/weapons/pepperspray/v_pepperspray.mdl"

SWEP.WorldModelPosition = Vector(3, -1, 1)
SWEP.WorldModelAngle =  Angle(180, 80, 0)

SWEP.ViewModelPos = Vector(0, -4, -4)
SWEP.ViewModelAng = Angle(-3, 3, -3)
SWEP.ViewModelFOV = 70

SWEP.HoldType = "pistol"

SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Battery"
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 5
SWEP.Secondary.Ammo = ""

function SWEP:Deploy( wep )
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetHoldType(self.HoldType)
end

function SWEP:CustomPrimaryAttack()
	local ply = self:GetOwner()
	if not ply:LookupBone('ValveBiped.Bip01_R_Hand') then return end
	if self.Weapon:Clip1() <= 0 then return end

	ply:SetAnimation( PLAYER_ATTACK1 )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	if CLIENT then return end

	self:TakePrimaryAmmo(1)
	ply:EmitSound('murdered/weapons/other/pepperspray.wav', 60)

	for i=1,10 do
		timer.Simple(0.1*i, function()
			if !IsValid(ply) then return end
			local effectdata = EffectData()
			effectdata:SetOrigin(ply:GetBonePosition(ply:LookupBone('ValveBiped.Bip01_R_Hand')))
			effectdata:SetFlags(5)
			effectdata:SetColor(1)
			effectdata:SetScale(1.5)
			effectdata:SetNormal(ply:GetAimVector())
			util.Effect("bloodspray", effectdata)
			if i == 10 and IsValid(self) then
				self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
			end
			local tr = util.TraceLine({
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:GetAimVector() * 150,
				filter = ply
			})
			local tar = tr.Entity
			if IsValid(tar) and tar.isRDRag then
				tar = tar.Owner
			end
			if tar:IsPlayer() then
				tar.peppertimevoice = CurTime()+0.2
				tar:SetNWFloat('peppereffect', CurTime()+15)
				tar:TakeDamage(1, ply)
			end
		end)
	end

	self:SetNextPrimaryFire(CurTime()+2)
end

function SWEP:CustomInit() 

end

function SWEP:CustomSecondaryAttack() 

end

if CLIENT then
	local blur = Material("pp/blurscreen")

	hook.Add("HUDPaint", "MuRPepper", function()
		if LocalPlayer():GetNWFloat('peppereffect') > CurTime() then
			for i=1,50 do
				surface.SetDrawColor(color_white)
				surface.SetMaterial(blur)
				blur:SetFloat("$blur", 2)
				blur:Recompute()
				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			end
			surface.SetDrawColor(200,25,0,25)
			surface.DrawRect(0,0,ScrW(),ScrH())
		end
	end)

	hook.Add("AdjustMouseSensitivity", "MuRPepper", function()
		if LocalPlayer():GetNWFloat('peppereffect') > CurTime() then
			return 0.2
		end
	end)
end