MuR.GameStarted = true
MuR.Delay_Before_Lose = 0
MuR.Gamemode = 1
MuR.PoliceState = 0
MuR.PoliceArriveTime = 0
MuR.PoliceDelaySpawn = 0
MuR.TimeCount = 0
MuR.SecuritySpawned = false
MuR.TeamAssign = false
MuR.TeamAssignDelay = 30
MuR.NextGamemode = 0
MuR.NextTraitor = nil
MuR.NextTraitor2 = nil
MuR.NextTraitor3 = nil
MuR.NextTraitor4 = nil
MuR.Ending = false
MuR.TimeBeforeStart = 0
MuR.NPC_To_Spawn = 0
MuR.VoteLog = 0
MuR.VoteAllowed = false
MuR.VoteLogDeadPolice = 0
MuR.LogTable = {
	dead = {},
	dead_cops = {},
	injured = {},
	heavy_injured = {},
}

--[[
function MuR:RemoveMapLogic()
	local tab = ents.GetAll()

	for i = 1, #tab do
		local ent = tab[i]

		if ent:IsNPC() or ent:IsWeapon() or ent:GetClass() == "trigger_once" or ent:GetClass() == "trigger_multiple" or ent:GetClass() == "func_brush" then
			ent:Remove()
		end
	end
end
]]

function MuR:GiveRandomTableWithChance(tab, extra)
	local totalChance = 0
	local tab2 = table.Copy(tab)
	local t = {}
	if isfunction(extra) then
		for i, subtable in pairs(tab2) do
			if extra(subtable) then
				table.insert(t, subtable)
			end
		end
	else
		t = table.Copy(tab2)
	end

	if #t == 0 then return end

	for _, subtable in pairs(t) do
		totalChance = totalChance + subtable.chance
	end
	
	local randomValue = math.random(totalChance)
	local currentChance = 0
	for i, subtable in pairs(t) do
		currentChance = currentChance + subtable.chance
		if randomValue <= currentChance then
			return subtable, i
		end
	end
end

function MuR:ChangeStateOfGame(state)
	game.CleanUpMap()

	if state then
		hook.Call("MuR.GameState", nil, true)
		MuR.GameStarted = true
		MuR.TimeCount = CurTime()

		local gm_rnd = select(2, MuR:GiveRandomTableWithChance(MuR.GamemodeChances, function(v) return player.GetCount() >= v.need_players end))
		MuR.Gamemode = gm_rnd

		if MuR.NextGamemode > 0 then
			MuR.Gamemode = MuR.NextGamemode
			MuR.NextGamemode = 0
		end

		--MuR:RemoveMapLogic()

		if not MuR:DisablesGamemode() then
			timer.Create("MuRSpawnLoot", 0.2, MuR.MaxLootNumber, function()
				if not MuR.GameStarted then return end
				MuR:SpawnLoot()
			end)
		end

		timer.Simple(0.01, function()
			for _, ply in ipairs(player.GetAll()) do
				net.Start("MuR.StartScreen")
				net.WriteFloat(MuR.Gamemode)
				net.WriteString(ply:GetNWString("Class"))
				net.Send(ply)
			end
		end)

		MuR:RandomizePlayers()
		MuR:MakeDoorsBreakable()
		local tab = ents.GetAll()

		for i = 1, #tab do
			local ent = tab[i]

			if ent:IsWeapon() then
				ent:Remove()
			end

			if ent:IsPlayer() then
				ent:ChangeGuilt(-100)
			end
		end

		if MuR.Gamemode == 5 or MuR.Gamemode == 11 or MuR.Gamemode == 12 or MuR.Gamemode == 13 then
			timer.Simple(12, function()
				MuR:GiveCountdown(10)
			end)
		end
	else
		MuR.PoliceState = 0
		MuR.PoliceArriveTime = 0
		MuR.NPC_To_Spawn = 0
		MuR.SecuritySpawned = false
		MuR.TeamAssign = false
		MuR.TeamAssignDelay = math.random(45, 120)
		MuR.Ending = false
		MuR.VoteLog = 0
		MuR.VoteAllowed = false
		MuR.VoteLogDeadPolice = 0
		MuR.GameStarted = false
		MuR.LogTable = {
			dead = {},
			dead_cops = {},
			injured = {},
			heavy_injured = {},
		}
		hook.Call("MuR.GameState", nil, false)

		for _, ply in ipairs(player.GetAll()) do
			if ply:Alive() then
				ply:KillSilent()
			end
		end
	end
end

function MuR:SpawnPlayerPolice(assault)
	if MuR.PoliceClasses.no_player_police then return end
	local donthave = false
	for _, ply in ipairs(player.GetAll()) do
		if ply:Alive() or assault and ply:Team() == 2 then continue end
		if  donthave and not assault then continue end

		donthave = true
		ply.ForceSpawn = true

		if MuR.PoliceState == 4 or assault then
			ply:SetNWString("Class", "ArmoredOfficer")
		else
			ply:SetNWString("Class", "Officer")
		end

		ply:Spawn()
		ply:ScreenFade(SCREENFADE.IN, color_black, 1, 1)
		local pos = MuR:GetRandomPos(false)

		if not isvector(pos) then
			pos = MuR:GetRandomPos(true)
		end

		ply:SetPos(pos)
		MuR:GiveAnnounce("officer_spawn", ply)
	end
	if not donthave then
		local ply = table.Random(player.GetAll())

		ply.ForceSpawn = true

		if MuR.PoliceState == 4 or assault then
			ply:SetNWString("Class", "ArmoredOfficer")
		else
			ply:SetNWString("Class", "Officer")
		end

		ply:Spawn()
		ply:ScreenFade(SCREENFADE.IN, color_black, 1, 1)
		local pos = MuR:GetRandomPos(false)

		if not isvector(pos) then
			pos = MuR:GetRandomPos(true)
		end

		ply:SetPos(pos)
		MuR:GiveAnnounce("officer_spawn", ply)
	end
	for _, ply in ipairs(player.GetAll()) do
		if ply:IsKiller() and ply:GetNWFloat("ArrestState") < 1 then
			ply:SetNWFloat("ArrestState", 1)
		end
	end
end

function MuR:SpawnLoot(pos)
	local pos2 = pos

	if not pos then
		pos = MuR:GetRandomPos(true)
		if not isvector(pos) then return end
		pos2 = MuR:FindPositionInRadius(pos, 256)
	end

	if isvector(pos2) then
		local class = MuR:GiveRandomTableWithChance(MuR.Loot).class
		local ent = ents.Create(class)

		if IsValid(ent) then
			ent:SetPos(pos2)
			ent:Spawn()

			if ent:IsWeapon() then
				if ent.ClipSize then
					ent.Primary.DefaultClip = 0

					if ent.ClipSize then
						ent:SetClip1(math.random(0, ent.ClipSize))
						ent:SetClip2(0)
					end
				end
				if MuR:DisableWeaponLoot() then
					ent:Remove()
				end
			end
		end
	end
end

function MuR:MakeDoorsBreakable()
	local tab = ents.FindByClass("*_door_*")

	for i = 1, #tab do
		local ent = tab[i]
		local health = math.min(math.Clamp(math.floor(ent:OBBMaxs():LengthSqr()), 10, 2500), 1000)
		ent:SetNWBool("BreakableThing", true)
		ent:SetMaxHealth(health)
		ent:SetHealth(health)
	end
end

function MuR:CallPolice(mult)
	if not mult then
		mult = 1
	end

	local isswat = MuR.Gamemode == 8 or MuR.Gamemode == 10
	if MuR.PoliceState > 0 or not MuR.GameStarted or MuR:DisablesGamemode() then return false end

	if isswat then
		MuR.PoliceArriveTime = CurTime() + (120 + 10 * player.GetCount()) * mult
		MuR.PoliceState = 3
	else
		MuR.PoliceArriveTime = CurTime() + (120 + 15 * player.GetCount()) * mult
		MuR.PoliceState = 1
	end

	MuR:PlaySoundOnClient("murdered/other/policecall.wav")

	return true
end

function MuR:ExfilPlayers(pos, dist)
	if not pos then
		pos = Vector(0,0,0)
	end
	if not dist then
		dist = 32000
	end
	for _, ply in ipairs(player.GetAll()) do
		local allow = ply:GetPos():Distance(pos) <= dist
		if !ply:IsKiller() and ply:GetNWString("Class") != "Zombie" and ply:Alive() then
			if allow then
				ply:KillSilent()
				ply:SetNWFloat("DeathStatus", 4)
			else
				ply:Kill()
			end
		end
	end
end

function MuR:MakeTeamsInGame()
	local tab, tab2 = player.GetAll(), {}

	for i = 1, #tab do
		if tab[i]:Alive() then
			table.insert(tab2, tab[i])
		end
	end

	if #tab2 >= 2 then
		local id = math.random(1, #tab2)
		local ply = tab2[id]
		ply:SetNWString("Class", "Traitor")
		ply:SetTeam(1)
		ply:GiveWeapon("tacrp_p2000")
		ply:AllowFlashlight(true)
		ply:GiveAmmo(18, "Pistol", true)
		ply:GiveWeapon("mur_combat_knife", true)
		MuR:GiveAnnounce("you_killer", ply)
		table.remove(tab2, id)
		local id = math.random(1, #tab2)
		local ply = tab2[id]
		ply:SetNWString("Class", "Defender")
		ply:GiveWeapon("tacrp_p2000")
		MuR:GiveAnnounce("you_defender", ply)
		table.remove(tab2, id)
	end
end

function MuR:RandomizePlayers()
	local kteam, dteam, iteam = "Killer", "Defender", "Innocent"

	if MuR.Gamemode == 2 then
		kteam, dteam = "Shooter", "Innocent"
	elseif MuR.Gamemode == 3 then
		kteam, dteam = "Maniac", "Innocent"
	elseif MuR.Gamemode == 4 then
		kteam, dteam = "Traitor", "Hunter"
	elseif MuR.Gamemode == 5 then
		kteam, dteam, iteam = "Soldier", "Soldier", "Soldier"
	elseif MuR.Gamemode == 6 then
		kteam, dteam, iteam = "Zombie", "Soldier", "Soldier"
	elseif MuR.Gamemode == 7 then
		kteam, dteam, iteam = "Traitor", "Hunter", "Defender"
	elseif MuR.Gamemode == 8 then
		kteam, dteam = "Traitor", "Officer"
	elseif MuR.Gamemode == 9 then
		kteam, dteam = "Innocent", "Innocent"
	elseif MuR.Gamemode == 10 then
		kteam, dteam = "Terrorist", "Officer"
	elseif MuR.Gamemode == 11 then
		kteam, dteam = "Attacker", "Riot"
	elseif MuR.Gamemode == 12 then
		kteam, dteam = "Terrorist2", "SWAT"
	elseif MuR.Gamemode == 13 then
		kteam, dteam = "K_Faction", "M_Faction"
	elseif MuR.Gamemode == 14 then
		kteam, dteam = "War_RUS", "War_UKR"
	end

	local tab = player.GetAll()

	if MuR.Gamemode ~= 11 and MuR.Gamemode ~= 12 and MuR.Gamemode ~= 13 and MuR.Gamemode ~= 14 then

		if MuR.Gamemode == 1 or MuR.Gamemode == 2 or MuR.Gamemode == 3 or MuR.Gamemode == 4 or MuR.Gamemode == 6 or MuR.Gamemode == 7 or MuR.Gamemode == 8 or MuR.Gamemode == 10 then

			if #tab >= 2 then                   
				local id = math.random(1, #tab)
				local ply = tab[id]

				if IsValid(MuR.NextTraitor) then
					ply = MuR.NextTraitor
					id = table.KeyFromValue(tab, ply)
					MuR.NextTraitor = nil
				end

				ply:SetNWString("Class", kteam)
				ply:Spawn()
				ply:Freeze(true)
				ply:GodEnable()

				timer.Simple(10, function()
					if not IsValid(ply) then return end
					ply:Freeze(false)
					ply:GodDisable()
				end)

				table.remove(tab, id)

				local id = math.random(1, #tab)
				local ply = tab[id]
				ply:SetNWString("Class", dteam)
				ply:Spawn()
				ply:Freeze(true)
				ply:GodEnable()

				timer.Simple(10, function()
					if not IsValid(ply) then return end
					ply:Freeze(false)
					ply:GodDisable()
				end)

				table.remove(tab, id)
			end
		
			if #tab >= 7  then
				local id = math.random(1, #tab)
				local ply = tab[id]

				if IsValid(MuR.NextTraitor2) then
					ply = MuR.NextTraitor2
					id = table.KeyFromValue(tab, ply)
					MuR.NextTraitor2 = nil
				end

				ply:SetNWString("Class", kteam)
				ply:Spawn()
				ply:Freeze(true)
				ply:GodEnable()

				timer.Simple(10, function()
					if not IsValid(ply) then return end
					ply:Freeze(false)
					ply:GodDisable()
				end)

				table.remove(tab, id)

				if MuR.Gamemode ~= 5 and MuR.Gamemode ~= 6 and MuR.Gamemode ~= 11 then
					if math.random(1, 4) >= 2 then
						local id = math.random(1, #tab)
						local ply = tab[id]
						ply:SetNWString("Class", "Medic")
						ply:Spawn()
						ply:Freeze(true)
						ply:GodEnable()

						timer.Simple(10, function()
							if not IsValid(ply) then return end
							ply:Freeze(false)
							ply:GodDisable()
						end)

						table.remove(tab, id)
					end

					if math.random(1, 4) >= 2 then
						local id = math.random(1, #tab)
						local ply = tab[id]
						ply:SetNWString("Class", "Builder")
						ply:Spawn()
						ply:Freeze(true)
						ply:GodEnable()

						timer.Simple(10, function()
							if not IsValid(ply) then return end
							ply:Freeze(false)
							ply:GodDisable()
						end)

						table.remove(tab, id)
					end
			
					if math.random(1, 10) == 1 then
						local id = math.random(1, #tab)
						local ply = tab[id]
						ply:SetNWString("Class", "FBI")
						ply:Spawn()
						ply:Freeze(true)
						ply:GodEnable()

						timer.Simple(10, function()
							if not IsValid(ply) then return end
							ply:Freeze(false)
							ply:GodDisable()
						end)

						table.remove(tab, id)
					end
				end
			end
			if #tab >= 15 then
				local id = math.random(1, #tab)
				local ply = tab[id]

				if IsValid(MuR.NextTraitor3) then
					ply = MuR.NextTraitor3
					id = table.KeyFromValue(tab, ply)
					MuR.NextTraitor3 = nil
				end

				ply:SetNWString("Class", kteam)
				ply:Spawn()
				ply:Freeze(true)
				ply:GodEnable()

				timer.Simple(10, function()
					if not IsValid(ply) then return end
					ply:Freeze(false)
					ply:GodDisable()
				end)

				table.remove(tab, id)

				if MuR.Gamemode ~= 5 and MuR.Gamemode ~= 6 and MuR.Gamemode ~= 11 then
					if math.random(1, 4) >= 2 then
						local id = math.random(1, #tab)
						local ply = tab[id]
						ply:SetNWString("Class", "Medic")
						ply:Spawn()
						ply:Freeze(true)
						ply:GodEnable()

						timer.Simple(10, function()
							if not IsValid(ply) then return end
							ply:Freeze(false)
							ply:GodDisable()
						end)

						table.remove(tab, id)
					end

					if math.random(1, 4) >= 2 then
						local id = math.random(1, #tab)
						local ply = tab[id]
						ply:SetNWString("Class", "Builder")
						ply:Spawn()
						ply:Freeze(true)
						ply:GodEnable()

						timer.Simple(10, function()
							if not IsValid(ply) then return end
							ply:Freeze(false)
							ply:GodDisable()
						end)

						table.remove(tab, id)
					end
			
					if math.random(1, 10) == 1 then
						local id = math.random(1, #tab)
						local ply = tab[id]
						ply:SetNWString("Class", "FBI")
						ply:Spawn()
						ply:Freeze(true)
						ply:GodEnable()

						timer.Simple(10, function()
							if not IsValid(ply) then return end
							ply:Freeze(false)
							ply:GodDisable()
						end)

						table.remove(tab, id)
					end
				end

			end
			if #tab >= 20 then
				local id = math.random(1, #tab)
				local ply = tab[id]

				if IsValid(MuR.NextTraitor3) then
					ply = MuR.NextTraitor3
					id = table.KeyFromValue(tab, ply)
					MuR.NextTraitor3 = nil
				end

				ply:SetNWString("Class", kteam)
				ply:Spawn()
				ply:Freeze(true)
				ply:GodEnable()

				timer.Simple(10, function()
					if not IsValid(ply) then return end
					ply:Freeze(false)
					ply:GodDisable()
				end)

			table.remove(tab, id)

				if MuR.Gamemode ~= 5 and MuR.Gamemode ~= 6 and MuR.Gamemode ~= 11 then
					if math.random(1, 4) >= 2 then
						local id = math.random(1, #tab)
						local ply = tab[id]
						ply:SetNWString("Class", "Medic")
						ply:Spawn()
						ply:Freeze(true)
						ply:GodEnable()

						timer.Simple(10, function()
							if not IsValid(ply) then return end
							ply:Freeze(false)
							ply:GodDisable()
						end)

						table.remove(tab, id)
					end

					if math.random(1, 4) >= 2 then
						local id = math.random(1, #tab)
						local ply = tab[id]
						ply:SetNWString("Class", "Builder")
						ply:Spawn()
						ply:Freeze(true)
						ply:GodEnable()

						timer.Simple(10, function()
							if not IsValid(ply) then return end
							ply:Freeze(false)
							ply:GodDisable()
						end)

						table.remove(tab, id)
					end
				
					if math.random(1, 10) == 1 then
						local id = math.random(1, #tab)
						local ply = tab[id]
						ply:SetNWString("Class", "FBI")
						ply:Spawn()
						ply:Freeze(true)
						ply:GodEnable()

						timer.Simple(10, function()
							if not IsValid(ply) then return end
							ply:Freeze(false)
							ply:GodDisable()
						end)

						table.remove(tab, id)
					end
				end

			end
		end		

		if #tab >= 2 and MuR.Gamemode == 8 then
			local id = math.random(1, #tab)
			local ply = tab[id]

			if IsValid(MuR.NextTraitor2) then
				ply = MuR.NextTraitor2
				id = table.KeyFromValue(tab, ply)
				MuR.NextTraitor2 = nil
			end

			ply:SetNWString("Class", kteam)
			ply:Spawn()
			ply:Freeze(true)
			ply:GodEnable()

			timer.Simple(10, function()
				if not IsValid(ply) then return end
				ply:Freeze(false)
				ply:GodDisable()
			end)

			table.remove(tab, id)
		end

		for i = 1, #tab do
			local ply = tab[i]
			ply:SetNWString("Class", iteam)
			ply:Spawn()
			ply:Freeze(true)
			ply:GodEnable()

			timer.Simple(10, function()
				if not IsValid(ply) then return end
				ply:Freeze(false)
				ply:GodDisable()
			end)
		end
	else
		table.Shuffle(tab)
		local start = tobool(math.random(0, 1))

		for i = 1, #tab do
			local ply = tab[i]

			if start then
				start = false
				ply:SetNWString("Class", kteam)
				ply:Spawn()
				ply:Freeze(true)
				ply:GodEnable()

				timer.Simple(10, function()
					if not IsValid(ply) then return end
					ply:Freeze(false)
					ply:GodDisable()
				end)
			else
				start = true
				ply:SetNWString("Class", dteam)
				ply:Spawn()
				ply:Freeze(true)
				ply:GodEnable()

				timer.Simple(10, function()
					if not IsValid(ply) then return end
					ply:Freeze(false)
					ply:GodDisable()
				end)
			end
		end
	end
end

local senddatadelay = 0

hook.Add("Think", "SuR_GameLogic", function()
	if MuR.GameStarted then
		RunConsoleCommand("ai_clear_bad_links")

		local team1, team2 = 0, 0
		local tab = player.GetAll()

		for i = 1, #tab do
			local ent = tab[i]

			if ent:Alive() then
				if ent:Team() == 1 then
					team1 = team1 + 1
				elseif ent:Team() == 2 then
					team2 = team2 + 1
				end
			end
		end

		if MuR.Gamemode == 6 then
			if team2 > 0 then
				MuR.Delay_Before_Lose = CurTime() + 5
			end
		else
			if MuR.Gamemode == 14 and team2 > 0 and team1 > 0 then
				MuR.Delay_Before_Lose = CurTime() + 5
			elseif team1 > 0 and team2 > 0 and not MuR:DisablesGamemode() or MuR.Gamemode == 9 and MuR.TimeCount > CurTime() - MuR.TeamAssignDelay or MuR.TimeCount > CurTime() - 12 then
				MuR.Delay_Before_Lose = CurTime() + 5
			elseif team1 > 0 and team2 > 0 and MuR:DisablesGamemode() and (MuR.Gamemode == 11 or MuR.Gamemode == 12 or MuR.Gamemode == 13) and (team1 >= 1 or team2 >= 1) then
				MuR.Delay_Before_Lose = CurTime() + 5
			elseif MuR.Gamemode == 5 and team2 >= 2 then
				MuR.Delay_Before_Lose = CurTime() + 5
			end
		end

		if MuR.Gamemode == 9 and MuR.TimeCount < CurTime() - MuR.TeamAssignDelay and not MuR.TeamAssign then
			MuR.TeamAssign = true
			MuR:MakeTeamsInGame()
		end

		if (MuR.PoliceState == 1 or MuR.PoliceState == 3 or MuR.PoliceState == 5) and MuR.PoliceArriveTime < CurTime() then
			MuR.PoliceState = MuR.PoliceState + 1
			MuR:PlaySoundOnClient("murdered/other/policearrive.wav")
			MuR:SpawnPlayerPolice(MuR.PoliceState == 6 or MuR.PoliceState == 4)
			MuR.NPC_To_Spawn = math.floor(math.Clamp(player.GetCount() * math.Rand(0.2,2), 2, 16))
			if MuR.PoliceState == 6 then
				MuR.NPC_To_Spawn = 64
			end
		end

		if MuR.PoliceState == 7 and MuR.PoliceArriveTime < CurTime() then
			MuR.PoliceArriveTime = CurTime() + math.random(30,90)
			MuR.PoliceState = MuR.PoliceState + 1
		elseif MuR.PoliceState == 8 and MuR.PoliceArriveTime < CurTime() then
			MuR.PoliceState = 0
		end

		if MuR:CountNPCPolice(true) < MuR.PoliceClasses.max_npcs and MuR.PoliceDelaySpawn < CurTime() and not MuR.PoliceClasses.no_npc_police and MuR.NPC_To_Spawn > 0 then
			local pos = MuR:GetRandomPos(false)

		 	if not isvector(pos) then
		 		pos = MuR:GetRandomPos(true)
		 	end

		 	if isvector(pos) then
		 		MuR.PoliceDelaySpawn = CurTime() + MuR.PoliceClasses.delay_spawn
		 		MuR.NPC_To_Spawn = MuR.NPC_To_Spawn - 1

		 		if MuR.PoliceState == 4 or MuR.PoliceState == 6 then
		 			MuR:SpawnPolice("swat", pos)
		 		else
		 			MuR:SpawnPolice("patrol", pos)
		 		end
		 	end
		 end

		if MuR.Gamemode == 6 and #ents.FindByClass("npc_*") < MuR.PoliceClasses.max_npcs and MuR.TimeCount < CurTime() - 12 and MuR.PoliceDelaySpawn < CurTime() then
		 	local pos = MuR:GetRandomPos(tobool(math.random(0, 1)))

		 	if isvector(pos) then
		 		MuR.PoliceDelaySpawn = CurTime() + MuR.PoliceClasses.delay_spawn
		 		MuR:SpawnPolice("zombie", pos)
		 	end
		end

		if MuR.TimeCount < CurTime() - 12 then
			if MuR.Gamemode == 2 or MuR.Gamemode == 3 or MuR.Gamemode == 10 and MuR.TimeCount > CurTime() - 13 then
				MuR:CallPolice()
			end

			if MuR.Gamemode == 6 and MuR.PoliceState == 0 and MuR.TimeCount > CurTime() - 13 then
				MuR.PoliceArriveTime = CurTime()+math.random(180,300)
				MuR.PoliceState = 7
			end

			if MuR.Gamemode == 6 and MuR.PoliceState == 8 and !IsValid(MuR.EscapeFlareEntity) then
				local underroof = false
				local pos = MuR:GetRandomPos(underroof)
				if not isvector(pos) then
					pos = MuR:GetRandomPos(not underroof)
				end
				if isvector(pos) then
					local ent = ents.Create("escape_flare")
					ent:SetPos(pos)
					ent:Spawn()
					MuR.EscapeFlareEntity = ent
				end
			elseif MuR.Gamemode == 6 and MuR.PoliceState != 8 and IsValid(MuR.EscapeFlareEntity) then
				MuR.EscapeFlareEntity:Remove()
			end

			if not MuR:DisablesGamemode() and not MuR.SecuritySpawned then
				MuR.SecuritySpawned = true

				for i = 1, MuR.PoliceClasses.security_spawn do
					local pos = MuR:GetRandomPos(MuR.PoliceClasses["security"].underroof)

					if not isvector(pos) then
						pos = MuR:GetRandomPos(not MuR.PoliceClasses["security"].underroof)
					end

					if isvector(pos) then
						MuR:SpawnPolice("security", pos)
					end
				end
			end
		end

		if MuR.Delay_Before_Lose < CurTime() and not MuR.Ending then
			MuR.TimeBeforeStart = CurTime() + 15
			MuR.Ending = true
			MuR.PoliceState = 0

			local show_vote = MuR:GetLogTable() and player.GetCount() > 4

			if MuR.Gamemode == 5 or MuR.Gamemode == 6 or MuR.Gamemode == 11 or MuR.Gamemode == 12 or MuR.Gamemode == 13 then
				MuR:ShowFinalScreen("", false)
			elseif team1 > 0 then
				MuR:ShowFinalScreen("traitor", show_vote)
				if show_vote then
					MuR.VoteAllowed = true 
					MuR.VoteLog = 0
				end
			elseif team2 > 0 then
				MuR:ShowFinalScreen("innocent", show_vote)
				if show_vote then
					MuR.VoteAllowed = true 
					MuR.VoteLog = 0
				end
			else
				MuR:ShowFinalScreen("", false)
			end

			local tab = player.GetAll()

			for i = 1, #tab do
				local ent = tab[i]
				ent:Freeze(false)
			end
		end

		if MuR.Ending and MuR.TimeBeforeStart < CurTime() then
			if MuR.VoteAllowed and MuR.VoteLog >= player.GetCount()/2 then
				MuR.VoteLog = 0
				MuR.VoteAllowed = false
				MuR:ShowLogScreen()
			else
				MuR:ChangeStateOfGame(false)
			end
		end
	else
		if player.GetCount() > 1 then
			MuR:ChangeStateOfGame(true)
		end
	end

	if senddatadelay < CurTime() then
		senddatadelay = CurTime() + 0.1
		MuR:SendDataToClient("VoteLog", MuR.VoteLog)
		MuR:SendDataToClient("PoliceState", MuR.PoliceState)
		MuR:SendDataToClient("PoliceArriveTime", MuR.PoliceArriveTime)
		MuR:SendDataToClient("War", MuR.War)
		if MuR.PoliceState == 8 and IsValid(ents.FindByClass("escape_flare")[1]) then
			MuR:SendDataToClient("ExfilPos", ents.FindByClass("escape_flare")[1]:GetPos()+Vector(0,0,32))
		end
	end
end)