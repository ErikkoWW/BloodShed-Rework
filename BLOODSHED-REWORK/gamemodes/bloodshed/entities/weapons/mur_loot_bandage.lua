AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Bandage"
SWEP.Slot = 5

SWEP.WorldModel = "models/murdered/bandage/bandage.mdl"
SWEP.ViewModel = "models/murdered/bandage/v_bandage.mdl"
SWEP.BandageSound = "murdered/medicals/bandage.wav"

SWEP.WorldModelPosition = Vector(4, -2, -2)
SWEP.WorldModelAngle =  Angle(90, 0, 0)

SWEP.ViewModelPos = Vector(-0.05, 0, -6)
SWEP.ViewModelAng = Angle(-15, 0, 8)
SWEP.ViewModelFOV = 70

SWEP.HoldType = "slam"

function SWEP:Deploy( wep )
    self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetHoldType(self.HoldType)
end

function SWEP:CustomPrimaryAttack()
	if self.Used then return end
	local ow = self:GetOwner()
	if ow:GetNWFloat('BleedLevel') <= 0 and ow:Health() >= 100 then return end
	self.Used = true
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	ow:EmitSound(self.BandageSound)
    if SERVER then
		timer.Simple(1.4, function()
            if !IsValid(self) or !IsValid(ow) then return end
			MuR:GiveMessage("bandage_use", ow)
			ow:SetHealth(math.Clamp(ow:Health()+20, 1, 100))
			for i=1,2 do
				ow:DamagePlayerSystem("blood", true)
			end
			self:Remove()
        end)
	end 
end

function SWEP:OnDrop()
    if self.Used then
        self:Remove()
    end
end

function SWEP:CustomInit() 
	self.Used = false
end

function SWEP:CustomSecondaryAttack()
	if self.Used then return end 
	local ow = self:GetOwner()
	local tr = util.TraceLine({
		start = ow:GetShootPos(),
		endpos = ow:GetShootPos() + ow:GetAimVector() * 64,
		filter = ow,
		mask = MASK_SHOT_HULL
	})
	local tar = tr.Entity
	if tar.isRDRag and IsValid(tar.Owner) then
		tar = tar.Owner
	end
	if IsValid(tar) and tar:IsPlayer() then
		if tar:GetNWFloat('BleedLevel') <= 0 and tar:Health() >= 100 then return end
		self.Used = true
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		ow:EmitSound(self.BandageSound)
		if SERVER then
			timer.Simple(1.4, function()
				if !IsValid(self) or !IsValid(ow) then return end
				MuR:GiveMessage("bandage_use_target", ow)
				tar:SetHealth(math.Clamp(tar:Health()+20, 1, 100))
				for i=1,2 do
					tar:DamagePlayerSystem("blood", true)
				end
				self:Remove()
			end)
		end 
	end 
end

function SWEP:DrawHUD()
	local ply = self:GetOwner()
	draw.SimpleText(MuR.Language["loot_medic_left"], "MuR_Font1", ScrW()/2, ScrH()-He(100), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(MuR.Language["loot_medic_right"], "MuR_Font1", ScrW()/2, ScrH()-He(85), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end