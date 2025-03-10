MuR.PoliceClasses = {
	["patrol"] = {
		npcs = {
			"npc_vj_cruscoprioth",
		},
		weps = {
			"weapon_vj_senperuspistol",
		},
	},
	["swat"] = {
		npcs = {
			"npc_vj_crussobrsenh",
		},
		weps = {
			"weapon_vj_senpeak",
			"weapon_vj_senpevikhr",
		},
	},
	["security"] = {
		npcs = {
			"npc_vj_cruscoph",
		},
		weps = {
			"weapon_vj_senperuspistol",
		},
		underroof = false,
	},
	["zombie"] = {
		"npc_zombie", 
		"npc_fastzombie", 
		"npc_poisonzombie"
	},
	max_npcs = 8,
	delay_spawn = 2,
	security_spawn = 0,
	no_npc_police = true,
}