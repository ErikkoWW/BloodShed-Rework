local meta = FindMetaTable("Player")
util.AddNetworkString("MuR.SendDataToClient")
util.AddNetworkString("MuR.PlaySoundOnClient")
util.AddNetworkString("MuR.ChatAdd")
util.AddNetworkString("MuR.Announce")
util.AddNetworkString("MuR.Message")
util.AddNetworkString("MuR.Message2")
util.AddNetworkString("MuR.Countdown")
util.AddNetworkString("MuR.FinalScreen")
util.AddNetworkString("MuR.ViewPunch")
util.AddNetworkString("MuR.RD_Cam")
util.AddNetworkString("MuR.PainImpulse")
util.AddNetworkString("MuR.StartScreen")
util.AddNetworkString("MuR.VoiceLines")
util.AddNetworkString("MuR.ShowLogScreen")

MuR.guiltSession = {}
local WeaponsTableAoCK = {
	["Ranged"] = {
		{
			class = "aoc_crossbow",
			ammo = "aoc_itemquiver",
			count = 2,
		},
		{
			class = "aoc_spear_thrown",
			ammo = "aoc_itemspear",
			count = 2,
		},
		{
			class = "aoc_dart_thrown",
			ammo = "aoc_itemdart",
			count = 2,
		},
		{
			class = "aoc_longbow",
			ammo = "aoc_itemquiver",
			count = 2,
		},
		{
			class = "aoc_axe_thrown",
			ammo = "aoc_itemaxe",
			count = 2,
		},
	},
	["Close"] = {
		{
			class = "aoc_sword_evil_shield",
		},
		{
			class = "aoc_flail_evil_shield",
		},
		{
			class = "aoc_shortsword_evil_shield",
		},
		{
			class = "aoc_flamberge_kiteshield",
		},
		{
			class = "aoc_mace_buckler",
		},
		{
			class = "aoc_spear_buckler",
		},
		{
			class = "aoc_spikedmace_buckler",
		},
		{
			class = "qqqqqqqqqqqqqqqqqqqqqqqqqqqq_shield",
		},
		{
			class = "aoc_onehandaxe",
		},
		{
			class = "aoc_sword_evil",
		},
		{
			class = "aoc_shortsword_evil",
		},
		{
			class = "aoc_halberd_evil",
		},
		{
			class = "aoc_mace",
		},
		{
			class = "aoc_spikedmace",
		},
		{
			class = "aoc_sword_silver",
		},
	},
	["Long"] = {
		{
			class = "aoc_flamberge",
		},
		{
			class = "aoc_doubleaxe",
		},
		{
			class = "aoc_halberd",
		},
		{
			class = "aoc_warhammer",
		},
	},
}

local WeaponsTableAoCM = {
	["Ranged"] = {
		{
			class = "aoc_crossbow",
			ammo = "aoc_itemquiver",
			count = 2,
		},
		{
			class = "aoc_spear_thrown",
			ammo = "aoc_itemspear",
			count = 2,
		},
		{
			class = "aoc_dart_thrown",
			ammo = "aoc_itemdart",
			count = 2,
		},
		{
			class = "aoc_longbow",
			ammo = "aoc_itemquiver",
			count = 2,
		},
		{
			class = "aoc_axe_thrown",
			ammo = "aoc_itemaxe",
			count = 2,
		},
	},
	["Close"] = {
		{
			class = "aoc_sword_shield",
		},
		{
			class = "aoc_flail_good_shield",
		},
		{
			class = "aoc_shortsword_shield",
		},
		{
			class = "aoc_longsword_kiteshield",
		},
		{
			class = "aoc_mace_buckler",
		},
		{
			class = "aoc_spear_buckler_good",
		},
		{
			class = "aoc_spikedmace_buckler_good",
		},
		{
			class = "aoc_sword_silver_shield",
		},
		{
			class = "aoc_onehandaxe",
		},
		{
			class = "aoc_mace",
		},
		{
			class = "aoc_spikedmace_good",
		},
		{
			class = "aoc_sword_iron",
		},
	},
	["Long"] = {
		{
			class = "aoc_longsword",
		},
		{
			class = "aoc_dagger",
		},
		{
			class = "aoc_halberd",
		},
		{
			class = "aoc_warhammer",
		},
	},
}


local WeaponsTableCT = {
	["Primary"] = {
		{
			class = "tacrp_ex_m4a1",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_m4",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_aug",
			ammo = "SMG1",
			count = 36,
		},
		{
			class = "tacrp_p90",
			ammo = "Pistol",
			count = 50,
		},
		{
			class = "tacrp_mp5",
			ammo = "Pistol",
			count = 30,
		},
		{
			class = "tacrp_ex_ump45",
			ammo = "Pistol",
			count = 25,
		},
		{
			class = "tacrp_fp6",
			ammo = "Buckshot",
			count = 8,
		},
		{
			class = "tacrp_tgs12",
			ammo = "Buckshot",
			count = 6,
		},
		{
			class = "tacrp_hk417",
			ammo = "AR2",
			count = 20,
		},
		{
			class = "tacrp_uratio",
			ammo = "357",
			count = 6,
		},
		{
			class = "tacrp_g36k",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_as50",
			ammo = "357",
			count = 6,
		},
	},
	["Secondary"] = {
		{
			class = "tacrp_ex_glock",
			ammo = "Pistol",
			count = 18,
		},
		{
			class = "tacrp_vertec",
			ammo = "Pistol",
			count = 15,
		},
		{
			class = "tacrp_ex_hk45c",
			ammo = "Pistol",
			count = 10,
		},
		{
			class = "tacrp_ex_usp",
			ammo = "Pistol",
			count = 12,
		},
	},
}	

local WeaponsTableT = {
	["Primary"] = {
		{
			class = "tacrp_ex_ak47",
			ammo = "AR2",
			count = 30,
		},
		{
			class = "tacrp_amd65",
			ammo = "AR2",
			count = 30,
		},
		{
			class = "tacrp_k1a",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_ak47",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_sg551",
			ammo = "SMG1",
			count = 20,
		},
		{
			class = "tacrp_ex_mp9",
			ammo = "Pistol",
			count = 30,
		},
		{
			class = "tacrp_mp7",
			ammo = "Pistol",
			count = 40,
		},
		{
			class = "tacrp_pdw",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_superv",
			ammo = "Pistol",
			count = 24,
		},
		{
			class = "tacrp_ks23",
			ammo = "Buckshot",
			count = 4,
		},
		{
			class = "tacrp_bekas",
			ammo = "Buckshot",
			count = 6,
		},
		{
			class = "tacrp_spr",
			ammo = "357",
			count = 6,
		},
		{
			class = "tacrp_ex_hecate",
			ammo = "357",
			count = 6,
		},
	},
	["Secondary"] = {
		{
			class = "tacrp_ex_m1911",
			ammo = "Pistol",
			count = 7,
		},
		{
			class = "tacrp_p2000",
			ammo = "Pistol",
			count = 15,
		},
		{
			class = "tacrp_gsr1911",
			ammo = "Pistol",
			count = 8,
		},
		{
			class = "tacrp_p250",
			ammo = "Pistol",
			count = 12,
		},

	},
}

local WeaponsTable = {
	["Primary"] = {
		{
			class = "tacrp_ex_ak47",
			ammo = "AR2",
			count = 30,
		},
		{
			class = "tacrp_amd65",
			ammo = "AR2",
			count = 30,
		},
		{
			class = "tacrp_ex_m4a1",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_k1a",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_m4",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_ak47",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_g36k",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_sg551",
			ammo = "SMG1",
			count = 20,
		},
		{
			class = "tacrp_aug",
			ammo = "SMG1",
			count = 36,
		},
		{
			class = "tacrp_ex_mp9",
			ammo = "Pistol",
			count = 30,
		},
		{
			class = "tacrp_p90",
			ammo = "Pistol",
			count = 50,
		},
		{
			class = "tacrp_mp5",
			ammo = "Pistol",
			count = 30,
		},
		{
			class = "tacrp_mp7",
			ammo = "Pistol",
			count = 40,
		},
		{
			class = "tacrp_ex_ump45",
			ammo = "Pistol",
			count = 25,
		},
		{
			class = "tacrp_pdw",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_superv",
			ammo = "Pistol",
			count = 24,
		},
		{
			class = "tacrp_m4star10",
			ammo = "Buckshot",
			count = 7,
		},
		{
			class = "tacrp_fp6",
			ammo = "Buckshot",
			count = 8,
		},
		{
			class = "tacrp_ks23",
			ammo = "Buckshot",
			count = 4,
		},
		{
			class = "tacrp_bekas",
			ammo = "Buckshot",
			count = 6,
		},
		{
			class = "tacrp_tgs12",
			ammo = "Buckshot",
			count = 6,
		},
		{
			class = "tacrp_civ_p90",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_civ_mp5",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_m1",
			ammo = "SMG1",
			count = 30,
		},
		{
			class = "tacrp_dsa58",
			ammo = "AR2",
			count = 20,
		},
		{
			class = "tacrp_hk417",
			ammo = "AR2",
			count = 20,
		},
		{
			class = "tacrp_uratio",
			ammo = "357",
			count = 6,
		},
		{
			class = "tacrp_spr",
			ammo = "357",
			count = 6,
		},
	},
	["Secondary"] = {
		{
			class = "tacrp_glock",
			ammo = "Pistol",
			count = 18,
		},
		{
			class = "tacrp_vertec",
			ammo = "Pistol",
			count = 15,
		},
		{
			class = "tacrp_ex_m1911",
			ammo = "Pistol",
			count = 7,
		},
		{
			class = "tacrp_ex_hk45c",
			ammo = "Pistol",
			count = 10,
		},
		{
			class = "tacrp_p2000",
			ammo = "Pistol",
			count = 15,
		},
		{
			class = "tacrp_ex_usp",
			ammo = "Pistol",
			count = 12,
		},
		{
			class = "tacrp_gsr1911",
			ammo = "Pistol",
			count = 8,
		},
		{
			class = "tacrp_p250",
			ammo = "Pistol",
			count = 12,
		},
		{
			class = "tacrp_uzi",
			ammo = "Pistol",
			count = 30,
		},
		{
			class = "tacrp_ex_mac10",
			ammo = "Pistol",
			count = 32,
		},
		{
			class = "tacrp_skorpion",
			ammo = "Pistol",
			count = 30,
		},
		{
			class = "tacrp_sphinx",
			ammo = "Pistol",
			count = 16,
		},
		{
			class = "tacrp_xd45",
			ammo = "Pistol",
			count = 20,
		},
		{
			class = "tacrp_mr96",
			ammo = "357",
			count = 6,
		},
	},
	["Melee"] = {
		{
			class = "mur_combat_knife",
			ammo = "",
			count = 0,
		},
		{
			class = "mur_compact_knife",
			ammo = "",
			count = 0,
		},
		{
			class = "mur_crowbar",
			ammo = "",
			count = 0,
		},
		{
			class = "mur_survival_axe",
			ammo = "",
			count = 0,
		},
		{
			class = "mur_hatchet",
			ammo = "",
			count = 0,
		},
		{
			class = "mur_ice_pick",
			ammo = "",
			count = 0,
		},
		{
			class = "mur_fire_axe",
			ammo = "",
			count = 0,
		},
		{
			class = "mur_machete",
			ammo = "",
			count = 0,
		},
		{
			class = "mur_shovel",
			ammo = "",
			count = 0,
		},
		{
			class = "mur_golf_club",
			ammo = "",
			count = 0,
		},
		{
			class = "mur_bat",
			ammo = "",
			count = 0,
		},
	},
}

MuR.WeaponTable = WeaponsTable

function MuR.RandomBodyGroup(ply)
    -- Get number of bodygroups
    local numBodygroups = ply:GetNumBodyGroups()
    
    -- Randomize each bodygroup
    for i = 0, numBodygroups - 1 do
        local numValues = ply:GetBodygroupCount(i)
        if numValues > 0 then
            ply:SetBodygroup(i, math.random(0, numValues - 1))
        end
    end
end

function meta:GiveWeapon(class, cantdrop)
	timer.Simple(0.01, function()
		local ent = ents.Create(class)
		if not IsValid(ent) or not IsValid(self) then return end
		ent:SetPos(self:GetPos())
		ent.GiveToPlayer = self
		ent.CantDrop = cantdrop

		if ent.ArcticTacRP then
			ent.Primary.DefaultClip = 0
		end

		ent:Spawn()

		if ent.ClipSize then
			ent:SetClip1(ent.ClipSize)
			ent:SetClip2(0)
		end

		if IsValid(ent) then
			self:PickupWeapon(ent)
			ent.GiveToPlayer = nil
		end
	end)
end

function meta:RandomSkin()
	local skinCount = self:SkinCount()
	local randomSkin = math.random(0, skinCount - 1)
	self:SetSkin(randomSkin)

	for i = 0, self:GetNumBodyGroups() - 1 do
		local bodyGroupCount = self:GetBodygroupCount(i)
		local randomBodyGroup = math.random(0, bodyGroupCount - 1)
		self:SetBodygroup(i, randomBodyGroup)
	end
end

function meta:AddMoney(num)
	self:SetNWFloat("Money", self:GetNWFloat("Money") + num)
end

function meta:ChangeGuilt(mult)
	local old_guilt = self:GetNWFloat("Guilt", 0)
	local guilt = old_guilt + (10 * mult)

	self:SetNWFloat("Guilt", math.Clamp(guilt, 0, 100))
	self:SetPData("bloodshed_guilt", guilt)

	-- if guilt == 100 then
	-- 	self:SetNWFloat("Guilt", 0)
	-- 	self:Ban(30, true)
	-- end

	hook.Run("OnPlayerGuiltChanged", self, guilt, old_guilt)
end

hook.Add("PlayerInitialSpawn", "MuR.Connect", function(ply)
	timer.Simple(1, function()
		if not IsValid(ply) then return end

		ply:SetNWFloat("Guilt", tonumber(ply:GetPData("bloodshed_guilt")))
	end)
end)

function meta:ChangeHunger(num, ent)
	self:SetNWFloat("Hunger", math.Clamp(self:GetNWFloat("Hunger") + num, 0, 100))
	self:SetNWFloat("Stamina", math.Clamp(self:GetNWFloat("Stamina") + num / 2, 0, 100))
end

function meta:IsAtBack(enemy)
	if not IsValid(enemy) then return end
	local enemyForward = enemy:GetForward()
	local enemyToPlayer = self:GetPos() - enemy:GetPos()
	local angle = enemyForward:Angle():Forward():Dot(enemyToPlayer:GetNormalized())
	local degrees = math.deg(math.acos(angle))

	return degrees > 100
end

function meta:ViewPunch(angle)
	net.Start("MuR.ViewPunch")
	net.WriteAngle(angle)
	net.Send(self)
end

function meta:MakeRandomSound()
	if (self.RandomPlayerSound or 0) > CurTime() then return end
	self.RandomPlayerSound = CurTime() + math.random(60, 300)
	local rnd, snd = math.random(1, 15), ""

	if rnd == 1 then
		snd = "murdered/player/fart.wav"
		self:ViewPunch(Angle(2, 0, 0))
	elseif rnd < 8 then
		if self.Male then
			snd = "murdered/player/cough_m.wav"
		else
			snd = "murdered/player/cough_f.wav"
		end

		for i = 1, 2 do
			timer.Simple(i / 2 - 0.5, function()
				if not IsValid(self) then return end
				self:ViewPunch(Angle(4, 0, 0))
			end)
		end
	else
		if self.Male then
			snd = "murdered/player/sneeze_m.wav"
		else
			snd = "murdered/player/sneeze_f.wav"
		end

		timer.Simple(1, function()
			if not IsValid(self) then return end
			self:ViewPunch(Angle(8, 0, 0))
		end)
	end

	self:EmitSound(snd, 60, math.random(80, 120))
end

function meta:DamagePlayerSystem(type, heal)
	if heal then
		if type == "bone" then
			self:SetNWBool("LegBroken", false)
		elseif type == "blood" then
			self:SetNWFloat("BleedLevel", math.max(self:GetNWFloat("BleedLevel") - 1, 0))
		elseif type == "hard_blood" then
			self:SetNWBool("HardBleed", false)
		end
	else
		if type == "bone" and not self:GetNWBool("LegBroken") then
			self:SetNWBool("LegBroken", true)
			self:EmitSound("murdered/player/legbreak.wav", 60, math.random(80, 120))
		elseif type == "blood" then
			self:SetNWFloat("BleedLevel", math.min(self:GetNWFloat("BleedLevel") + 1, 3))
		elseif type == "hard_blood" then
			self:SetNWBool("HardBleed", true)
		end
	end
end

function MuR:SendDataToClient(string, value, delay)
	if delay then
		timer.Simple(delay, function()
			net.Start("MuR.SendDataToClient")
			net.WriteString(string)

			net.WriteTable({value})

			net.Broadcast()
		end)
	else
		net.Start("MuR.SendDataToClient")
		net.WriteString(string)

		net.WriteTable({value})

		net.Broadcast()
	end
end

function MuR:ShowFinalScreen(type, allowvote)
	for _, ply in ipairs(MuR:GetAlivePlayers()) do
		if type == "traitor" and ply:IsKiller() then
			ply:AddMoney(250)
		end

		if type == "innocent" and not ply:IsKiller() then
			ply:AddMoney(100) 
		end
	end

	net.Start("MuR.FinalScreen")
	net.WriteString(type)
	net.WriteBool(allowvote)
	net.Broadcast()
end

function MuR:PlaySoundOnClient(string, ply)
	net.Start("MuR.PlaySoundOnClient")
	net.WriteString(string)

	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

function MuR:GiveAnnounce(type, ply)
	net.Start("MuR.Announce")
	net.WriteString(type)

	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

function MuR:GiveMessage(type, ply)
	net.Start("MuR.Message")
	net.WriteString(type)

	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

function MuR:GiveMessage2(type, ply)
	net.Start("MuR.Message2")
	net.WriteString(type)

	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

function MuR:GiveCountdown(time, ply)
	net.Start("MuR.Countdown")
	net.WriteFloat(time)

	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

hook.Add("PlayerInitialSpawn", "MuR.InitSpawn", function(ply)
	ply:SetNWFloat("Guilt", 0)
	ply.SpectateMode = 6
	ply.SpectateIndex = 1
	ply:Spectate(ply.SpectateMode)
	ply.ViewOffsetZ = 64
end)

hook.Add("PlayerSpawn", "MuR.Spawn", function(ply)
	if not ply.ForceSpawn then
		if not MuR.GameStarted or MuR.GameStarted and MuR.TimeCount + 12 < CurTime() then
			ply:KillSilent()

			return
		end
	else
		ply.ForceSpawn = false
	end

	ply:Freeze(false)
	ply:SetAvoidPlayers(true)
	ply:SetCustomCollisionCheck(true)
	ply:SetSVAnimation("")
	ply:StripWeapons()
	ply:StripAmmo()
	ply:SetSlowWalkSpeed(60)
	ply:SetWalkSpeed(100)
	ply:SetRunSpeed(280)
	ply:SetNWFloat("Stability", 100) 
	ply:SetNWFloat("ArrestState", 0)
	ply:SetNWFloat("Stamina", 100)
	ply:SetNWFloat("BleedLevel", 0)
	ply:SetNWBool("LegBroken", false)
	ply:SetNWBool("HardBleed", false)
	ply:SetNWBool("GeroinUsed", false)
	ply:SetNWFloat("DeathStatus", 0)
	ply:SetBloodColor(BLOOD_COLOR_RED)
	ply:SetEyeAngles(Angle(ply:EyeAngles().x, ply:EyeAngles().y, 0))
	ply:SetPlayerColor(ColorRand():ToVector())
	ply:SetViewOffsetDucked(Vector(0, 0, 37))
	ply.DamageTargetGuilt = 0
	ply.VoiceDelay = 0
	ply.TakeDamageTime = 0
	ply.UnInnocentTime = 0
	ply.HungerDelay = CurTime() + 15
	local pos = nil

	if math.random(1, 5) == 1 then
		pos = MuR:GetRandomPos(false, nil, nil, nil, true)

		if not isvector(pos) then
			pos = MuR:GetRandomPos(true, nil, nil, nil, true)
		end
	else
		pos = MuR:GetRandomPos(true, nil, nil, nil, true)

		if not isvector(pos) then
			pos = MuR:GetRandomPos(false, nil, nil, nil, true)
		end
	end

	if isvector(pos) then
		ply:SetPos(pos)
	end

	local class = ply:GetNWString("Class", "")

	if class == "" then
		ply:SetNWString("Class", "Innocent")
		class = ply:GetNWString("Class", "")
	end

	if math.random(1, 2) == 1 then
		ply:SetModel(table.Random(MuR.PlayerModels["Civilian_Female"]))
		-- ply:SetNWString("Name", table.Random(MuR.FemaleNames))
		MuR.RandomBodyGroup(ply)
		ply.Male = false
	else
		ply:SetModel(table.Random(MuR.PlayerModels["Civilian_Male"]))
		-- ply:SetNWString("Name", table.Random(MuR.MaleNames))
		MuR.RandomBodyGroup(ply)
		ply.Male = true
	end	

	ply:AllowFlashlight(false)
	--ply:GiveWeapon("mur_hands", true)
	ply:GiveWeapon("mur_hands", true)
	ply:SetTeam(2)
	ply:SetNWFloat("Hunger", 90)
	ply:SetNWBool("Poison", false)
	ply:SetHealth(100)
	ply:SetMaxHealth(100)
	ply.RandomPlayerSound = CurTime() + math.random(30, 180)
	ply.BleedTime = 0
	ply.SpectateMode = 6
	ply.SpectateIndex = 1

	if class == "Killer" then
		local sec = table.Random(WeaponsTableT["Secondary"])
		ply:GiveWeapon(sec.class)
		ply:GiveAmmo(sec.count * 0, sec.ammo, true)
		ply:GiveAmmo(1, "Pistol", true)
		ply:GiveWeapon("mur_combat_knife", true)
		ply:GiveWeapon("mur_poisoncanister", true)
		ply:GiveWeapon("mur_cyanide", true)
		ply:GiveWeapon("mur_disguise", true)
		ply:GiveWeapon("mur_scanner", true)
		ply:GiveWeapon("mur_break_tool", true)

		if math.random(1, 2) == 1 then
			ply:GiveWeapon("mur_loot_heroin")
		else
			ply:GiveWeapon("mur_loot_adrenaline")
		end

		ply:AllowFlashlight(true)
		ply:SetTeam(1)

		ply:SetHealth(150)
		ply:SetMaxHealth(150)
	elseif class == "Attacker" then
		ply:SetModel(table.Random(MuR.PlayerModels["Anarchist"]))
		-- ply:SetNWString("Name", table.Random(MuR.MaleNames))
		ply.Male = true
		ply:GiveWeapon(table.Random(WeaponsTable["Melee"]).class)
		ply:GiveWeapon("mur_molotov")
		ply:AllowFlashlight(true)
		ply:SetTeam(1)
		ply:SetNWFloat("ArrestState", 1)
	elseif class == "Traitor" then
		if MuR.Gamemode ~= 7 then
			ply:GiveWeapon("tacrp_ex_m1911")
			ply:GiveAmmo(18, "Pistol", true)
		else
			ply:GiveWeapon("tacrp_mr96")
			ply:GiveAmmo(12, "357", true)
		end

		if math.random(1, 2) == 1 then
			ply:GiveWeapon("mur_loot_heroin")
		else
			ply:GiveWeapon("mur_loot_adrenaline")
		end

		if math.random(1, 2) == 1 then
			ply:GiveWeapon("mur_f1")
		else
			ply:GiveWeapon("mur_m67")
		end

		ply:GiveWeapon("mur_poisoncanister", true)
		ply:GiveWeapon("mur_cyanide", true)
		ply:GiveWeapon("mur_disguise", true)
		ply:GiveWeapon("mur_scanner", true)
		ply:GiveWeapon("mur_ied", true)
		ply:GiveWeapon("mur_break_tool", true)
		ply:AllowFlashlight(true)
		ply:GiveWeapon("mur_combat_knife", true)
		ply:SetTeam(1)
	elseif class == "FBI" then
		ply:GiveWeapon("tacrp_ex_glock")
		ply:GiveWeapon("mur_handcuffs", true)
		ply:GiveWeapon("mur_loot_bandage")
		ply:GiveWeapon("mur_disguise", true)
		ply:AllowFlashlight(true)
		ply:GiveAmmo(45, "Pistol", true)
		ply:SetArmor(10)
		ply:SetTeam(3)
	elseif class == "Officer" then
		ply:GiveWeapon("tacrp_ex_glock")
		ply:GiveWeapon("mur_taser", true)
		ply:GiveWeapon("mur_pepperspray", true)
		ply:GiveWeapon("mur_handcuffs", true)
		ply:GiveWeapon("mur_baterringram", true)
		ply:AllowFlashlight(true)
		ply:GiveAmmo(45, "Pistol", true)
		ply:GiveWeapon("mur_baton")
		ply:GiveWeapon("mur_loot_bandage")
		ply:SetArmor(20)
		ply:SetModel(table.Random(MuR.PlayerModels["Police"]))
		-- ply:SetNWString("Name", table.Random(MuR.MaleNames))
		ply:GiveAmmo(3, "GaussEnergy", true)
		ply.Male = true
		ply:SetTeam(3)
	elseif class == "ArmoredOfficer" then

		if MuR.SpawnPositions and istable(MuR.SpawnPositions["Team02"]) then
			ply:SetPos(table.Random(MuR.SpawnPositions["Team02"]))
		else
		end

		ply:GiveWeapon("tacrp_riot_shield")
		ply:GiveWeapon("tacrp_mp5")
		ply:GiveWeapon("tacrp_ex_glock")
		ply:GiveWeapon("mur_taser", true)
		ply:GiveWeapon("mur_handcuffs", true)
		ply:GiveWeapon("mur_baterringram", true)
		ply:AllowFlashlight(true)
		ply:GiveAmmo(30, "Pistol", true)
		ply:GiveAmmo(90, "SMG1", true)
		ply:GiveWeapon("mur_baton")
		ply:GiveWeapon("mur_loot_bandage")
		ply:SetArmor(50)
		ply:SetModel(table.Random(MuR.PlayerModels["SWAT"]))
		-- ply:SetNWString("Name", table.Random(MuR.MaleNames))
		ply:GiveAmmo(2, "GaussEnergy", true)
		ply.Male = true
		ply:SetTeam(3)
	elseif class == "Riot" then

		if MuR.SpawnPositions and istable(MuR.SpawnPositions["Team01"]) then
			ply:SetPos(table.Random(MuR.SpawnPositions["Team01"]))
		else
		end

		ply:GiveWeapon("mur_taser", true)
		ply:GiveWeapon("mur_handcuffs", true)
		ply:GiveWeapon("mur_pepperspray", true)
		ply:GiveWeapon("mur_baterringram", true)
		ply:AllowFlashlight(true)
		ply:GiveWeapon("mur_baton")
		ply:SetArmor(10)
		ply:SetModel(table.Random(MuR.PlayerModels["Riot"]))
		-- ply:SetNWString("Name", table.Random(MuR.MaleNames))
		ply:GiveAmmo(5, "GaussEnergy", true)
		ply.Male = true

	elseif class == "Maniac" then
		ply:SetModel(table.Random(MuR.PlayerModels["Maniac"]))
		ply:GiveWeapon("mur_maniac_axe", true)
		ply:GiveWeapon("mur_loot_adrenaline", true)
		ply:GiveWeapon("mur_scanner", true)
		ply:AllowFlashlight(true)
		ply:SetTeam(1)
		ply:SetWalkSpeed(140)
		ply:SetRunSpeed(340)
		ply:SetNWFloat("ArrestState", 1)
	elseif class == "Shooter" then
		ply:SetArmor(100)
		ply:AllowFlashlight(true)
		ply:SetModel(table.Random(MuR.PlayerModels["Shooter"]))
		local pri, sec, mel = table.Random(WeaponsTable["Primary"]), table.Random(WeaponsTable["Secondary"]), table.Random(WeaponsTable["Melee"])
		ply:GiveWeapon(pri.class)
		ply:GiveAmmo(pri.count * 4, pri.ammo, true)
		ply:GiveWeapon(sec.class)
		ply:GiveAmmo(sec.count * 2, sec.ammo, true)
		ply:GiveWeapon(mel.class)
		ply:SetWalkSpeed(80)
		ply:SetRunSpeed(240)
		ply:SetTeam(1)
		ply:SetNWFloat("ArrestState", 1)
		ply:GiveWeapon("mur_scanner", true)
		ply:GiveWeapon("mur_loot_adrenaline")
	elseif class == "Terrorist" then
		ply:SetArmor(100)
		ply:AllowFlashlight(true)
		ply:SetModel(table.Random(MuR.PlayerModels["Terrorist"]))
		local per, mel = table.Random(WeaponsTable["Primary"]), table.Random(WeaponsTable["Melee"])
		ply:GiveWeapon("tacrp_m320", true)
		ply:GiveWeapon("mur_ied", true)
		ply:GiveWeapon("mur_m67")
		ply:GiveWeapon("mur_f1")
		ply:GiveAmmo(2, "RPG_Round", true)
		ply:GiveWeapon("tacrp_mtx_dual")
		ply:GiveAmmo(2, "ammo_pistol_large", true)
		ply:GiveWeapon(per.class)
		ply:GiveAmmo(per.count * 3, per.ammo, true)
		ply:GiveWeapon(mel.class)
		ply:GiveWeapon("mur_scanner", true)
		ply:GiveWeapon("mur_loot_adrenaline")

		timer.Simple(0.01, function()
			if not IsValid(ply) then return end
			ply:StripWeapon("mur_hands")
		end)

		ply:SetWalkSpeed(80)
		ply:SetRunSpeed(240)
		ply:SetTeam(1)
		ply:SetNWFloat("ArrestState", 2)
	elseif class == "Hunter" then
		local pri = table.Random(WeaponsTable["Primary"])
		ply:GiveWeapon(pri.class)
		ply:GiveAmmo(pri.count * 2, pri.ammo, true)
	elseif class == "Defender" then
		if MuR.Gamemode ~= 7 then
			ply:GiveWeapon("tacrp_p2000")
		else
			ply:GiveWeapon("tacrp_mr96")
		end
	elseif class == "Zombie" then
		timer.Simple(0.01, function()
			if not IsValid(ply) then return end
			ply:StripWeapon("mur_hands")
		end)

		ply:GiveWeapon("mur_zombie", true)
		ply:SetTeam(1)
		ply:SetRunSpeed(280)
		ply:SetWalkSpeed(160)
		ply:SetJumpPower(320)
		ply:SetHealth(120)
		ply:SetMaxHealth(120)
		ply:SetModel(table.Random(MuR.PlayerModels["Zombies"]))
	elseif class == "Medic" then
		if MuR.Gamemode == 7 then
			ply:GiveWeapon("tacrp_mr96")
		end	
		ply:GiveWeapon("mur_loot_medkit")
		ply:GiveWeapon("mur_loot_adrenaline")
		ply:GiveWeapon("mur_loot_bandage")
		ply:GiveWeapon("mur_scalpel")

		if ply.Male then
			ply:SetModel(table.Random(MuR.PlayerModels["Medic_Male"]))
		else
			ply:SetModel(table.Random(MuR.PlayerModels["Medic_Female"]))
		end
	elseif class == "Builder" then
		if MuR.Gamemode == 7 then
			ply:GiveWeapon("tacrp_mr96")
		end	
		ply:GiveWeapon("mur_loot_hammer")
		ply:GiveWeapon("mur_loot_ducttape")
		ply:GiveWeapon("mur_crowbar")
		ply:SetModel(table.Random(MuR.PlayerModels["Builder"]))
		-- ply:SetNWString("Name", table.Random(MuR.MaleNames))
		ply.Male = true
	elseif class == "Soldier" then
		local pri, sec, mel = table.Random(WeaponsTable["Primary"]), table.Random(WeaponsTable["Secondary"]), table.Random(WeaponsTable["Melee"])
		ply:GiveWeapon(pri.class)
		ply:GiveAmmo(pri.count * 6, pri.ammo, true)
		ply:GiveWeapon(sec.class)
		ply:GiveAmmo(sec.count * 4, sec.ammo, true)
		ply:GiveWeapon(mel.class)
		ply:AllowFlashlight(true)
		ply:GiveWeapon("mur_scanner", true)

		if math.random(1, 2) == 1 then
			ply:GiveWeapon("mur_f1")
		else
			ply:GiveWeapon("mur_m67")
		end

		ply:GiveWeapon("mur_loot_bandage")
	elseif class == "SWAT" then
		local pri, sec = table.Random(WeaponsTableCT["Primary"]), table.Random(WeaponsTableCT["Secondary"])

		if MuR.SpawnPositions and istable(MuR.SpawnPositions["Team02"]) then
			ply:SetPos(table.Random(MuR.SpawnPositions["Team02"]))
		end

		ply:SetModel(table.Random(MuR.PlayerModels["Police_TDM"]))
		ply:GiveWeapon(pri.class)
		ply:GiveAmmo(pri.count * 6, pri.ammo, true)
		ply:GiveWeapon(sec.class)
		ply:GiveAmmo(sec.count * 4, sec.ammo, true)
		ply:GiveWeapon("mur_handcuffs", true)
		ply:GiveWeapon("mur_baton")
		ply:AllowFlashlight(true)

		if math.random(1, 2) == 1 then
			ply:GiveWeapon("mur_f1")
		else
			ply:GiveWeapon("mur_m67")
		end

		ply:GiveWeapon("mur_loot_bandage")
		ply:SetTeam(2)
		-- ply:SetNWString("Name", table.Random(MuR.MaleNames))
		ply.Male = true
	elseif class == "Terrorist2" then
		local pri, sec, mel = table.Random(WeaponsTableT["Primary"]), table.Random(WeaponsTableT["Secondary"]), table.Random(WeaponsTable["Melee"])

		if MuR.SpawnPositions and istable(MuR.SpawnPositions["Team01"]) then
			ply:SetPos(table.Random(MuR.SpawnPositions["Team01"]))
		end

		ply:SetModel(table.Random(MuR.PlayerModels["Terrorist_TDM"]))
		ply:GiveWeapon(pri.class)
		ply:GiveAmmo(pri.count * 6, pri.ammo, true)
		ply:GiveWeapon(sec.class)
		ply:GiveAmmo(sec.count * 4, sec.ammo, true)
		ply:GiveWeapon(mel.class)
		ply:AllowFlashlight(true)

		if math.random(1, 2) == 1 then
			ply:GiveWeapon("mur_f1")
		else
			ply:GiveWeapon("mur_m67")
		end

		ply:GiveWeapon("mur_loot_bandage")
		ply:SetTeam(1)
		-- ply:SetNWString("Name", table.Random(MuR.MaleNames))
		ply.Male = true

	elseif class == "K_Faction" then
		local ranged, close, long = table.Random(WeaponsTableAoCK["Ranged"]), table.Random(WeaponsTableAoCK["Close"]), table.Random(WeaponsTableAoCK["Long"])
		local PModel = { "models/player/aoc_e_archer.mdl", "models/player/aoc_e_footman.mdl", "models/player/aoc_e_knight.mdl" }
		local DModel = PModel[math.random(1, #PModel)]

		if MuR.SpawnPositions and istable(MuR.SpawnPositions["Team01"]) then
			ply:SetPos(table.Random(MuR.SpawnPositions["Team01"]))
		end


		if string.match(DModel, "models/player/aoc_e_archer.mdl") then
			ply:SetModel(DModel)
			ply:GiveWeapon(ranged.class)
		elseif string.match(DModel, "models/player/aoc_e_footman.mdl") then
			ply:SetModel(DModel)
			ply:GiveWeapon(close.class)
		else
			ply:SetModel("models/player/aoc_e_knight.mdl")
			ply:GiveWeapon(long.class)
		end

		ply:SetTeam(1)
		if math.random(1, 2) == 1 then
			ply:GiveWeapon("aoc_oilpot")
		else
			ply:GiveWeapon("aoc_smokepot")
		end

	elseif class == "M_Faction" then
		local ranged, close, long = table.Random(WeaponsTableAoCM["Ranged"]), table.Random(WeaponsTableAoCM["Close"]), table.Random(WeaponsTableAoCM["Long"])
		local PModel = {"models/player/aoc_g_archer.mdl", "models/player/aoc_g_footman.mdl", "models/player/aoc_g_knight.mdl"}
		local DModel = PModel[math.random(1, #PModel)]

		if MuR.SpawnPositions and istable(MuR.SpawnPositions["Team02"]) then
			ply:SetPos(table.Random(MuR.SpawnPositions["Team02"]))
		end

		if string.match(DModel, "models/player/aoc_g_archer.mdl") then
			ply:SetModel(DModel)
			ply:GiveWeapon(ranged.class)
		elseif string.match(DModel, "models/player/aoc_g_footman.mdl") then
			ply:SetModel(DModel)
			ply:GiveWeapon(close.class)
		else
			ply:SetModel("models/player/aoc_g_knight.mdl")
			ply:GiveWeapon(long.class)
		end

		--ply:GiveWeapon(pri.class)
		ply:SetTeam(2)
		if math.random(1, 2) == 1 then
			ply:GiveWeapon("aoc_oilpot")
		else
			ply:GiveWeapon("aoc_smokepot")
		end

	elseif class == "War_RUS" then
		local pri, sec, mel = WeaponsTable["Primary"][1], WeaponsTable["Secondary"][2], WeaponsTable["Melee"][1]
		ply:SetModel(table.Random(MuR.PlayerModels["War_RUS"]))

		if MuR.SpawnPositions and istable(MuR.SpawnPositions["War_RUS"]) then
			ply:SetPos(table.Random(MuR.SpawnPositions["War_RUS"]))
		end

		ply:GiveWeapon(pri.class)
		ply:GiveAmmo(pri.count * 8, pri.ammo, true)
		ply:GiveWeapon(sec.class)
		ply:GiveAmmo(sec.count * 4, sec.ammo, true)
		ply:GiveWeapon(mel.class)
		ply:AllowFlashlight(true)
		ply:GiveWeapon("mur_f1")
		ply:GiveWeapon("mur_loot_bandage")
		ply:SetTeam(1)
		-- ply:SetNWString("Name", table.Random(MuR.MaleNames))
		ply.Male = true

	elseif class == "War_UKR" then
		local pri, sec, mel = WeaponsTable["Primary"][1], WeaponsTable["Secondary"][2], WeaponsTable["Melee"][1]
		ply:SetModel(table.Random(MuR.PlayerModels["War_UKR"]))

		if MuR.SpawnPositions and istable(MuR.SpawnPositions["War_UKR"]) then
			ply:SetPos(table.Random(MuR.SpawnPositions["War_UKR"]))
		end

		ply:GiveWeapon(pri.class)
		ply:GiveAmmo(pri.count * 8, pri.ammo, true)
		ply:GiveWeapon(sec.class)
		ply:GiveAmmo(sec.count * 4, sec.ammo, true)
		ply:GiveWeapon(mel.class)
		ply:AllowFlashlight(true)
		ply:GiveWeapon("mur_m67")
		ply:GiveWeapon("mur_loot_bandage")
		ply:SetTeam(2)
		-- ply:SetNWString("Name", table.Random(MuR.MaleNames))
		ply.Male = true

	end

	ply:SetNWString("Name", ply:Nick())
	ply:SetupHands()
	ply:RandomSkin()
end)

function GM:PlayerDeathSound(ply)
	return true
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
	local dm = dmginfo:GetDamage()

	if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage(2)
	elseif hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH then
		dmginfo:ScaleDamage(1)
	else
		dmginfo:ScaleDamage(0.75)
	end
end

--[[
hook.Add("PlayerSpawn", "MuR_WeaponAttachments", function(ply)
    timer.Simple(0.1, function()
        if SERVER then
            local sec = table.Random(WeaponsTable["Secondary"])
            local class = ply:GetNWString("Class", "")

            if not IsValid(ply) then return end

            for _, wep in pairs(ply:GetWeapons()) do
                if class == "Killer" and wep.ArcCW and sec.class then


                    wep.Attachments[2].Installed = "supp_light"
                    --print("Applied suppressor to: " .. wep:GetClass())


                    wep:NetworkWeapon()
                end
            end
        end
    end)
end)]]




hook.Add("SetupMove", "MuR_Move", function(ply, mv, cmd)
	local hunger = ply:GetNWFloat("Hunger")
	local stam = ply:GetNWFloat("Stamina")

	if not ply:GetNWBool("GeroinUsed") then
		if ply:GetNWString("Class") ~= "Zombie" then
			if ply:IsSprinting() and ply:GetVelocity():Length() > 60 then
				if MuR.War then
					ply:SetNWFloat("Stamina", math.Clamp(stam - FrameTime() / 0.5, 0, 100))
				else
					ply:SetNWFloat("Stamina", math.Clamp(stam - FrameTime() / 0.2, 0, 100))
				end

				ply.RunMult = math.min(ply.RunMult + FrameTime() * 180, ply:GetRunSpeed())
				mv:SetMaxSpeed(ply:GetWalkSpeed() + ply.RunMult)
				mv:SetMaxClientSpeed(ply:GetWalkSpeed() + ply.RunMult)
			elseif ply:GetVelocity():Length() < 60 then
				ply:SetNWFloat("Stamina", math.Clamp(stam + FrameTime() / 0.2, 0, 100))
				ply.RunMult = 0
			else
				ply:SetNWFloat("Stamina", math.Clamp(stam + FrameTime(), 0, 100))
				ply.RunMult = 0
			end

			if stam <= 0 then
				ply.RunMult = 0
			end

			if stam < 10 then
				mv:SetMaxSpeed(ply:GetWalkSpeed() + ply.RunMult / 4)
				mv:SetMaxClientSpeed(ply:GetWalkSpeed() + ply.RunMult / 4)
				ply:SetJumpPower(100)
			elseif stam < 40 then
				mv:SetMaxSpeed(ply:GetWalkSpeed() + ply.RunMult / 2)
				mv:SetMaxClientSpeed(ply:GetWalkSpeed() + ply.RunMult / 2)
				ply:SetJumpPower(130)
			else
				ply:SetJumpPower(160)
			end

			if ply:GetNWBool("LegBroken") then
				ply:SetJumpPower(80)
			end
		end

		if stam <= 0 and (ply:WaterLevel() == 3 or IsValid(ply:GetRD()) and ply:GetRD():WaterLevel() == 3) then
			if ply.TakeDamageTime < CurTime() then
				ply.TakeDamageTime = CurTime() + 1
				ply:TakeDamage(5)
				ply:EmitSound("player/pl_drown" .. math.random(1, 3) .. ".wav", 40)
			end
		elseif stam > 0 and (ply:WaterLevel() == 3 or IsValid(ply:GetRD()) and ply:GetRD():WaterLevel() == 3) then
			ply:SetNWFloat("Stamina", math.Clamp(stam - FrameTime() / 0.1, 0, 100))
		end

		if ply:GetNWString("Class") ~= "Zombie" then
			if hunger < 20 or ply:GetNWBool("LegBroken") then
				mv:SetMaxSpeed(ply:GetWalkSpeed() / 2)
				mv:SetMaxClientSpeed(ply:GetWalkSpeed() / 2)
			elseif ply:GetNWFloat("BleedLevel") >= 3 then
				mv:SetMaxSpeed(ply:GetWalkSpeed() / 1.5)
				mv:SetMaxClientSpeed(ply:GetWalkSpeed() / 1.5)
			elseif hunger < 50 or ply:GetNWFloat("BleedLevel") == 2 --[[ or ply:GetNWFloat("Guilt") >= 40 ]] then
				mv:SetMaxSpeed(ply:GetWalkSpeed())
				mv:SetMaxClientSpeed(ply:GetWalkSpeed())
			end
		end	

		if ply:GetNWFloat("peppereffect") > CurTime() then
			mv:SetMaxClientSpeed(40)
		end
	elseif ply:Alive() then
		local rnd = AngleRand(-1, 1)
		rnd.z = 0
		ply:SetEyeAngles(ply:EyeAngles() + rnd)
	else
	end
end)

hook.Add("OnNPCKilled", "MuR.NPCLogic", function(ent, att)
	local allow = MuR.PoliceState > 0 and ent.IsPolice
	if ent.IsPolice then
		MuR.VoteLogDeadPolice = MuR.VoteLogDeadPolice + 1
	end
	if allow then
		timer.Simple(0.01, MuR.CheckPoliceReinforcment)
	end
end)

function GM:PlayerDeath(ply, inf, att)
	ply:ScreenFade(SCREENFADE.OUT, color_black, 2, 1)
	ply:Freeze(true)
	ply:SetNWBool("Poison", false)
	if isstring(ply.LastVoiceLine) then
		ply:StopSound(ply.LastVoiceLine)
	end

	if att:IsNPC() or (att:GetNWString("Class") == "Officer" or att:GetNWString("Class") == "ArmoredOfficer" or att:GetNWString("Class") == "Riot") then
		ply:SetNWFloat("DeathStatus", 2)
	else
		ply:SetNWFloat("DeathStatus", 1)
	end

	MuR:CheckPoliceReinforcment()

	timer.Simple(0.01, function()
		if !IsValid(ply) then return end
		local att2 = ply.LastAttacker
		if IsValid(att2) and att2:IsPlayer() then
			if ply:Team() == 2 and att2:Team() == 2 and MuR.Gamemode != 5 and MuR.Gamemode != 11 and MuR.Gamemode != 12 and MuR.Gamemode != 13 and ply != att2 then
				if ply.UnInnocentTime < CurTime() then
					att2:ChangeGuilt(4)
					MuR:GiveAnnounce("innocent_kill", att2)
				else
					MuR:GiveAnnounce("innocent_att_kill", att2)
				end
			end
			if att2:IsKiller() and not ply:IsKiller() then
				att2:SetNWFloat("Stability", math.Clamp(att2:GetNWFloat("Stability") + 50, 0, 100))
			end
			ply.LastAttacker = nil
		end
	end)

	if att:IsPlayer() and ply:IsKiller() and not att:IsKiller() then
		att:AddMoney(50)
	end

	if att:IsPlayer() and ply:GetNWFloat("ArrestState") ~= 2 and (att:GetNWString("Class") == "Officer" or att:GetNWString("Class") == "Riot") and ply ~= att then
		att:ChangeGuilt(3)
		MuR:GiveAnnounce("officer_killer", att)
	end

	if MuR.Gamemode == 6 and ply:GetNWString("Class") ~= "Zombie" then
		MuR:GiveAnnounce("you_zombie", ply)
		ply:SetNWString("Class", "Zombie")
	end

	if att:IsPlayer() and MuR.War then
		att:AddMoney(50)
	end

	timer.Simple(3, function()
		if not IsValid(ply) then return end
		ply:SetNWEntity("RD_EntCam", ply)
		ply:Freeze(false)
		ply:ScreenFade(SCREENFADE.IN, color_black, 1, 0)

		if ply:GetNWString("Class") == "Zombie" or ply:GetNWString("Class") == "War_RUS" or ply:GetNWString("Class") == "War_UKR" then
			ply.ForceSpawn = true
			ply:Spawn()
		end
	end)
end

function GM:PlayerDeathThink(ply)
	if ply.SpectateMode then
		ply:Spectate(ply.SpectateMode)
		local ent = MuR:GetAlivePlayers()[ply.SpectateIndex]

		if IsValid(ent) and ent:Health() > 0 and (ply:GetObserverMode() == 5 or ply:GetObserverMode() == 4) then
			ply:SpectateEntity(ent)
		else
			ply:SpectateEntity(NULL)
		end
	end

	if ply:EyeAngles().z != 0 then
		local ang = ply:EyeAngles()
		ang.z = 0
		ply:SetEyeAngles(ang)
	end

	if ply:GetNWString("Class") == "Zombie" then return true end
	if MuR.GameStarted then return false end
end

function GM:PlayerSay(ply, text, team)
	if MuR.GameStarted and MuR.TimeCount + 12 < CurTime() and ply:Alive() then
		for k, ply2 in pairs(player.GetAll()) do
			local can = hook.Call("PlayerCanSeePlayersChat", GAMEMODE, text, team, ply2, ply)

			if can then
				net.Start("MuR.ChatAdd")
				net.WriteEntity(ply)
				net.WriteString(text)
				net.Send(ply2)
			end
		end

		return false
	end

	return true
end

function meta:NextSpectateEntity()
	self.SpectateIndex = self.SpectateIndex + 1

	if not IsValid(MuR:GetAlivePlayers()[self.SpectateIndex]) then
		self.SpectateIndex = 1
	end
end

hook.Add("PlayerButtonDown", "MuR_SButtons", function(ply, but)
	if ply:GetObserverMode() > 0 then
		if (ply:GetObserverMode() == 5 or ply:GetObserverMode() == 4) and but == KEY_SPACE then
			ply:UnSpectate()
			ply.SpectateMode = 6
		elseif ply:GetObserverMode() == 6 and but == KEY_SPACE then
			ply.SpectateMode = 5
		end

		if but == MOUSE_LEFT then
			ply:NextSpectateEntity(true)
		elseif but == MOUSE_RIGHT then
			if ply:GetObserverMode() == 5 then
				ply.SpectateMode = 4
			elseif ply:GetObserverMode() == 4 then
				ply.SpectateMode = 5
			end
		end
	end

	if ply:Alive() and but == KEY_E and (not ply:GetNoDraw() or IsValid(ply:GetRD())) then
		local tr = ply:GetEyeTrace().Entity

		if IsValid(ply:GetRD()) and tr == ply:GetRD() then return end
		if IsValid(tr) and tr:GetClass() == "prop_ragdoll" and tr.isRDRag and tr:GetPos():DistToSqr(ply:GetPos()) < 10000 then
			if IsValid(tr.Owner) then
				MuR:GiveMessage("corpse_alive", ply)
			else
				if IsValid(tr.OwnerDead) and ply:Team() == 2 then
					tr.OwnerDead:SetNWFloat("DeathStatus", 2)
				end

				MuR:GiveMessage("corpse_dead", ply)

				if istable(tr.Inventory) then
					if IsValid(tr.Weapon) then
						tr.Weapon:Remove()
					end
					for _, wep in ipairs(tr.Inventory) do
						timer.Simple(0.1, function()
							if not IsValid(wep) then return end
							wep:SetNoDraw(false)
							wep:SetNotSolid(false)
							wep:SetPos(tr:GetPos() + Vector(0, 0, 20))
							local phys = wep:GetPhysicsObject()

							if IsValid(phys) then
								phys:EnableMotion(true)
								phys:SetVelocity(-phys:GetVelocity() + VectorRand(-50, 50))
							end
						end)
					end

					tr.Inventory = nil
				end
			end
		end
	end

	if ply:Alive() and (but == MOUSE_LEFT or but == KEY_LCONTROL and IsValid(ply:GetRD())) and ply:IsRolePolice() and math.random(1,25) == 1 then
		ply:PlayVoiceLine("shotfired")
	end

	if ply:Alive() and but == KEY_SPACE and not ply:GetNoDraw() and ply:OnGround() then
		local stam = ply:GetNWFloat("Stamina")
		ply:SetNWFloat("Stamina", math.Clamp(stam - 5, 0, 100))
	end
end)

hook.Add("PlayerCanSeePlayersChat", "MuR.Voice", function(text, team, listener, talker)
	if MuR.GameStarted and MuR.TimeCount + 12 > CurTime() or MuR.Ending then return true end
	if listener:GetPos():DistToSqr(talker:GetPos()) > 250000 and talker:Alive() or not listener:IsLineOfSightClear(talker) and talker:Alive() or not talker:Alive() and listener:Alive() then return false end
end)

-- hook.Add("OnEntityCreated", "MuR_Remover", function(ent)
-- 	if (MuR.Gamemode == 2 or MuR.Gamemode == 3) and (ent.Melee or ent.ArcCW) and not ent.CantDrop then end
-- end)

hook.Add("Think", "MuR_LogicPlayer", function()
	local tab = player.GetAll()

	for i = 1, #tab do
		local ent = tab[i]
		if not ent:Alive() then continue end

		if ent:GetNWFloat("ArrestState") == 0 then
			ent.VJ_NPC_Class = {"CLASS_CIVILIAN"}
		else
			ent.VJ_NPC_Class = {"CLASS_TRAITOR"}
		end

		if ent:HaveStability() and not ent:GetNWBool("GeroinUsed", false) then
			ent:SetNWFloat("Stability", math.Clamp(ent:GetNWFloat("Stability")-FrameTime()/3, 0, 100)) 
			if ent:GetNWFloat("Stability") <= 0 then
				ent:ConCommand("kill")
				if math.random(1,5) == 1 then
					ent:TakeDamage(1)
				end
			end
		end

		if ent:Alive() and ent:GetSVAnim() == "" and !IsValid(ent:GetRD()) then
			local num = 64
			local eyes = ent:LookupAttachment("eyes")
			if eyes > 0 then
				local att = ent:GetAttachment(eyes)
				local dif = math.sqrt(att.Pos:DistToSqr(ent:GetPos()))
				num = math.Clamp(dif, 8, 96)
			end
			ent:SetViewOffset(Vector(0, 0, ent.ViewOffsetZ))
			ent:SetViewOffsetDucked(Vector(0, 0, 36))
			ent.ViewOffsetZ = Lerp(FrameTime()/0.1, ent.ViewOffsetZ, num)
		else
			ent:SetViewOffset(Vector(0, 0, 64))
			ent:SetViewOffsetDucked(Vector(0, 0, 36))
			ent.ViewOffsetZ = 64
		end

		local tr = ent:GetEyeTrace().Entity
		local wep = ent:GetActiveWeapon()

		if IsValid(tr) and (tr.IsPolice or tr:IsRolePolice()) and IsValid(wep) and wep:GetMaxClip1() > 0 then
			ent:SetNWFloat("ArrestState", 2)
		end

		-- if IsValid(wep) and wep:GetMaxClip1() > 0 and ent:GetNWFloat("Guilt") >= 70 and MuR.Gamemode != 5 then
		-- 	ent:DropWeapon(wep)
		-- end

		if MuR:VisibleByNPCs(ent:WorldSpaceCenter()) and (IsValid(wep) and (wep:GetMaxClip1() > 0 or wep.Melee) or ent:GetNWBool("GeroinUsed")) then
			if ent:GetNWFloat("ArrestState") == 0 then
				ent:SetNWFloat("ArrestState", 1)
			end
		end

		if ent:GetNWFloat("ArrestState") > 0 and ent:IsRolePolice() then
			ent:SetNWFloat("ArrestState", 0)
		end

		if ent:GetNWString("Class") == "Zombie" then
			ent:SelectWeapon("mur_zombie")
			ent:SetNoTarget(true)
		else
			ent:SetNoTarget(false)
		end

		if ent:GetNWBool("HardBleed") and ent.BleedTime < CurTime() then
			ent.BleedTime = CurTime() + math.Rand(0.2, 0.4)
			MuR:CreateBloodPool(ent, 0, 1)
			ent:TakeDamage(1)
			ent:EmitSound("murdered/player/drip_" .. math.random(1, 5) .. ".wav", 40, math.random(80, 120))
		end

		local lvl = ent:GetNWFloat("BleedLevel")

		if lvl == 1 and ent.BleedTime < CurTime() then
			ent.BleedTime = CurTime() + math.Rand(1.25, 2)
			MuR:CreateBloodPool(ent, 0, 1)
			ent:TakeDamage(1)
			ent:EmitSound("murdered/player/drip_" .. math.random(1, 5) .. ".wav", 40, math.random(80, 120))
		elseif lvl == 2 and ent.BleedTime < CurTime() then
			ent.BleedTime = CurTime() + math.Rand(0.75, 1.25)
			MuR:CreateBloodPool(ent, 0, 1)
			ent:TakeDamage(1)
			ent:EmitSound("murdered/player/drip_" .. math.random(1, 5) .. ".wav", 40, math.random(80, 120))
		elseif lvl >= 3 and ent.BleedTime < CurTime() then
			ent.BleedTime = CurTime() + math.Rand(0.25, 0.75)
			MuR:CreateBloodPool(ent, 0, 1)
			ent:TakeDamage(1)
			ent:EmitSound("murdered/player/drip_" .. math.random(1, 5) .. ".wav", 40, math.random(80, 120))
		end

		ent:SetNWBool("Surrender", ent:GetNWFloat("ArrestState") == 1 and (MuR:VisibleByNPCs(ent:WorldSpaceCenter()) or MuR.PoliceState == 2 or MuR.PoliceState == 4 or MuR.Gamemode == 11) and ent:Alive() and ent:GetSVAnimation() == "")
		ent:MakeRandomSound()

		if ent:GetNWFloat("peppereffect") > CurTime() and ent.peppertimevoice < CurTime() then
			ent.peppertimevoice = CurTime() + 2
			ent:ViewPunch(AngleRand(-10, 10))

			if ent.Male then
				ent:EmitSound("murdered/player/cough_m.wav", 60, math.random(80, 110))
			else
				ent:EmitSound("murdered/player/cough_f.wav", 60, math.random(80, 110))
			end
		end

		if ent:GetNWBool("Poison") and (not ent.PoisonVoiceTime or ent.PoisonVoiceTime < CurTime()) then
			ent.PoisonVoiceTime = CurTime() + 3
			local dm = DamageInfo()
			dm:SetDamage(10)
			dm:SetDamageType(DMG_NERVEGAS)
			dm:SetAttacker(ent)
			ent:TakeDamageInfo(dm)
			ent:EmitSound("ambient/voices/citizen_beaten" .. math.random(3, 4) .. ".wav", 60, math.random(90, 110))
			ent:ViewPunch(AngleRand(-5, 5))
		end

		if ent.HungerDelay < CurTime() and not MuR:DisablesGamemode() then
			ent.HungerDelay = CurTime() + 15
			ent:SetNWFloat("Hunger", math.Clamp(ent:GetNWFloat("Hunger") - 1, 0, 100))
		end

		local rag = ent:GetRD()
		if !IsValid(rag) then
			rag = ent
		end
		if IsValid(rag) then
			local vel = rag:GetVelocity():Length()
			local height = MuR:CheckHeight(rag, rag:WorldSpaceCenter())
			if not rag:OnGround() and (vel > 1000 or height > 300 and vel > 300) and ent:GetMoveType() ~= MOVETYPE_NOCLIP then
				ent:PlayVoiceLine("death_fly")
				if rag:IsPlayer() then
					rag:StartRagdolling()
					rag:TimeGetUpChange(10, true)
				end
			end
		end
	end
end)

local fallspd = 500
hook.Add("OnPlayerHitGround", "MuR_DamageNPCThink", function(ply, onwater, onfloater, speed)
	if speed >= fallspd then
		local fatal = 1000
		local isfatal = fatal > 0 and speed >= fatal
		local dmg = DamageInfo()
		dmg:SetAttacker(game.GetWorld())
		dmg:SetInflictor(game.GetWorld())
		dmg:SetDamage(isfatal and ply:Health() + ply:Armor() or speed / 25)
		dmg:SetDamageType(DMG_FALL)
		ply:TakeDamageInfo(dmg)
		ply:EmitSound("Player.FallDamage", 75, math.random(90, 110), 0.5)
	end
end)

hook.Add("EntityTakeDamage", "MuR_DamageNPCThink", function(ent, dmg)
	local att = dmg:GetAttacker()

	if att.isRDRag and IsValid(att.Owner) then
		dmg:SetAttacker(att.Owner)
		dmg:ScaleDamage(0.2)
		att = dmg:GetAttacker()
	end

	if ent:IsProp() and table.HasValue(MuR.Crates, ent:GetModel()) and dmg:GetDamage() >= ent:Health() and att:IsPlayer() and --[[ att:GetNWFloat("Guilt") < 10 and ]] not ent.SpawnedLoot then
		MuR:SpawnLoot(ent:WorldSpaceCenter())
		ent.SpawnedLoot = true
	end

	if att:IsPlayer() then
		local wep = dmg:GetInflictor()

		if IsValid(wep) and wep.Melee and wep.MeleeHealth then
			if wep.MeleeHealth and wep.MeleeHealth > 0 then
				wep.MeleeHealth = wep.MeleeHealth - dmg:GetDamage() / 15
			else
				wep:Remove()
				MuR:GiveMessage("weapon_break", att)
				att:EmitSound("physics/metal/metal_box_break" .. math.random(1, 2) .. ".wav", 50, math.random(80, 120))
			end
		end
	end

	if ent:IsPlayer() and ent:Alive() then
		if !att:IsWorld() or att:IsWorld() and dmg:GetDamage() > 1 and (bit.band(dmg:GetDamageType(), DMG_FALL) != DMG_FALL) then
			ent.LastAttacker = att
		end

		local wep = ent:GetActiveWeapon()

		if IsValid(wep) and wep.GetBlocking and wep:GetBlocking() then
			dmg:ScaleDamage(0.5)
		end

		if att:IsNPC() and att.IsPolice and dmg:IsDamageType(DMG_CLUB) and ent:GetNWFloat("ArrestState") == 1 then
			ent:Surrender()
		end

		if dmg:IsFallDamage() then
			ent:DamagePlayerSystem("bone")
		elseif dmg:IsBulletDamage() and dmg:GetDamage() > 5 and math.random(1, 100) <= 80 or dmg:IsExplosionDamage() then
			ent:DamagePlayerSystem("blood")
			ent:StartRagdolling(dmg:GetDamage() / 25, dmg:GetDamage() / 5, dmg)
		end

		if att:IsPlayer() then
			local wep2 = att:GetActiveWeapon()

			if att:IsAtBack(ent) and IsValid(wep2) and wep2.Melee then
				ent:StartRagdolling(math.Round(dmg:GetDamage() / 50), math.Round(dmg:GetDamage() / 2), dmginfo)
			end

			att.DamageTargetGuilt = att.DamageTargetGuilt - 1
			att.UnInnocentTime = CurTime() + 15

			if att.DamageTargetGuilt <= 0 and MuR.Gamemode ~= 5 and MuR.Gamemode ~= 6 and att:Team() == 2 then
				att.DamageTargetGuilt = 3
				att:ChangeGuilt(0.1)
			end

			if IsValid(wep2) and wep2.Melee and wep2.BladeWeapon and math.random(1, 2) == 1 then
				ent:DamagePlayerSystem("blood")
			end
		end
	
		net.Start("MuR.PainImpulse")
		net.WriteFloat(dmg:GetDamage()*1.5)
		net.Send(ent)

		dmg:ScaleDamage(1 - (att:GetNWFloat("Guilt") / 100))

		-- if ent:GetNWFloat("Guilt") >= 90 then
		-- 	dmg:ScaleDamage(100)
		-- end
	end

	if (ent.IsPolice or ent:IsRolePolice()) and att:IsPlayer() then
		att:SetNWFloat("ArrestState", 2)
		if ent:IsPlayer() and math.random(1,4) == 1 then
			ent:PlayVoiceLine("shotfired")
		end
	end

	if ent:IsPlayer() and att:IsPlayer() and MuR:VisibleByNPCs(att:WorldSpaceCenter()) then
		if att:GetNWFloat("ArrestState") == 0 then
			att:SetNWFloat("ArrestState", 1)
		end

		att:SetNWFloat("ArrestState", 2)
	end

	if ent:IsPlayer() and att:IsPlayer() and att:Team() == 1 and dmg:GetDamage() >= ent:Health() and att:GetNWFloat("ArrestState") == 0 then
		att:SetNWFloat("ArrestState", 1)
	end

	if ent:GetNWBool("BreakableThing") and not dmg:IsBulletDamage() then
		local dmg = dmg:GetDamage()
		ent:SetHealth(ent:Health() - dmg)

		if ent:Health() <= 0 then
			if not string.match(ent:GetClass(), "ragdoll") then
				local eff = ents.Create("prop_physics")
				eff:SetModel("models/props_interiors/Furniture_shelf01a.mdl")
				eff:SetPos(ent:WorldSpaceCenter())
				eff:SetAngles(ent:GetAngles())
				eff:Spawn()
				eff:Fire("Break")
			end

			ent:Remove()
		else
			if dmg >= 5 then
				ent:EmitSound("physics/wood/wood_box_impact_hard" .. math.random(1, 6) .. ".wav")
			end
		end
	end

	if dmg:GetDamage() > 1 then
		ent.LastDamageInfo = {dmg:GetDamageType(), dmg:GetDamagePosition(), dmg:IsExplosionDamage(), dmg:GetDamageForce(), dmg:IsBulletDamage(), dmg:IsFallDamage()}
	end
end)

hook.Add("EntityRemoved", "MuR.FixDoors", function(ent)
	if string.match(ent:GetClass(), "_door_") then
		for _, ap in ipairs(ents.FindByClass("func_areaportal")) do
			if ap:GetInternalVariable("target") == ent:GetName() then
				ap:Fire("Open")
				ap:SetSaveValue("target", "")
				break
			end
		end
	end
end)

hook.Add("AllowPlayerPickup", "MuR_WeaponsFuck", function(ply, ent)
	if ent:IsWeapon() then
		ply:PickupWeapon(ent)

		if ent:GetMaxClip1() > 0 then
			ply:EmitSound("items/ammo_pickup.wav", 60)
		else
			ply:EmitSound("Flesh.ImpactSoft", 55)
		end

		ply:SelectWeapon(ent:GetClass())

		if ent.Poison then
			ent.Poison = false
			ply.PoisonVoiceTime = CurTime() + math.random(15, 60)
			ply:SetNWBool("Poison", true)
		end
	end
end)

hook.Add("PlayerCanPickupWeapon", "MuR_WeaponsFuck", function(ply, weapon)
	local ent = weapon.GiveToPlayer

	if IsValid(ent) and ply == ent or weapon.ArcticTacRP or weapon.AOC then
		weapon.GiveToPlayer = nil

		return true
	else
		return false
	end
end)

hook.Add("PlayerUse", "MuR_DoorUse", function(ply, door)
	if door:GetClass() == "prop_door_rotating" or door:GetClass() == "func_door_rotating" then
		if not door.AntiDoorSpam or CurTime() - door.AntiDoorSpam > 0.5 and ply:GetNWString("Class") ~= "Zombie" then
			door.AntiDoorSpam = CurTime()
		else
			return false
		end
	end
end)

hook.Add("AllowPlayerPickup", "MuR_DisableUseProp", function(ply, ent) return false end)

hook.Add("CanPlayerSuicide", "MuR_SuicideAnimation", function(ply)
	local wep = ply:GetActiveWeapon()
	if ply.Suiciding or not IsValid(wep) or wep:GetMaxClip1() <= 0 and not wep.Melee or wep.DisableSuicide then ply:ChatPrint("No way :>") return false end
	ply:Freeze(true)
	ply.Suiciding = true
	ply:SetSVAnimation("mur_suicide", true)

	timer.Simple(0.8, function()
		if not IsValid(ply) then return end

		if IsValid(wep) and wep.ShootSound then
			ply:EmitSound(wep.ShootSound, 70)
		else
			ply:EmitSound("physics/flesh/flesh_bloody_break.wav", 70)
		end

		local ef = EffectData()
		ef:SetOrigin(ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1")))
		ef:SetColor(0)
		util.Effect("BloodImpact", ef)
	end)

	timer.Simple(1.1, function()
		if not IsValid(ply) then return end
		ply.Suiciding = false
		ply:Freeze(false)
		ply:TakeDamage(ply:Health() + ply:Armor())
	end)

	return false
end)

-- hook.Add("OnPlayerGuiltChanged", "Punishments", function(ply, guilt, old)
	-- if not IsValid(ply) then return end

	-- if guilt == 100 then
	-- 	ply:Ban(30, true)
	-- 	ply:SetNWFloat("Guilt", 0)
	-- end
-- end )