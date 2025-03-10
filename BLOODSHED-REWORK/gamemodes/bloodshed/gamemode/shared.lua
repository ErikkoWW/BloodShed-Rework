
--DeriveGamemode("sandbox")


MuR = MuR or {}

MuR.shared("shared/sh_cvars.lua")
MuR.shared("shared/sh_footsteps.lua")
MuR.shared("shared/sh_rd.lua")
MuR.shared("shared/sh_woundfix.lua")
MuR.shared("shared/sh_cami.lua")
MuR.shared("shared/spawnmenu_sh.lua")
MuR.shared("zippy_gore/zippygoremod3.lua")
MuR.shared("zippy_blood/zippy_dynamic_blood_splatter.lua")

MuR.server("lang/sv_init.lua")
MuR.server("server/sv_functions.lua")
MuR.server("server/sv_rounds.lua")
MuR.server("server/sv_rd.lua")
MuR.server("server/sv_npc.lua")
MuR.server("server/sv_nodegraph.lua")
MuR.server("server/sv_commands.lua")
MuR.server("server/sv_util.lua")
MuR.server("server/sv_takedown.lua")
MuR.server("server/sv_shop.lua")
MuR.server("server/sv_damage.lua")
MuR.server("server/sv_deathlist.lua")
MuR.server("server/sv_deathragdoll.lua")
MuR.server("server/sv_voice.lua")

MuR.client("lang/cl_init.lua")
MuR.client("client/cl_hud.lua")
MuR.client("client/cl_rd.lua")
MuR.client("client/cl_chat.lua")
MuR.client("client/cl_util.lua")
MuR.client("client/cl_scoreboard.lua")
MuR.client("client/cl_body.lua")
MuR.client("client/cl_q_menu.lua")
MuR.client("client/cl_shop.lua")
MuR.client("client/cl_pain.lua")
MuR.client("client/cl_deathlist.lua")

MuR.Language = MuR.Language or {}

MuR.PlayerModels = {
	["Civilian_Male"] = {"models/player/zelpa/male_01_extended.mdl", "models/player/zelpa/male_02_extended.mdl", "models/player/zelpa/male_03_extended.mdl", "models/player/zelpa/male_04_extended.mdl", "models/player/zelpa/male_05_extended.mdl", "models/player/zelpa/male_06_extended.mdl", "models/player/zelpa/male_07_extended.mdl", "models/player/zelpa/male_08_extended.mdl", "models/player/zelpa/male_09_extended.mdl", "models/player/zelpa/male_10_extended.mdl", "models/player/zelpa/male_11_extended.mdl",},
	["Civilian_Female"] = {"models/player/zelpa/female_01_extended.mdl", "models/player/zelpa/female_01_b_extended.mdl", "models/player/zelpa/female_02_extended.mdl", "models/player/zelpa/female_02_b_extended.mdl", "models/player/zelpa/female_03_extended.mdl", "models/player/zelpa/female_03_b_extended.mdl", "models/player/zelpa/female_04_extended.mdl", "models/player/zelpa/female_04_b_extended.mdl", "models/player/zelpa/female_06_extended.mdl", "models/player/zelpa/female_06_b_extended.mdl", "models/player/zelpa/female_07_extended.mdl", "models/player/zelpa/female_07_b_extended.mdl", },
	["Medic_Male"] = {"models/kayf/humans/group01/male_01.mdl", "models/kayf/humans/group01/male_02.mdl", "models/kayf/humans/group01/male_03.mdl", "models/kayf/humans/group01/male_04.mdl", "models/kayf/humans/group01/male_05.mdl", "models/kayf/humans/group01/male_06.mdl", "models/kayf/humans/group01/male_07.mdl", "models/kayf/humans/group02/male_01.mdl", "models/kayf/humans/group02/male_02.mdl", "models/kayf/humans/group02/male_03.mdl", "models/kayf/humans/group02/male_04.mdl", "models/kayf/humans/group02/male_05.mdl", "models/kayf/humans/group02/male_06.mdl", "models/kayf/humans/group02/male_07.mdl", "models/kayf/humans/group02/male_08.mdl", "models/kayf/humans/group02/male_09.mdl",},
	["Medic_Female"] = {"models/kayf/humans/group01/male_01.mdl", "models/kayf/humans/group01/male_02.mdl", "models/kayf/humans/group01/female_01.mdl", "models/kayf/humans/group01/female_02.mdl", "models/kayf/humans/group01/female_03.mdl", "models/kayf/humans/group01/female_04.mdl", "models/kayf/humans/group01/female_07.mdl", "models/kayf/humans/group02/female_04.mdl", "models/kayf/humans/group02/female_07.mdl", "models/kayf/humans/group01/female_06.mdl",},
	["Builder"] = {"models/kayf/humans/group01/male_01.mdl", "models/kayf/humans/group01/male_02.mdl", "models/kayf/humans/group01/male_03.mdl", "models/kayf/humans/group01/male_04.mdl", "models/kayf/humans/group01/male_05.mdl", "models/kayf/humans/group01/male_06.mdl", "models/kayf/humans/group01/male_07.mdl", "models/kayf/humans/group02/male_01.mdl", "models/kayf/humans/group02/male_02.mdl", "models/kayf/humans/group02/male_03.mdl", "models/kayf/humans/group02/male_04.mdl", "models/kayf/humans/group02/male_05.mdl", "models/kayf/humans/group02/male_06.mdl", "models/kayf/humans/group02/male_07.mdl", "models/kayf/humans/group02/male_08.mdl", "models/kayf/humans/group02/male_09.mdl",},
	["Maniac"] = {"models/murdered/pm/jason_v.mdl", "models/raincoat.mdl", "models/players/mj_dbd_myers.mdl", "models/player/cla/classic_ghostface.mdl",},
	["Terrorist"] = {"models/player/phoenix.mdl", "models/player/leet.mdl", "models/player/arctic.mdl", "models/player/guerilla.mdl",},
	["Shooter"] = {"models/player/phoenix.mdl", "models/player/leet.mdl", "models/player/arctic.mdl", "models/player/guerilla.mdl",},
	["Anarchist"] = {"models/player/arctic.mdl",},
	["Police"] = {"models/monolithservers/mpd/male_01.mdl", "models/monolithservers/mpd/male_01_2.mdl", "models/monolithservers/mpd/male_02.mdl", "models/monolithservers/mpd/male_02_2.mdl", "models/monolithservers/mpd/male_03.mdl", "models/monolithservers/mpd/male_03_2.mdl", "models/monolithservers/mpd/male_04.mdl", "models/monolithservers/mpd/male_04_2.mdl", "models/monolithservers/mpd/male_05.mdl", "models/monolithservers/mpd/male_05_2.mdl", "models/monolithservers/mpd/male_06.mdl", "models/monolithservers/mpd/male_06_2.mdl", "models/monolithservers/mpd/male_07.mdl", "models/monolithservers/mpd/male_07_2.mdl", "models/monolithservers/mpd/male_08.mdl", "models/monolithservers/mpd/male_08_2.mdl", "models/monolithservers/mpd/male_09.mdl", "models/monolithservers/mpd/male_09_2.mdl", "models/monolithservers/mpd/female_01.mdl", "models/monolithservers/mpd/female_01_2.mdl", "models/monolithservers/mpd/female_02.mdl", "models/monolithservers/mpd/female_02_2.mdl", "models/monolithservers/mpd/female_03.mdl", "models/monolithservers/mpd/female_03_2.mdl", "models/monolithservers/mpd/female_04.mdl", "models/monolithservers/mpd/female_04_2.mdl", "models/monolithservers/mpd/female_05.mdl", "models/monolithservers/mpd/female_05_2.mdl",},
	["SWAT"] = {"models/murdered/pm/swat_ls.mdl",},
	["Riot"] = {"models/player/riot.mdl",},
	["Terrorist_TDM"] = {"models/player/phoenix.mdl", "models/player/leet.mdl", "models/player/arctic.mdl", "models/player/guerilla.mdl",},
	["Police_TDM"] = {"models/player/gasmask.mdl", "models/player/urban.mdl", "models/player/swat.mdl", "models/player/riot.mdl",},
	["Zombies"] = {"models/zombie/zclassic_01pl.mdl", "models/zombie/zclassic_10pl.mdl", "models/zombie/zclassic_11pl.mdl", "models/zombie/zclassic_02pl.mdl", "models/zombie/zclassic_03pl.mdl", "models/zombie/zclassic_04pl.mdl", "models/zombie/zclassic_05pl.mdl", "models/zombie/zclassic_06pl.mdl", "models/zombie/zclassic_07pl.mdl", "models/zombie/zclassic_08pl.mdl", "models/zombie/zclassic_09pl.mdl",},
	["Combine"] = {"models/player/betatrenchcoat_oldplayermodel.mdl", "models/player/betaunit_lead_playermodel.mdl", "models/player/betaunit_sentinel_playermodel.mdl", "models/player/betaunit_shockjock_playermodel.mdl", "models/player/betaunit_lead_playermodel.mdlmodels/player/betaunit_standard_playermodel.mdl",},
	["K_Faction"] = {"models/player/aoc_e_archer.mdl", "models/player/aoc_e_footman.mdl", "models/player/aoc_e_knight.mdl",},
	["M_Faction"] = {"models/player/aoc_g_archer.mdl", "models/player/aoc_g_footman.mdl", "models/player/aoc_g_knight.mdl",},
	["War_RUS"] = {"models/leygun/rfarmy/soilder_rf_02.mdl", "models/leygun/rfarmy/soilder_rf_04.mdl", "models/leygun/rfarmy/soilder_rf_05.mdl", "models/leygun/rfarmy/soilder_rf_07.mdl", "models/leygun/rfarmy/soilder_rf_08.mdl", "models/leygun/rfarmy/soilder_rf_09.mdl",},
	["War_UKR"] = {"models/leygun/ua_army/soilder_ua_02.mdl", "models/leygun/ua_army/soilder_ua_04.mdl", "models/leygun/ua_army/soilder_ua_05.mdl", "models/leygun/ua_army/soilder_ua_06.mdl", "models/leygun/ua_army/soilder_ua_07.mdl", "models/leygun/ua_army/soilder_ua_08.mdl", "models/leygun/ua_army/soilder_ua_09.mdl"}
}

local ftab = {"mur_food_apple", "mur_food_banana", "mur_food_beer1", "mur_food_beer2", "mur_food_burger", "mur_food_chickenwrap", "mur_food_colabig", "mur_food_colasmall", "mur_food_doritos", "mur_food_hotdog", "mur_food_icecream", "mur_food_lays", "mur_food_monster", "mur_food_mtndewcan", "mur_food_pepsican", "mur_food_redbull", "mur_food_sandwich"}

MuR.GamemodeChances = {
	[1] = {chance = 100, need_players = 0},
	[2] = {chance = 40, need_players = 0},
	[3] = {chance = 40, need_players = 0},
	[4] = {chance = 85, need_players = 0},
	[5] = {chance = 25, need_players = 0},
	[6] = {chance = 20, need_players = 3},
	[7] = {chance = 40, need_players = 0},
	[8] = {chance = 40, need_players = 3},
	[9] = {chance = 30, need_players = 0},
	[10] = {chance = 30, need_players = 3},
	[11] = {chance = 30, need_players = 0},
	[12] = {chance = 30, need_players = 0},
	[13] = {chance = 30, need_players = 2}
	--[14] = {chance = 20, need_players = 0},
}

MuR.Shop = {
	["Civilian"] = {
		{
			name = "Food",
			icon = "entities/food.png",
			price = 5,
			func = function(ply)
				ply:GiveWeapon(table.Random(ftab))
			end,
		},
		{
			name = "Flashlight",
			icon = "entities/flashlight.png",
			price = 10,
			func = function(ply)
				ply:AllowFlashlight(true)
			end,
		},
		{
			name = "Bandage",
			icon = "entities/bandage.png",
			price = 25,
			func = function(ply)
				ply:GiveWeapon("mur_loot_bandage")
			end,
		},
		{
			name = "Adrenaline",
			icon = "entities/syringe.png",
			price = 50,
			func = function(ply)
				ply:GiveWeapon("mur_loot_adrenaline")
			end,
		},
		{
			name = "Duct Tape",
			icon = "entities/skotch.png",
			price = 50,
			func = function(ply)
				ply:GiveWeapon("mur_loot_ducttape")
			end,
		},
		{
			name = "First Aid Kit",
			icon = "entities/medkit.png",
			price = 75,
			func = function(ply)
				ply:GiveWeapon("mur_loot_medkit")
			end,
		},
		{
			name = "Hammer",
			icon = "entities/hammer.png",
			price = 100,
			func = function(ply)
				ply:GiveWeapon("mur_loot_hammer")
			end,
		},
		{
			name = "Compact Knife",
			icon = "entities/yurie_eft_bars_a-2607_95x18.png",
			price = 125,
			func = function(ply)
				ply:GiveWeapon("mur_compact_knife")
			end,
		},
		{
			name = "Phone",
			icon = "entities/phone.png",
			price = 150,
			func = function(ply)
				ply:GiveWeapon("mur_loot_phone")
			end,
		},
		{
			name = "Pepper Spray",
			icon = "murdered/blood.png",
			price = 250,
			func = function(ply)
				ply:GiveWeapon("mur_pepperspray")
			end,
		},
	},
	["Killer"] = {
		{
			name = "Ammo",
			icon = "entities/ghost_l115a3_extented_magazine.png",
			price = 25,
			func = function(ply)
				local wep = ply:GetActiveWeapon()

				if IsValid(wep) and wep:GetMaxClip1() > 0 then
					ply:GiveAmmo(wep:GetMaxClip1(), wep:GetPrimaryAmmoType(), true)
				end
			end,
		},
		{
			name = "Cyanide Syringe",
			icon = "entities/syringe.png",
			price = 50,
			func = function(ply)
				ply:GiveWeapon("mur_cyanide")
			end,
		},
		{
			name = "Poison Canister",
			icon = "entities/poison.png",
			price = 50,
			func = function(ply)
				ply:GiveWeapon("mur_poisoncanister")
			end,
		},
		{
			name = "Heroin",
			icon = "entities/syringe.png",
			price = 100,
			func = function(ply)
				ply:GiveWeapon("mur_loot_heroin")
			end,
		},
		{
			name = "F1 Grenade",
			icon = "entities/f1.png",
			price = 150,
			func = function(ply)
				ply:GiveWeapon("mur_f1")
			end,
		},
		{
			name = "M67 Grenade",
			icon = "entities/m67.png",
			price = 150,
			func = function(ply)
				ply:GiveWeapon("mur_m67")
			end,
		},
		{
			name = "Light Weapon",
			icon = "entities/tfa_ins2_pm_alt.png",
			price = 200,
			func = function(ply)
				ply:GiveWeapon(table.Random(MuR.WeaponTable["Secondary"]).class)
			end,
		},
		{
			name = "IED",
			icon = "entities/ied.png",
			price = 250,
			func = function(ply)
				ply:GiveWeapon("mur_ied")
			end,
		},
		{
			name = "Heavy Weapon",
			icon = "entities/mosin.png",
			price = 500,
			func = function(ply)
				ply:GiveWeapon(table.Random(MuR.WeaponTable["Primary"]).class)
			end,
		}
	},
	["Soldier"] = {
		{
			name = "Ammo",
			icon = "entities/ghost_l115a3_extented_magazine.png",
			price = 25,
			func = function(ply)
				local wep = ply:GetActiveWeapon()

				if IsValid(wep) and wep:GetMaxClip1() > 0 then
					ply:GiveAmmo(wep:GetMaxClip1(), wep:GetPrimaryAmmoType(), true)
				end
			end,
		},
		{
			name = "F1 Grenade",
			icon = "entities/f1.png",
			price = 50,
			func = function(ply)
				ply:GiveWeapon("mur_f1")
			end,
		},
		{
			name = "M67 Grenade",
			icon = "entities/m67.png",
			price = 50,
			func = function(ply)
				ply:GiveWeapon("mur_m67")
			end,
		},
		{
			name = "MR96",
			icon = "entities/sw500.png",
			price = 50,
			func = function(ply)
				ply:GiveWeapon("tacrp_mr96")
			end,
		},
		{
			name = "IED",
			icon = "entities/ied.png",
			price = 75,
			func = function(ply)
				ply:GiveWeapon("mur_ied")
			end,
		},
		{
			name = "UZI",
			icon = "entities/tfa_ins2_izh43sw_2.png",
			price = 100,
			func = function(ply)
				ply:GiveWeapon("tacrp_uzi")
			end,
		},
		{
			name = "SPR",
			icon = "entities/mosin.png",
			price = 275,
			func = function(ply)
				ply:GiveWeapon("tacrp_spr")
			end,
		},
		{
			name = "MP7",
			icon = "entities/mp7.png",
			price = 325,
			func = function(ply)
				ply:GiveWeapon("tacrp_mp7")
			end,
		},
		{
			name = "Benelli M4",
			icon = "entities/spas12.png",
			price = 375,
			func = function(ply)
				ply:GiveWeapon("tacrp_m4star10")
			end,
		},
		{
			name = "M14",
			icon = "entities/sks.png",
			price = 400,
			func = function(ply)
				ply:GiveWeapon("tacrp_m14")
			end,
		},
		{
			name = "AS50",
			icon = "entities/sr25.png",
			price = 500,
			func = function(ply)
				ply:GiveWeapon("tacrp_as50")
			end,
		},
		{
			name = "RPG-7",
			icon = "entities/rpg7.png",
			price = 1000,
			func = function(ply)
				ply:GiveWeapon("tacrp_rpg7")
			end,
		}
	}
}

MuR.PoliceClasses = {
	["patrol"] = {
		npcs = {"mur_npc_police"},
		weps = {"mur_npc_glock"},
	},
	["swat"] = {
		npcs = {"mur_npc_swat"},
		weps = {"mur_npc_m4a1"},
	},
	["security"] = {
		npcs = {"mur_npc_police"},
		weps = {"mur_npc_glock"},
		underroof = false,
	},
	["zombie"] = {"zb_zombie"},
	max_npcs = 4,
	delay_spawn = 6,
	security_spawn = 0,

	no_npc_police = false,
	no_player_police = false,
}

MuR.Crates = {"models/props_junk/cardboard_box001a.mdl", "models/props_junk/cardboard_box001b.mdl", "models/props_junk/cardboard_box002a.mdl", "models/props_junk/cardboard_box002b.mdl", "models/props_junk/cardboard_box003a.mdl", "models/props_junk/cardboard_box003b.mdl", "models/props_junk/wood_crate001a.mdl", "models/props_junk/wood_crate001a_damaged.mdl", "models/props_junk/wood_crate001a_damagedmax.mdl", "models/props_junk/wood_crate002a.mdl", "models/props_c17/furnituredrawer001a.mdl", "models/props_c17/furnituredrawer003a.mdl", "models/props_c17/furnituredresser001a.mdl", "models/props_c17/woodbarrel001.mdl", "models/props_lab/dogobject_wood_crate001a_damagedmax.mdl", "models/items/item_item_crate.mdl", "models/props/de_inferno/claypot02.mdl", "models/props/de_inferno/claypot01.mdl", "models/props_c17/FurnitureCupboard001a.mdl"}

MuR.MaxLootNumber = 100

MuR.Loot = {
	---WEAPONS---
	{
		class = "mur_pepperspray",
		chance = 15
	},
	{
		class = "mur_compact_knife",
		chance = 15
	},
	{
		class = "mur_crowbar",
		chance = 15
	},
	{
		class = "mur_golf_club",
		chance = 15
	},
	{
		class = "mur_hatchet",
		chance = 15
	},
	{
		class = "mur_ice_pick",
		chance = 15
	},
	{
		class = "mur_survival_axe",
		chance = 15
	},
	{
		class = "mur_machete",
		chance = 15
	},
	{
		class = "mur_bat",
		chance = 10
	},
	{
		class = "mur_shovel",
		chance = 10
	},
	{
		class = "mur_fire_axe",
		chance = 10
	},
	{
		class = "tacrp_ex_m1911",
		chance = 5
	},
	{
		class = "tacrp_gsr1911",
		chance = 5
	},
	{
		class = "tacrp_ex_usp",
		chance = 4
	},
	{
		class = "tacrp_ex_hk45c",
		chance = 4
	},
	{
		class = "tacrp_p2000",
		chance = 4
	},
	{
		class = "tacrp_vertec",
		chance = 4
	},
	{
		class = "tacrp_p250",
		chance = 4
	},
	{
		class = "tacrp_sphinx",
		chance = 3
	},
	{
		class = "tacrp_mr96",
		chance = 3
	},
	{
		class = "tacrp_xd45",
		chance = 2
	},
	{
		class = "tacrp_ex_mac10",
		chance = 2
	},
	{
		class = "tacrp_uzi",
		chance = 2
	},
	---OTHERS---
	{
		class = "mur_loot_money",
		chance = 50
	},
	{
		class = "mur_loot_ammo",
		chance = 30
	},
	{
		class = "mur_loot_flashlight",
		chance = 25
	},
	{
		class = "mur_loot_bandage",
		chance = 25
	},
	{
		class = "mur_loot_ducttape",
		chance = 20
	},
	{
		class = "mur_loot_adrenaline",
		chance = 10
	},
	{
		class = "mur_loot_heroin",
		chance = 10
	},
	{
		class = "mur_loot_medkit",
		chance = 5
	},
	{
		class = "mur_loot_hammer",
		chance = 5
	},
	{
		class = "mur_loot_phone",
		chance = 5
	}
}

for k, v in ipairs(ftab) do
	table.insert(MuR.Loot, {
		class = v,
		chance = 50
	})
end

MuR.MaleNames =  {"Andrew", "Max", "James", "David", "Daniel", "Michael", "Matthew", "Robert", "John", "William", "Thomas", "Richard", "Mark", "Charles", "Christopher", "Paul", "Steven", "George", "Edward", "Peter", "Anthony", "Simon", "Adam", "Luke", "Benjamin", "Samuel", "Alexander", "Henry", "Joseph", "Ryan", "Liam", "Harry", "Jack", "Oliver", "Noah", "Leo", "Oscar", "Ethan", "Jacob", "Lucas", "Joshua", "Logan", "Mason", "Isaac", "Dylan", "Finley", "Archie", "Theo", "Alfie", "Charlie"}
MuR.FemaleNames = {"Emma", "Olivia", "Sophia", "Isabella", "Ava", "Emily", "Abigail", "Mia", "Chloe", "Ella", "Amelia", "Grace", "Lily", "Hannah", "Zoe", "Anna", "Charlotte", "Lucy", "Evelyn", "Ruby", "Eva", "Alice", "Molly", "Isla", "Lola", "Eleanor", "Harper", "Scarlett", "Layla", "Ellie", "Mila", "Ivy", "Isabelle", "Rosie", "Freya", "Poppy", "Daisy", "Evie", "Sofia", "Willow", "Phoebe", "Esme", "Sienna", "Maya", "Luna", "Holly", "Lily", "Imogen", "Erin", "Bella"}

MuR.WeaponToRagdoll = {
--	[""] = "", --models/weapons/tacint/			

------SNIPER RIFLES-------------
	["tacrp_pa_sako85"] = "sako85", --models/weapons/tacint_extras/w_sako85.mdl
	["tacrp_ak_svd"] = "svd", --models/weapons/tacint_extras/w_svd.mdl
	["tacrp_pa_svu"] = "svu", --models/weapons/tacint_extras/w_svu.mdl
	["tacrp_pa_vykhlop"] = "vykhlop", --models/weapons/tacint/w_vykhlop.mdl
	["tacrp_io_trg42"] = "trg42", --models/weapons/tacint_extras/w_trg42.mdl
	["tacrp_sd_wa2000"] = "wa2000", --models/weapons/tacint_shark/w_wa2000.mdl
	["tacrp_h_intervention"] = "intervention", --models/weapons/tacint_shark/w_intervention.mdl
	["tacrp_pa_awp"] = "awp", --models/weapons/tacint_shark/w_awp.mdl
	["tacrp_as50"] = "as50", --models/weapons/tacint/w_as50.mdl
	["tacrp_ex_hecate"] = "hecate", --models/weapons/tacint_extras/w_hecate.mdl
	["tacrp_uratio"] = "uratio", --models/weapons/tacint/w_uratio.mdl
	["tacrp_spr"] = "spr", --models/weapons/tacint/w_spr.mdl

-------MARKSMAN RIFLES------------
	["tacrp_pa_mosin"] = "mosin", --models/weapons/tacint_extras/w_mosin.mdl
	["tacrp_pa_smle"] = "smle", --models/weapons/tacint_extras/w_smle.mdl
	["tacrp_io_k98"] = "k98", --models/weapons/tacint_extras/w_k98.mdl
	["tacrp_ak_galil_sniper"] = "galil_sniper", --models/weapons/tacint_extras/w_galil_sniper.mdl
	["tacrp_io_vss"] = "vss", --models/weapons/tacint_extras/w_vss.mdl
	["tacrp_io_m14"] = "m14", --models/weapons/tacint_extras/w_m14.mdl
	["tacrp_eo_psg1"] = "psg1", --models/weapons/tacint_shark/w_psg1.mdl
	["tacrp_io_sg550"] = "sg550", --models/weapons/tacint_shark/w_sg550_sniper.mdl
	["tacrp_ar_sr25"] = "sr25", --models/weapons/tacint_extras/w_sr25.mdl
	["tacrp_m14"] = "m14", --models/weapons/tacint/w_m14.mdl		

---------SPORTERS-----------------
	["tacrp_eo_winchester"] = "winchester", --models/weapons/tacint_shark/w_winchester.mdl
	["tacrp_sd_1022"] = "1022", --models/weapons/tacint_shark/w_1022.mdl
	["tacrp_sd_m1carbine"] = "m1carbine", --models/weapons/tacint_shark/w_m1carbine.mdl
	["tacrp_pa_hipoint"] = "hipoint", --models/weapons/tacint/w_hipoint.mdl
	["tacrp_io_k98_varmint"] = "varmint", --models/weapons/tacint_extras/w_k98_varmint.mdl
	["tacrp_sd_vz58"] = "vz58", --models/weapons/tacint_shark/w_vz58.mdl
	["tacrp_eo_izzyfal"] = "izzyfal", --models/weapons/tacint_shark/w_izzyfal.mdl
	["tacrp_io_cx4"] = "cx4", --models/weapons/tacint_shark/w_cx4.mdl
	["tacrp_eo_scout"] = "scout", --models/weapons/tacint_extras/w_scout.mdl
	["tacrp_io_star15"] = "star15", --models/weapons/tacint_extras/w_star15.mdl
	["tacrp_io_usc"] = "usc", --models/weapons/tacint_extras/w_usc.mdl
	["tacrp_io_sl8"] = "sl8", --models/weapons/tacint_extras/w_sl8.mdl
	["tacrp_h_nitrorifle"] = "nitrorifle", --models/weapons/tacint_shark/w_nitrorifle.mdl
	["tacrp_ar_gilboa"] = "gilboa", --models/weapons/tacint_extras/w_gilboa.mdl
	["tacrp_sd_delisle"] = "delisle", --models/weapons/tacint_shark/w_delisle.mdl
	["tacrp_io_sg550r"] = "sg550r", --models/weapons/tacint_shark/w_sg550_rifle.mdl
	["tacrp_eo_acr"] = "acr", --models/weapons/tacint_shark/w_masada.mdl
	["tacrp_civ_p90"] = "p90c", --models/weapons/tacint/w_p90.mdl
	["tacrp_civ_mp5"] = "mp5c", --models/weapons/tacint/w_mp5.mdl
	["tacrp_m1"] = "m1", --models/weapons/tacint/w_m1.mdl

--------SHOTGUNS------------------
	["tacrp_pa_toz106"] = "toz106", --models/weapons/tacint/w_toz106.mdl
	["tacrp_pa_coachgun"] = "coachgun", --models/weapons/tacint_extras/w_coachgun.mdl
	["tacrp_pa_auto5"] = "auto5", --models/weapons/tacint/w_auto5.mdl
	["tacrp_sd_superx3"] = "superx3", --models/weapons/tacint_shark/w_superx3.mdl
	["tacrp_pa_toz34"] = "toz34", --models/weapons/tacint/w_toz34.mdl
	["tacrp_sd_db"] = "db", --models/weapons/tacint_shark/w_dbshotgun.mdl
	["tacrp_pa_shorty"] = "shorty", --models/weapons/tacint/w_shorty.mdl
	["tacrp_pa_ithaca"] = "ithaca", --models/weapons/tacint_shark/w_ithaca.mdl
	["tacrp_io_870"] = "870", --models/weapons/tacint_shark/w_870.mdl
	["tacrp_h_jackhammer"] = "jackhammer", --models/weapons/tacint_shark/w_jackhammer.mdl
	["tacrp_eo_spas15"] = "spas15", --models/weapons/tacint_shark/w_spas15.mdl
	["tacrp_io_saiga"] = "saiga", --models/weapons/tacint_shark/w_saiga.mdl
	["tacrp_eo_m3"] = "m3", --models/weapons/tacint_extras/w_m3.mdl
	["tacrp_pa_ksg12"] = "ksg12", --models/weapons/tacint_shark/w_ksg12.mdl
	["tacrp_eo_hkcaws"] = "hkcaws", --models/weapons/tacint_shark/w_hkcaws.mdl
	["tacrp_h_spas12"] = "spas12", --models/weapons/tacint_shark/w_spas12.mdl
	["tacrp_m4star10"] = "m4star10", --models/weapons/tacint/w_m4star10.mdl
	["tacrp_ks23"] = "ks23", --models/weapons/tacint/w_ks23.mdl
	["tacrp_fp6"] = "fp6", --models/weapons/tacint/w_fp6.mdl
	["tacrp_tgs12"] = "tgs12", --models/weapons/tacint/w_tgs12.mdl
	["tacrp_bekas"] = "bekas", --models/weapons/tacint/w_bekas.mdl

-------MACHINE GUNS---------------
	["tacrp_pa_lewis"] = "lewis", --models/weapons/tacint/w_lewis.mdl
	["tacrp_eo_m60"] = "m60", --models/weapons/tacint_shark/w_m60.mdl
	["tacrp_ak_galil_lmg"] = "galil_lmg", --models/weapons/tacint_extras/w_galil_lmg.mdl
	["tacrp_io_rpk"] = "rpk", --models/weapons/tacint_shark/w_rpk.mdl
	["tacrp_eo_mg42"] = "mg42", --models/weapons/tacint_shark/w_mg42.mdl
	["tacrp_pa_fnmag"] = "fnmag", --models/weapons/tacint/w_fnmag.mdl
	["tacrp_sd_pkm"] = "pkm", --models/weapons/tacint_shark/w_pkm.mdl
	["tacrp_io_xm8lmg"] = "xm8lmg", --models/weapons/tacint_extras/w_xm8lmg.mdl
	["tacrp_h_hk23e"] = "hk23e", --models/weapons/tacint_shark/w_hk23e_beta10.mdl
	["tacrp_mg4"] = "mg4", --models/weapons/tacint/w_mg4.mdl
	
---------BATTLE RIFLES------------	
	["tacrp_pa_svt40"] = "svt40", --models/weapons/tacint/w_svt40.mdl
	["tacrp_eo_sg510"] = "sg510", --models/weapons/tacint_shark/w_sg510.mdl
	["tacrp_pa_sks"] = "sks", --models/weapons/tacint_extras/w_sks.mdl
	["tacrp_eo_howa"] = "howa", --models/weapons/tacint_shark/w_howa.mdl
	["tacrp_eo_fal"] = "fal", --models/weapons/tacint_shark/w_stg58.mdl
	["tacrp_sd_g3"] = "g3", --models/weapons/tacint_shark/w_g3.mdl
	["tacrp_io_scarh"] = "scarh", --models/weapons/tacint_shark/w_scarh.mdl
	["tacrp_eo_mcx"] = "mcx", --models/weapons/tacint_shark/w_mcx.mdl
	["tacrp_hk417"] = "hk417", --models/weapons/tacint/w_hk417.mdl
	["tacrp_dsa58"] = "dsa58", --models/weapons/tacint/w_dsa58.mdl

--------ASSAULT RIFLES------------
	["tacrp_pa_stg44"] = "stg44", --models/weapons/tacint_shark/w_stg44.mdl
	["tacrp_eo_l85"] = "l85", --models/weapons/tacint_shark/w_l85.mdl
	["tacrp_ar_m16a1"] = "m16a1", --models/weapons/tacint_extras/w_m16a1.mdl
	["tacrp_ar_lr300"] = "lr300", --models/weapons/tacint_extras/w_lr300.mdl
	["tacrp_io_fnc"] = "fnc", --models/weapons/tacint_extras/w_fnc.mdl
	["tacrp_eo_f2000"] = "f2000", --models/weapons/tacint_shark/w_f2000.mdl
	["tacrp_eo_ar70"] = "ar70", --models/weapons/tacint_shark/w_ar70.mdl
	["tacrp_eo_auga1"] = "auga1", --models/weapons/tacint_shark/w_auga1.mdl	
	["tacrp_ak_rk95"] = "rk95", --models/weapons/tacint_shark/w_rk95.mdl
	["tacrp_sd_groza"] = "groza", --models/weapons/tacint_shark/w_groza.mdl
	["tacrp_sd_famas"] = "famas", --models/weapons/tacint_shark/w_famas.mdl
	["tacrp_eo_m733"] = "m733", --models/weapons/tacint_shark/w_m733.mdl
	["tacrp_io_m16a2"] = "m16a2", --models/weapons/tacint_extras/w_m16a2.mdl
	["tacrp_eo_masada"] = "masada", --models/weapons/tacint_shark/w_masada.mdl
	["tacrp_io_xm8car"] = "xm8car", --models/weapons/tacint_shark/w_xm8car.mdl
	["tacrp_eo_g36c"] = "g36c", --models/weapons/tacint_extras/w_g36c.mdl
	["tacrp_eo_scarl"] = "scar", --models/weapons/tacint_shark/w_scarl.mdl				
	["tacrp_sd_famas_g2"] = "famas_g2", --models/weapons/tacint_extras/w_famas_g2.mdl
	["tacrp_ar_m16a4"] = "m16a4", --models/weapons/tacint_extras/w_m16a4.mdl
	["tacrp_io_val"] = "val", --models/weapons/tacint_extras/w_val.mdl
	["tacrp_ak_aek971"] = "aek971", --models/weapons/tacint_shark/w_aek.mdl
	["tacrp_ar_vltor"] = "vltor", --models/weapons/tacint_extras/w_vltor.mdl
	["tacrp_ar_hk416"] = "hk416", --models/weapons/tacint_extras/w_hk416.mdl
	["tacrp_ak_an94"] = "an94", --models/weapons/tacint_shark/w_an94.mdl
	["tacrp_ak_ak12"] = "ak12", --models/weapons/tacint_extras/w_ak12.mdl
	["tacrp_sd_aac_hb"] = "acc_hb", --models/weapons/tacint_shark/w_aac_hb2.mdl
	["tacrp_sg551"] = "sg551", --models/weapons/tacint/w_sg551.mdl
	["tacrp_ex_ak47"] = "ak74", --models/weapons/tacint_extras/w_ak47.mdl
	["tacrp_ex_m4a1"] = "m4a1", --models/weapons/tacint_extras/w_m4a1.mdl
	["tacrp_m4"] = "m4", --models/weapons/tacint/w_m4.mdl
	["tacrp_g36k"] = "g36", --models/weapons/tacint/w_g36k.mdl
	["tacrp_aug"] = "aug", --models/weapons/tacint/w_aug.mdl
	["tacrp_amd65"] = "amd65", --models/weapons/tacint/w_amd65.mdl
	["tacrp_k1a"] = "k1a", --models/weapons/tacint/w_k1a.mdl
	["tacrp_ak47"] = "ak47", --models/weapons/tacint/w_ak47.mdl

---------SUBMACHINE GUNS----------
	["tacrp_sd_mp40"] = "mp40", --models/weapons/tacint_shark/w_mp40.mdl
	["tacrp_pa_ppsh"] = "ppsh", --models/weapons/tacint_shark/w_ppsh.mdl
	["tacrp_pa_madsen"] = "madsen", --models/weapons/tacint_extras/w_madsen.mdl	
	["tacrp_sd_thompson"] = "thompson", --models/weapons/tacint_shark/w_thompson.mdl
	["tacrp_pa_luty"] = "luty", --models/weapons/tacint_extras/w_luty.mdl
	["tacrp_pa_uzi"] = "uzi", --models/weapons/tacint/w_uzi_b.mdl
	["tacrp_io_coltsmg"] = "coltsmg", --models/weapons/tacint_shark/w_coltsmg.mdl
	["tacrp_io_mx4"] = "mx4", --models/weapons/tacint_shark/w_mx4.mdl
	["tacrp_sd_bizon"] = "bizon", --models/weapons/tacint_shark/w_bizon.mdl
	["tacrp_eo_mp5sd"] = "mp5sd", --models/weapons/tacint_shark/w_mp5sd.mdl
	["tacrp_ak_ak74u"] = "ak74u", --models/weapons/tacint_shark/w_74u.mdl
	["tacrp_eo_mpx"] = "mpx", --models/weapons/tacint_shark/w_mpx.mdl
	["tacrp_pa_scorpionevo"] = "scorpionevo", --models/weapons/tacint_shark/w_evo3.mdl
	["tacrp_pdw"] = "pdw", --models/weapons/tacint/w_pdw.mdl
	["tacrp_superv"] = "superv", --models/weapons/tacint/w_superv.mdl
	["tacrp_ex_mp9"] = "mp9", --models/weapons/tacint_extras/w_mp9.mdl
	["tacrp_p90"] = "p90", --models/weapons/tacint/w_p90.mdl
	["tacrp_mp5"] = "mp5", --models/weapons/tacint/w_mp5.mdl
	["tacrp_mp7"] = "mp7", --models/weapons/tacint/w_mp7.mdl
	["tacrp_ex_ump45"] = "ump45", --models/weapons/tacint_extras/w_ump45.mdl

-------MACHINE PISTOLS------------
	["tacrp_pa_klin"] = "klin", --models/weapons/tacint/w_klin.mdl
	["tacrp_eo_m712"] = "m712", --models/weapons/tacint_shark/w_m712.mdl
	["tacrp_io_vp70"] = "vp70", --models/weapons/tacint_extras/w_vp70.mdl
	["tacrp_pa_cz75"] = "cz75", --models/weapons/tacint_extras/w_cz75.mdl
	["tacrp_io_tec9"] = "tec9", --models/weapons/tacint_extras/w_tec9.mdl
	["tacrp_eo_mp5k"] = "mp5k", --models/weapons/tacint_shark/w_mp5k.mdl
	["tacrp_io_glock18"] = "glock18", --models/weapons/tacint_extras/w_glock18.mdl
	["tacrp_pa_ots33"] = "ots33", --models/weapons/tacint_extras/w_ots33.mdl
	["tacrp_eo_93r"] = "93r", --models/weapons/tacint_shark/w_93r.mdl
	["tacrp_xd45"] = "xd45", --models/weapons/tacint/w_xd45.mdl
	["tacrp_uzi"] = "uzi_pro", --models/weapons/tacint/w_uzi.mdl
	["tacrp_sphinx"] = "sphinx", --models/weapons/tacint/w_sphinx.mdl
	["tacrp_skorpion"] = "skorpion", --models/weapons/tacint/w_skorpion.mdl
	["tacrp_ex_mac10"] = "mac10", --models/weapons/tacint_extras/w_mac10.mdl

-------AKIMBOS--------------------
--[[
	["tacrp_pa_dual_makarov"] = "dual_makarov", --models/weapons/tacint_extras/w_dual_makarov.mdl
	["tacrp_sd_dualies"] = "dualies", --models/weapons/tacint_shark/w_dualies.mdl
	["tacrp_sd_dual_usp"] = "dual_usp", --models/weapons/tacint_shark/w_dual_usp.mdl
	["tacrp_sd_dual_ppk"] = "dual_ppk", --models/weapons/tacint_shark/w_dual_ppk.mdl
	["tacrp_sd_dual_1911"] = "dual_1911", --models/weapons/tacint_shark/w_dual_1911.mdl
	["tacrp_eo_dual_satana"] = "dual_satana", --models/weapons/tacint_shark/w_m29_dual.mdl
	["tacrp_h_dual_hardballers"] = "dual_hardballers", --models/weapons/tacint_shark/w_dual_hardballers.mdl
	["tacrp_mtx_dual"] = "mtx_dual", --models/weapons/tacint/	
	["tacrp_sd_dual_degala"] = "dual_degala", --models/weapons/tacint_shark/w_dual_eagles.mdl
]]
----------MAGNUMS-----------------
	["tacrp_io_degala"] = "degala", --models/weapons/tacint_extras/w_deagle.mdl
	["tacrp_io_automag"] = "automag", --models/weapons/tacint_extras/w_automag.mdl
	["tacrp_pa_automag3"] = "automag3", --models/weapons/tacint_extras/w_automag3.mdl

----------REVOLVERS---------------
	["tacrp_sd_1858"] = "1858", --models/weapons/tacint_shark/w_1858.mdl
	["tacrp_pa_rhino60ds"] = "rhino60ds", --models/weapons/tacint_extras/w_rhino60ds.mdl
	["tacrp_pa_sw686"] = "sw686", --models/weapons/tacint_extras/w_sw686.mdl
	["tacrp_h_executioner"] = "executioner", --models/weapons/tacint_shark/w_executioner.mdl
	["tacrp_eo_m29"] = "m29", --models/weapons/tacint_shark/w_m29.mdl
	["tacrp_io_m500"] = "m500", --models/weapons/tacint_shark/w_m500.mdl
	["tacrp_pa_python"] = "python", --models/weapons/tacint/w_python.mdl
	["tacrp_mr96"] = "mr96", --models/weapons/tacint/w_mr96.mdl

----------PISTOLS-----------------
	["tacrp_sd_tt33"] = "tt33", --models/weapons/tacint_shark/w_tt33.mdl
	["tacrp_eo_p210"] = "p210", --models/weapons/tacint_shark/w_p210.mdl	
	["tacrp_pa_makarov"] = "makarov", --models/weapons/tacint/w_makarov.mdl
	["tacrp_io_ruger"] = "ruger", --models/weapons/tacint_extras/w_ruger.mdl
	["tacrp_io_ab10"] = "ab10", --models/weapons/tacint_extras/w_ab10.mdl
	["tacrp_pa_fort12"] = "fort12", --models/weapons/tacint_extras/w_fort12.mdl
	["tacrp_pa_woodsman"] = "woodsman", --models/weapons/tacint_extras/w_woodsman.mdl
	["tacrp_eo_browninghp"] = "browninghp", --models/weapons/tacint_extras/w_browninghp.mdl
	["tacrp_sd_ppk"] = "ppk", --models/weapons/tacint_shark/w_ppk.mdl
	["tacrp_eo_megastar"] = "megastar", --models/weapons/tacint_shark/w_megastar.mdl
	["tacrp_eo_hushpup"] = "hushpup", --models/weapons/tacint_shark/w_hushpup.mdl
	["tacrp_io_p226"] = "p226", --models/weapons/tacint_extras/w_p226.mdl
	["tacrp_eo_p7"] = "p7", --models/weapons/tacint_shark/w_hkp7.mdl
	["tacrp_eo_jericho"] = "jericho", --models/weapons/tacint_shark/w_jericho.mdl
	["tacrp_eo_p99"] = "p99", --models/weapons/tacint_shark/w_p99.mdl
	["tacrp_io_fiveseven"] = "fiveseven", --models/weapons/tacint_shark/w_57.mdl
	["tacrp_ex_hk45c"] = "hk45c", --models/weapons/tacint_extras/w_hk45c.mdl
	["tacrp_p2000"] = "p2000", --models/weapons/tacint/w_p2000.mdl
	["tacrp_ex_usp"] = "usp", --models/weapons/tacint_extras/w_usp.mdl
	["tacrp_gsr1911"] = "gsr1911", --models/weapons/tacint/w_gsr1911.mdl
	["tacrp_p250"] = "p250", --models/weapons/tacint/w_p250.mdl
	["tacrp_ex_m1911"] = "m1911", --models/weapons/tacint_extras/w_m1911.mdl
	["tacrp_ex_glock"] = "glock", --models/weapons/tacint_extras/w_glock_new.mdl
	["tacrp_vertec"] = "vertec", --models/weapons/tacint/w_vertec.mdl
----------------------------------




}

-------------------------------------------------------------------------

game.AddDecal("mur_ducttape", "decals/mur_ducttape")