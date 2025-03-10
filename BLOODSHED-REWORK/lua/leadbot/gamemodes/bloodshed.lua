--[[GAMEMODE CONFIGURATION START]]--

LeadBot.SetModel = false
LeadBot.Gamemode = "bloodshed"
LeadBot.LerpAim = true

--[[GAMEMODE CONFIGURATION END]]--

hook.Add("PlayerHurt", "LeadBotRecognize", function(ply, tar, hp, dmg)
	if tar:IsPlayer() and ply:IsLBot() then
		local controller = ply:GetController()
		controller.LookAtTime = CurTime() + 2
		controller.LookAt = ((tar:GetPos() + VectorRand() * 128) - ply:GetPos()):Angle()
		controller.ForgetTarget = CurTime()+15
		controller.Target = tar
		ply.PossibleEnemy = tar
		if not ply.DangerForBots then
			tar.DangerForBots = true
			timer.Create("TarDanger"..tar:EntIndex(), 15, 1, function()
				if !IsValid(tar) then return end
				tar.DangerForBots = false
			end)
		end
	end
end)

local function SoCanSee(bot, pos)
	local self = bot.ControllerBot
	if ply:GetPos():DistToSqr(self:GetPos()) > self:GetMaxVisionRange() * self:GetMaxVisionRange() then
		return false
	end

	fov = fov or true

	return util.QuickTrace(bot:EyePos(), pos - bot:EyePos(), {bot, self}).Entity == ply
end

function LeadBot.StartCommand(bot, cmd)
	local buttons = 0
	local botWeapon = bot:GetActiveWeapon()
	local controller = bot.ControllerBot
	local target = controller.Target

	if !IsValid(controller) then return end
	if MuR.TimeCount+22 > CurTime() then
		bot.SearchTime = CurTime() + math.Rand(15,120)
		bot.SearchTimeWalk = CurTime() + math.Rand(15,120)
		controller.Target = nil
		target = nil
	end
	if MuR.TimeCount+13 > CurTime() or bot:GetNWString('SVAnim') != "" and !IsValid(bot:GetRD()) then return end

	if IsValid(botWeapon) and (botWeapon:Clip1() == 0 or !IsValid(target) and botWeapon:Clip1() <= botWeapon:GetMaxClip1() / 2) then
		buttons = buttons + IN_RELOAD
	end

	if IsValid(target) and math.random(2) == 1 and (target:IsPlayer() and IsValid(target:GetRD()) or target:IsPlayer() and !IsValid(bot:GetRD()) and controller:CanSee(target) or !target:IsPlayer()) and not bot.ReadyToTakedown then
		buttons = buttons + IN_ATTACK
	end

	if bot:GetMoveType() == MOVETYPE_LADDER then
		local pos = controller.goalPos
		local ang = ((pos + bot:GetCurrentViewOffset()) - bot:GetShootPos()):Angle()

		if pos.z > controller:GetPos().z then
			controller.LookAt = Angle(-30, ang.y, 0)
		else
			controller.LookAt = Angle(30, ang.y, 0)
		end

		controller.LookAtTime = CurTime() + 0.1
		controller.NextJump = -1
		buttons = buttons + IN_FORWARD
	end

	if controller.NextDuck > CurTime()then
		buttons = buttons + IN_DUCK
	elseif controller.NextJump == 0 then
		controller.NextJump = CurTime() + 1
		buttons = buttons + IN_JUMP
	end

	if !bot:IsOnGround() and controller.NextJump > CurTime() then
		buttons = buttons + IN_DUCK
	end

	if IsValid(bot:GetRD()) then
		local pos = MuR:BoneData(bot:GetRD(), "ValveBiped.Bip01_Pelvis")
		if bot:TimeGetUp(true) and MuR:CheckHeight(bot:GetRD(), pos) < 16 and bot:CanGetUp() then
			bot:StopRagdolling(false, true)
		end

		local tar = target
		if IsValid(tar) then
			bot.IsRagStanding = true 

			if IsValid(bot:GetRD().Weapon) and bot:GetRD().Weapon.Weapon:Clip1() <= 0 and bot:GetRD().Weapon.Reload then
				bot:GetRD().Weapon.shootedtime = 0
				bot:GetRD().Weapon:Reload()
			end

			if IsValid(bot:GetRD().Weapon) and bot:GetRD().Weapon.data.twohand then
				buttons = buttons + IN_ATTACK
				buttons = buttons + IN_ATTACK2
				buttons = buttons + IN_FORWARD
			elseif IsValid(bot:GetRD().Weapon) then
				buttons = buttons + IN_ATTACK2
				buttons = buttons + IN_FORWARD
			end

			if (not bot.FuckAttackMelee or bot.FuckAttackMelee < CurTime()) and IsValid(bot:GetRD().Weapon) then
				bot.FuckAttackMelee = CurTime()+math.Rand(1,2)
				bot:SetEyeAngles(bot:EyeAngles()+Angle(math.random(-90,90),0,0))
			end

			if bot.ShootRagDelay < CurTime() and IsValid(bot:GetRD().Weapon) then
				bot.ShootRagDelay = CurTime()+math.Rand(0.2,1)
				bot:GetRD().Weapon:Shoot(true)
				bot:GetRD().Weapon:Shoot(false)
			end
		else
			bot.ShootRagDelay = CurTime()+math.Rand(0.2,1)
		end
	else
		bot.ShootRagDelay = CurTime()+math.Rand(0,0.8)
	end

	local tent = bot.TakeThatEntity
	if IsValid(tent) and !IsValid(tent:GetOwner()) and !IsValid(target) then
		if controller:CanSee(tent) then
			controller.LookAtTime = CurTime()+1
			controller.LookAt = (tent:WorldSpaceCenter()-bot:EyePos()):GetNormalized():Angle()
		end
		controller.PosGen = tent:GetPos()
		controller.LastSegmented = CurTime() + 1
		if tent:GetPos():DistToSqr(bot:GetPos()) < 5000 then
			bot:PickupWeapon(tent)
			buttons = buttons + IN_DUCK
		end
		if IsValid(tent:GetOwner()) then
			bot.TakeThatEntity = nil
		end
	end

	if IsValid(target) and target:Health() < 50 and target:IsPlayer() and bot:GetNWFloat('Stamina') > 50 and bot:IsKiller() and not IsValid(bot:GetRD()) and (not IsValid(target:GetRD()) and bot:IsAtBack(controller.Target) or IsValid(target:GetRD())) and bot:GetPos():DistToSqr(controller.Target:GetPos()) < 20000 then
		bot.ReadyToTakedown = true
	else
		bot.ReadyToTakedown = false
	end

	if bot.ReadyToTakedown then
		if bot:GetPos():DistToSqr(controller.Target:GetPos()) < 3000 then
			controller.NextJump = CurTime() + 5
			controller.nextStuckJump = CurTime() + 5
			if IsValid(controller.Target:GetRD()) then
				bot:Takedown(controller.Target:GetRD())
			else
				bot:Takedown(controller.Target)
			end
		end
	end

	if bot.IdleState == nil then
		bot.IdleState = false
		bot.IdleTime = CurTime()+math.Rand(15,60)
		bot.HideWeapon = 0
		bot.StuckTimeWall = 0
	end

	---Stuck in Wall
	local tr = util.TraceHull({
		start = bot:GetPos(),
		endpos = bot:GetPos(),
		filter = function(ent)
			if ent:GetClass() == "prop_ragdoll" or ent == bot then
				return false
			else
				return true
			end 
		end,
		mins = bot:OBBMins(),
		maxs = bot:OBBMaxs(),
		mask = MASK_SHOT_HULL,
	})
	if tr.Hit then
		if bot.StuckTimeWall < CurTime() then
			bot.StuckTimeWall = CurTime()+10
			bot:SetPos(table.Random(navmesh.GetAllNavAreas()):GetRandomPoint())
		end
	else
		bot.StuckTimeWall = CurTime()+10
	end

	if bot.IdleTime < CurTime() then
		if bot.IdleState then
			bot.IdleTime = CurTime()+math.Rand(15,60)
			bot.IdleState = false
		else
			local num = math.Rand(5,15)
			bot.IdleTime = CurTime()+num
			bot.IdleState = true
		end
	elseif bot.IdleState and math.random(1,200) == 1 then
		local tab = ents.FindInSphere(bot:GetPos(), 1024)
		if #tab > 0 then
			local tar = tab[math.random(1,#tab)]
			controller.LookAtTime = CurTime()+2
			controller.LookAt = (tar:GetPos() + VectorRand() * 128 - bot:GetPos()):Angle()
		end
	end
	if IsValid(target) then
		bot.IdleState = false
	end

	if bot.CurrentWeaponMelee then
		if IsValid(target) and target:GetPos():DistToSqr(bot:GetPos()) > 6000 then
			buttons = buttons + IN_SPEED
		end
	end

	local dt = util.QuickTrace(bot:EyePos(), bot:GetForward() * 45, bot)
	local tracetype = "nothing"
	if IsValid(dt.Entity) and dt.Entity:GetClass() == "prop_door_rotating" then
		tracetype = "propdoor"
	elseif IsValid(dt.Entity) and (dt.Entity:GetClass() == "func_door_rotating" or dt.Entity:GetClass() == "func_door") then
		tracetype = "funcdoor"
	elseif IsValid(dt.Entity) and (dt.Entity:GetClass() == "func_breakable" or dt.Entity:GetClass() == "func_breakable_surf") then
		tracetype = "breakable"
	end

	if tracetype == "propdoor" then
		dt.Entity:Fire("OpenAwayFrom", bot, 0)
		dt.Entity:TakeDamage(1)
		if bot.CurrentWeaponMelee then
			buttons = buttons + IN_ATTACK
		end
	elseif tracetype == "funcdoor" then
		dt.Entity:Fire("Open", bot, 0)
		dt.Entity:TakeDamage(1)
		if bot.CurrentWeaponMelee then
			buttons = buttons + IN_ATTACK
		end
	elseif tracetype == "breakable" then
		dt.Entity:Fire("RemoveHealth", 1)
		if bot.CurrentWeaponMelee then
			buttons = buttons + IN_ATTACK
		end
	end

	local curwep = ""
	if IsValid(bot:GetActiveWeapon()) then
		curwep = bot:GetActiveWeapon():GetClass()
	end
	if (IsValid(target) or bot:GetNWString('Class') == "Soldier" or bot:IsActiveKiller()) and MuR.TimeCount+22 < CurTime()  then
		local weps, mwep, fwep = bot:GetWeapons(), nil, nil
		for i=1,#weps do
			local wep = weps[i]
			if !IsValid(mwep) and wep.Melee then
				mwep = wep
			elseif IsValid(mwep) and wep.Melee and wep.Primary.Damage and (wep.Primary.Damage or 1 > mwep.Primary.Damage or 1) and wep.Melee then
				mwep = wep
			end
			if !IsValid(fwep) and wep:GetMaxClip1() > 0 and (bot:GetAmmoCount(wep:GetPrimaryAmmoType()) > 0 or wep:Clip1() > 0) and not wep.DisableSuicide then
				fwep = wep
			elseif IsValid(fwep) and wep:GetMaxClip1() > 0 and (bot:GetAmmoCount(wep:GetPrimaryAmmoType()) > 0 or wep:Clip1() > 0) and wep.DamageMax and (wep.DamageMax or 1 > fwep.DamageMax or 1) and not wep.DisableSuicide then
				fwep = wep
			end
		end
		if IsValid(fwep) and (IsValid(target) or !IsValid(target)) then
			if fwep:GetClass() != curwep then
				bot:SelectWeapon(fwep:GetClass())
			end
			bot.CurrentWeaponMelee = false
		elseif IsValid(mwep) then
			if mwep:GetClass() != curwep then
				bot:SelectWeapon(mwep:GetClass())
			end
			bot.CurrentWeaponMelee = true
		else
			if "mur_hands" != curwep then
				bot:SelectWeapon("mur_hands")
			end
			bot.CurrentWeaponMelee = true
		end
	else
		if "mur_hands" != curwep then
			bot:SelectWeapon("mur_hands")
		end
		bot.CurrentWeaponMelee = true
	end
	cmd:ClearButtons()
	cmd:ClearMovement()
	cmd:SetButtons(buttons)
end

function LeadBot.Think()
	for _, bot in pairs(player.GetBots()) do
		if bot:IsLBot() then
			bot:SetNWFloat('Hunger', 100)
		end	
	end
end

function LeadBot.FindTargets(bot)
	local controller = bot.ControllerBot
	if MuR.Gamemode != 14 and MuR.Gamemode != 13 and MuR.Gamemode != 12 and MuR.Gamemode != 11 and MuR.Gamemode != 6 then
		if !IsValid(controller.Target) and !bot:IsKiller() then
			for _, ply in ipairs(player.GetAll()) do
				if ply ~= bot and (ply:IsPlayer() and LeadBot.ThisTargetDanger(bot, ply)) and ply:GetPos():DistToSqr(bot:GetPos()) < 15000000 and controller:CanSee(ply) and !bot:IsKiller() then
					if ply:Alive() and controller:CanSee(ply) then
						controller.Target = ply
						controller.ForgetTarget = CurTime() + 15
						break
					end
				end
			end
		elseif controller.ForgetTarget < CurTime() and IsValid(controller.Target) and controller:CanSee(controller.Target) then
			controller.ForgetTarget = CurTime() + 15
		end

		if bot:IsActiveKiller() and !IsValid(controller.Target) then
			bot.SearchTime = 0
		end

		if bot:IsKiller() then
			print(bot.SearchTime-CurTime(), bot, controller.Target)
		end

		if !IsValid(controller.Target) and (bot:IsKiller() or bot:GetNWString('Class') == "Soldier") and (not bot.SearchTime or bot.SearchTime < CurTime()) then
			bot.SearchTime = CurTime() + 1
			for _, ply in ipairs(player.GetAll()) do
				if bot:IsKiller() and !bot:IsActiveKiller() and MuR:VisibleByPlayers(ply, bot) then continue end
				if ply ~= bot  and ply:GetPos():DistToSqr(bot:GetPos()) < 15000000 and !ply:IsKiller() then
					if ply:Alive() and (bot:IsLineOfSightClear(ply:WorldSpaceCenter()) or IsValid(ply:GetRD()) and bot:IsLineOfSightClear(ply:GetRD():WorldSpaceCenter())) then
						controller.ForgetTarget = CurTime() + 15
						controller.Target = ply
						bot.PossibleEnemy = ply
						if bot:IsActiveKiller() then
							bot.SearchTime = CurTime() + math.Rand(1,4)
						else
							bot.SearchTime = CurTime() + math.Rand(15,60)
						end
						break
					end
				end
			end
			if not bot.SearchTimeWalk or bot.SearchTimeWalk < CurTime() then
				bot.SearchTimeWalk = CurTime()+30
				local tab = {}
				for _, ply in ipairs(player.GetAll()) do
					if ply:Alive() and !ply:IsKiller() then
						table.insert(tab, ply:WorldSpaceCenter())
					end
				end
				if #tab > 0 then
					controller.LastSegmented = CurTime() + 30
					controller.PosGen = tab[math.random(1,#tab)]
				end
			end
		end
	else
		if !IsValid(controller.Target) then
			for _, ply in ipairs(player.GetAll()) do
				if ply ~= bot and (ply:IsPlayer() and ply:Team() != bot:Team()) and ply:GetPos():DistToSqr(bot:GetPos()) < 15000000 and controller:CanSee(ply) then
					if ply:Alive() and controller:CanSee(ply) then
						controller.Target = ply
						controller.ForgetTarget = CurTime() + 15
						break
					end
				end
			end
		elseif controller.ForgetTarget < CurTime() and controller:CanSee(controller.Target) then
			controller.ForgetTarget = CurTime() + 15
		end
	end
	
	if !IsValid(controller.Target) and (not bot.LootTime or bot.LootTime < CurTime()) then
		bot.LootTime = CurTime() + 2
		if IsValid(bot.TakeThatEntity) then
			bot.TakeThatEntity:Remove()
		end
		for _, ent in ipairs(ents.GetAll()) do
			if (ent:IsWeapon() and (ent:GetMaxClip1() > 0 or ent.Melee) and !IsValid(ent:GetOwner())) and ent:GetPos():DistToSqr(bot:GetPos()) < 100000 and not ent:GetNoDraw() then
				bot.LootTime = CurTime() + math.Rand(30,90)
				bot.TakeThatEntity = ent
				break
			end
		end
	end
end

function LeadBot.ThisTargetDanger(bot, tar)
	if tar.DangerForBots or tar:GetNWString('Class') == "Zombie" or tar:GetNWString('Class') == "Soldier" or tar:IsActiveKiller() or bot.PossibleEnemy == tar then
		return true 
	end
	if bot:IsActiveKiller() or bot:GetNWString('Class') == "Zombie" and tar:GetNWString('Class') != "Zombie" then
		return true 
	end
	return false
end

function LeadBot.OpenDoors(bot)
	local pos1 = bot:EyePos()
	local pos2 = bot:EyePos()+bot:GetAimVector()*32
	local tr = util.TraceLine( {
		start = pos1,
		endpos = pos2,
		filter = function(ent) 
			if string.match(ent:GetClass(), "func_door") then 
				return true 
			end 
		end,
	})
	if tr.Hit then
		tr.Entity:Fire('Unlock')
		tr.Entity:Fire('Open')
	end
end

function LeadBot.PlayerMove(bot, cmd, mv)
	local controller = bot.ControllerBot

	if MuR.TimeCount+13 > CurTime() or bot:GetNWString('SVAnim') != "" and !IsValid(bot:GetRD()) then return end

	if !IsValid(controller) then
		bot.ControllerBot = ents.Create("leadbot_navigator")
		bot.ControllerBot:Spawn()
		bot.ControllerBot:SetOwner(bot)
		bot.ControllerBot.CanSee = function(self, ply, fov)
			if ply:GetPos():DistToSqr(self:GetPos()) > self:GetMaxVisionRange() * self:GetMaxVisionRange() then
				return false
			end

			fov = fov or true
		
			if fov and !self:InFOV(ply, math.cos(0.5 * (160) * math.pi / 180)) then
				return false
			end
		
			local owner = self:GetOwner()

			local pos1 = bot:GetPos()
			local pos2 = ply:GetPos()
			local tr = util.TraceLine( {
				start = pos1,
				endpos = pos2,
				filter = function(ent) 
					if ent:IsWorld() or string.match(ent:GetClass(), "prop_") then 
						return true 
					end 
				end,
			})
			return !tr.Hit
		end
		controller = bot.ControllerBot
	end

	-- force a recompute
	if controller.PosGen and controller.P and controller.TPos ~= controller.PosGen then
		controller.TPos = controller.PosGen
		controller.P:Compute(controller, controller.PosGen)
	end

	if controller:GetPos() ~= bot:GetPos() then
		controller:SetPos(bot:GetPos())
	end

	if controller:GetAngles() ~= bot:EyeAngles() then
		controller:SetAngles(bot:EyeAngles())
	end


	mv:SetForwardSpeed(1200)

	if (bot.NextSpawnTime and bot.NextSpawnTime + 1 > CurTime()) or !IsValid(controller.Target) or controller.ForgetTarget < CurTime() or controller.Target:Health() < 1 then
		controller.Target = nil
		bot.PossibleEnemy = nil
		if bot:IsKiller() then
			for _, ply in ipairs(player.GetAll()) do
				if ply ~= bot and !LeadBot.ThisTargetDanger(bot, ply) and ply:GetPos():DistToSqr(bot:GetPos()) < 2500000 and !ply:IsKiller() then
					if ply:Alive() and controller:CanSee(ply) then
						controller.ForgetTarget = CurTime() + 30
						controller.Target = ply
						bot.PossibleEnemy = ply
						bot.SearchTime = CurTime() + math.Rand(30,60)
						break
					end
				end
			end
		end
	end

	LeadBot.OpenDoors(bot)
	LeadBot.FindTargets(bot)

	if !IsValid(controller.Target) and (!controller.PosGen or bot:GetPos():DistToSqr(controller.PosGen) < 5500 or controller.LastSegmented < CurTime()) then
		-- find a random spot on the map, and in 10 seconds do it again!
		controller.PosGen = controller:FindSpot("random", {radius = 12500})
		controller.LastSegmented = CurTime() + 10
	elseif IsValid(controller.Target) then
		-- move to our target
		local distance = controller.Target:GetPos():DistToSqr(bot:GetPos())
		if controller.Target:IsPlayer() then
			controller.PosGen = controller.Target:WorldSpaceCenter()
		else
			controller.PosGen = controller.Target:GetPos()
		end

		if distance <= 90000 and not bot.CurrentWeaponMelee and not bot.ReadyToTakedown and controller:CanSee(bot, controller.Target) then
			mv:SetForwardSpeed(-1200)
		end
	end

	-- movement also has a similar issue, but it's more severe...
	if !controller.P then
		return
	end

	local segments = controller.P:GetAllSegments()

	if !segments then return end

	local cur_segment = controller.cur_segment
	local curgoal = segments[cur_segment]

	-- got nowhere to go, why keep moving?
	if !curgoal then
		mv:SetForwardSpeed(0)
		return
	end

	-- think every step of the way!
	if segments[cur_segment + 1] and Vector(bot:GetPos().x, bot:GetPos().y, 0):DistToSqr(Vector(curgoal.pos.x, curgoal.pos.y)) < 100 then
		controller.cur_segment = controller.cur_segment + 1
		curgoal = segments[controller.cur_segment]
	end

	local goalpos = curgoal.pos

	if bot:GetVelocity():Length2DSqr() <= 225 then
		if controller.NextCenter < CurTime() then
			controller.strafeAngle = ((controller.strafeAngle == 1 and 2) or 1)
			controller.NextCenter = CurTime() + math.Rand(0.3, 0.65)
		elseif controller.nextStuckJump < CurTime() then
			if !bot:Crouching() then
				controller.NextJump = 0
			end
			controller.nextStuckJump = CurTime() + math.Rand(1, 2)
		end
	end

	if bot.IdleState then
		mv:SetForwardSpeed(0)
		controller.NextJump = CurTime() + 1
		controller.nextStuckJump = CurTime() + 1
		controller.NextCenter = 0
	end

	if controller.NextCenter > CurTime() then
		if controller.strafeAngle == 1 then
			mv:SetSideSpeed(1500)
		elseif controller.strafeAngle == 2 then
			mv:SetSideSpeed(-1500)
		else
			mv:SetForwardSpeed(-1500)
		end
	end

	-- jump
	if controller.NextJump ~= 0 and curgoal.type > 1 and controller.NextJump < CurTime() then
		controller.NextJump = 0
	end

	-- duck
	if curgoal.area:GetAttributes() == NAV_MESH_CROUCH then
		controller.NextDuck = CurTime() + 0.1
	end

	controller.goalPos = goalpos

	if GetConVar("developer"):GetBool() then
		controller.P:Draw()
	end

	-- eyesight
	local lerp = FrameTime() * math.random(8, 10)
	local lerpc = FrameTime() * 8

	local mva = ((goalpos + bot:GetCurrentViewOffset()) - bot:GetShootPos()):Angle()

	mv:SetMoveAngles(mva)

	local tar = controller.Target
	if IsValid(tar) then
		if tar:IsPlayer() and IsValid(tar:GetRD()) then
			tar = tar:GetRD()
		end
		--if bot:IsLineOfSightClear(tar:WorldSpaceCenter()) then
			bot:SetEyeAngles(LerpAngle(lerp, bot:EyeAngles(), (tar:WorldSpaceCenter() - bot:GetShootPos()):Angle()))
		--end
		return
	else
		if controller.LookAtTime > CurTime() then
			local ang = LerpAngle(lerpc, bot:EyeAngles(), controller.LookAt)
			bot:SetEyeAngles(Angle(ang.p, ang.y, 0))
		else
			local ang = LerpAngle(lerpc, bot:EyeAngles(), mva)
			bot:SetEyeAngles(Angle(ang.p, ang.y, 0))
		end
	end
end