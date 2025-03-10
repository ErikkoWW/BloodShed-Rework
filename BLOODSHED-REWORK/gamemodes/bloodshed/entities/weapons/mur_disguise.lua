AddCSLuaFile()
SWEP.Slot = 5
SWEP.DrawWeaponInfoBox = false
SWEP.UseHands = true
SWEP.ViewModel = Model("models/murdered/c_handlooker.mdl")
SWEP.ViewModelFOV = 90
SWEP.WorldModel = ""
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.PrintName = "Disguise"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextIdle")
end

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
	self:SetNextIdle(0)
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()

	local tr = util.TraceLine({
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ply:GetAimVector() * 64,
		filter = ply,
		mask = MASK_SHOT_HULL
	})

	local ent = tr.Entity

	if IsValid(ent) and ent.isRDRag and not IsValid(ent.Owner) and ent.Male == ply.Male then
		if SERVER then
			local name = ent:GetNWString('Name')
			local col = ent.PlyColor
			local p = ent.Male
			local mod = ent:GetModel()
			local name2 = ply:GetNWString('Name')
			local col2 = ply:GetPlayerColor()
			local p2 = ply.Male
			local mod2 = ply:GetModel()
			ply:SetNWString('Name', name)
			ply:SetPlayerColor(col)
			ply:SetModel(mod)
			ply:ScreenFade(SCREENFADE.IN, color_black, 1, 0.1)
			ent:SetNWString('Name', name2)
			ent.PlyColor = col2
			ent:MakePlayerColor(ent.PlyColor)
			ent:SetModel(mod2)
		end

		local vm = ply:GetViewModel()
		vm:SendViewModelMatchingSequence(vm:LookupSequence("seq_admire_bms_old"))
		self:SetNextIdle(CurTime() + vm:SequenceDuration())
		self:SetNextPrimaryFire(CurTime() + 5)
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
	local vm = self:GetOwner():GetViewModel()

	if self:GetNextIdle() ~= 0 and self:GetNextIdle() < CurTime() then
		vm:SendViewModelMatchingSequence(vm:LookupSequence("reference"))
		self:SetNextIdle(0)
	end
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:Deploy()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("reference"))

	return true
end

function SWEP:DrawHUD()
	draw.SimpleText(MuR.Language["loot_disguise_1"], "MuR_Font1", ScrW() / 2, ScrH() - He(90), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(MuR.Language["loot_disguise_2"], "MuR_Font1", ScrW() / 2, ScrH() - He(75), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end