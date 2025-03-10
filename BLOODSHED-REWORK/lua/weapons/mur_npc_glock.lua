AddCSLuaFile()

sound.Add({
	name = "Weapon_MUR_GLOCK_Z.NPC_Fire",
	level = 130,
	pitch = {90,110},
	channel = CHAN_WEAPON,
	volume = 0.75,
	sound = "^murdered/weapons/m1911/m1911_fp.wav",
})

sound.Add({
	name = "Weapon_MUR_GLOCK_Z.Reload",
	level = 70,
	pitch = 100,
	channel = CHAN_STATIC,
	volume = 0.4,
	sound = "murdered/weapons/universal/uni_gl_beginreload_01.wav",
})

SWEP.Base = "weapon_zbase"
SWEP.PrintName = "Glock"
SWEP.Author = "Hari"
SWEP.Spawnable = false
SWEP.WorldModel = Model( "models/murdered/weapons/w_glock.mdl" )

SWEP.IsZBaseWeapon = true
SWEP.NPCSpawnable = true -- Add to NPC weapon list

-- NPC Stuff
SWEP.NPCOnly = true -- Should only NPCs be able to use this weapon?
SWEP.NPCCanPickUp = true -- Can NPCs pick up this weapon from the ground
SWEP.NPCBurstMin = 1 -- Minimum amount of bullets the NPC can fire when firing a burst
SWEP.NPCBurstMax = 3 -- Maximum amount of bullets the NPC can fire when firing a burst
SWEP.NPCFireRate = 0.3 -- Shoot delay in seconds
SWEP.NPCFireRestTimeMin = 0.4 -- Minimum amount of time the NPC rests between bursts in seconds
SWEP.NPCFireRestTimeMax = 0.8 -- Maximum amount of time the NPC rests between bursts in seconds
SWEP.NPCBulletSpreadMult = 1 -- Higher number = worse accuracy
SWEP.NPCReloadSound = "Weapon_MUR_GLOCK_Z.Reload" -- Sound when the NPC reloads the gun
SWEP.NPCShootDistanceMult = 1 -- Multiply the NPCs shoot distance by this number with this weapon

-- Basic primary attack stuff
SWEP.Primary.ClipSize = 17
SWEP.PrimaryDamage = 12
SWEP.PrimaryShootSound = "Weapon_MUR_GLOCK_Z.NPC_Fire"
SWEP.PrimarySpread = 0.02
SWEP.Primary.Ammo = "Pistol" -- https://wiki.facepunch.com/gmod/Default_Ammo_Types
SWEP.Primary.ShellEject = "1" -- Set to the name of an attachment to enable shell ejection
SWEP.Primary.Force = 1

SWEP.NPCHoldType =  "pistol"

function SWEP:Initialize()
	self:SetHoldType( "pistol" )
end

function SWEP:OnDrop()
	self:Remove()
end

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)
	WorldModel:DrawShadow(false)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(5, -1, -2)
			local offsetAng = Angle(180, 90, 5)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand")
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

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