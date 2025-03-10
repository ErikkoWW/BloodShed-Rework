local NPC = FindZBaseTable(debug.getinfo(1,'S'))

NPC.Models = {"models/murdered/npc/british_cop.mdl"}

NPC.WeaponProficiency = WEAPON_PROFICIENCY_GOOD -- WEAPON_PROFICIENCY_POOR || WEAPON_PROFICIENCY_AVERAGE || WEAPON_PROFICIENCY_GOOD
-- || WEAPON_PROFICIENCY_VERY_GOOD || WEAPON_PROFICIENCY_PERFECT

NPC.StartHealth = 100 -- Max health

NPC.CanPatrol = true -- Use base patrol behaviour

NPC.ZBaseStartFaction = "neutral" -- Any string, all ZBase NPCs with this faction will be allied

NPC.AlertSounds = "Police_Surrender" -- Sounds emitted when an enemy is seen for the first time
NPC.IdleSounds = "" -- Sounds emitted while there is no enemy
NPC.Idle_HasEnemy_Sounds = "Police_Surrender" -- Sounds emitted while there is an enemy
NPC.PainSounds = "Police_ShotFired"
NPC.DeathSounds = "MuR_Male_Died" -- Sounds emitted on death
NPC.KilledEnemySounds = "" -- Sounds emitted when the NPC kills an enemy


NPC.LostEnemySounds = "" -- Sounds emitted when the enemy is lost
NPC.OnReloadSounds = "" -- Sounds emitted when the NPC reloads
NPC.OnGrenadeSounds = "" -- Sounds emitted when the NPC throws a grenade


-- Dialogue sounds
-- The NPCs will face each other as if they are talking
NPC.Dialogue_Question_Sounds = "" -- Dialogue questions, emitted when the NPC starts talking to another NPC
NPC.Dialogue_Answer_Sounds = "" -- Dialogue answers, emitted when the NPC is spoken to

NPC.CanOpenDoors = true -- Can open regular doors
NPC.CanOpenAutoDoors = true -- Can open auto doors

-- Sounds emitted when the NPC hears a potential enemy, only with this addon enabled:
-- https://steamcommunity.com/sharedfiles/filedetails/?id=3001759765
NPC.HearDangerSounds = ""

NPC.FootStepSounds = "" -- Footstep sound

NPC.FollowPlayerSounds = "" -- Sounds emitted when the NPC starts following a player
NPC.UnfollowPlayerSounds = "" -- Sounds emitted when the NPC stops following a player

NPC.MuteDefaultVoice = true -- Mute all default voice sounds emitted by this NPC
NPC.ForceAvoidDanger = true

NPC.BaseMeleeAttack = true -- Use ZBase melee attack system
NPC.MeleeAttackFaceEnemy = true -- Should it face enemy while doing the melee attack?
NPC.MeleeAttackTurnSpeed = 15 -- Speed that it turns while trying to face the enemy when melee attacking
NPC.MeleeAttackDistance = 140 -- Distance that it initiates the melee attack from
NPC.MeleeAttackCooldown = {8, 16} -- Melee attack cooldown {min, max}
NPC.MeleeAttackName = "Taser" -- Serves no real purpose, you can use it for whatever you want
NPC.MeleeAttackAnimations = {"drawpistol"} -- Example: NPC.MeleeAttackAnimations = {ACT_MELEE_ATTACK1}
NPC.MeleeAttackAnimationSpeed = 1.2 -- Speed multiplier for the melee attack animation
NPC.MeleeDamage = {10, 10} -- Melee damage {min, max}
NPC.MeleeDamage_Distance = 160 -- Damage reach distance
NPC.MeleeDamage_Angle = 90 -- Damage angle (180 = everything in front of the NPC is damaged)
NPC.MeleeDamage_Delay = 1.3 -- Time until the damage strikes, set to false to disable the timer (if you want to use animation events instead for example)
NPC.MeleeDamage_Type = DMG_CLUB -- The damage type, https://wiki.facepunch.com/gmod/Enums/DMG
NPC.MeleeDamage_Sound = "ZBase.Melee2" -- Sound when the melee attack hits an enemy
NPC.MeleeDamage_Sound_Prop = "" -- Sound when the melee attack hits props
NPC.MeleeDamage_AffectProps = false -- Affect props and other entites

function NPC:OnMeleeAttackDamage(tab)
	for _, ent in ipairs(tab) do
		if ent:IsPlayer() and ent:Alive() and ent:GetNWFloat("ArrestState") == 1 then
			local i = 0
			timer.Create("Tasered"..ent:EntIndex(), 0.05, 50, function()
				i = i + 1
				if !IsValid(ent) or !ent:Alive() then return end
				ent:SetEyeAngles(ent:EyeAngles()+Angle(math.Rand(-10,10),math.Rand(-10,10),0))
				ent:ViewPunch(AngleRand(-10,10))
				if math.random(1,5) == 1 then
					ent:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav", 50)

					local ef = EffectData()
					ef:SetEntity(ent)
					ef:SetMagnitude(1)
					util.Effect("TeslaHitboxes", ef)
				end
				if i == 50 and isfunction(ent.Surrender) and ent:Alive() then
					local id = math.random(1,6) 
					local anim = "sequence_ron_arrest_start_player_0"..id
					local _, dur = ent:LookupSequence(anim)

					ent:Surrender(true, true, id, dur, true)
				end
			end)
		end
	end
end

function NPC:OnMelee()
	local w = self:GetActiveWeapon()
	if !IsValid(w) then return end

	w:SetNoDraw(true)

	local taser = ents.Create("base_anim")
	taser:SetModel("models/murdered/weapons/w_taser.mdl")
	taser:Spawn()
	local att = self:LookupAttachment("anim_attachment_rh")
	local tab = self:GetAttachment(att)
	taser:SetPos(tab.Pos)
	taser:SetAngles(tab.Ang)
	taser:SetParent(self, att)
	taser:SetLocalAngles(Angle(270,90,0))
	taser:SetLocalPos(Vector(2,0,2))
	self:DeleteOnRemove(taser)
	self:StopCurrentAnimation()
	self:PlayAnimation("drawpistol", true, {duration = 2})

	timer.Simple(2, function()
		if !IsValid(self) then return end
		if IsValid(taser) then taser:Remove() end
		if IsValid(w) then w:SetNoDraw(false) end
		self:StopCurrentAnimation()
		self:PlayAnimation("drawpistol", true)
	end)
end

--]]==============================================================================================]]
function NPC:CustomInitialize()
	local skinCount = self:SkinCount()
	local randomSkin = math.random(0, skinCount - 1)
	self:SetSkin(randomSkin)

	for i = 0, self:GetNumBodyGroups() - 1 do
		local bodyGroupCount = self:GetBodygroupCount(i)
		local randomBodyGroup = math.random(0, bodyGroupCount - 1)
		self:SetBodygroup(i, randomBodyGroup)
	end

	self:SetCustomCollisionCheck(true)
	self:SetCooldown("arrestmove", math.random(45,120))
end

function NPC:SetCooldown(name, time)
	if not name or not time then return end
	self:SetNWFloat(name, CurTime()+time)
end

function NPC:GetCooldown(name)
	if not name then return end
	return math.max(self:GetNWFloat(name)-CurTime(), 0)
end
--]]==============================================================================================]]
function NPC:CustomThink()
	if not self.doorbusting then
		local tr = util.TraceLine({
			start = self:GetPos() + Vector(0, 0, 32),
			endpos = self:GetPos() + Vector(0, 0, 32) + self:GetAngles():Forward() * 40,
			filter = function(ent)
				return ent:GetClass() == "prop_door_rotating" or ent:GetClass() == "func_door_rotating" or ent:GetClass() == "func_door"
			end
		})

		if tr.Hit and tr.Entity and not IsValid(self.readytobust) then
			if not self.DoingPlayAnim and (tr.Entity:GetClass() == "prop_door_rotating" or tr.Entity:GetClass() == "func_door_rotating") and tr.Entity:GetInternalVariable("m_bLocked") and not tr.Entity:GetInternalVariable("m_eDoorState") ~= 0 and not tr.Entity.doorbusting then
				local seq = 'adoorknock'
				local doors = tr.Entity
				if self:LookupSequence(seq) > 0 then
					local rnd1 = math.random(2, 8)
					self:PlayAnimation(seq, false, {duration = rnd1})

					timer.Simple(rnd1, function()
						self.readytobust = doors
					end)
				else
					self.readytobust = doors
				end
			end
		end

		if IsValid(self.readytobust) then
			if self.readytobust:GetInternalVariable("m_bLocked") and not self.readytobust:GetInternalVariable("m_eDoorState") ~= 0 and not self.readytobust.doorbusting then
				self.doorbusting = true
				tr.Entity.doorbusting = true
				self:KickDoor(self.readytobust)
			end
		end
	end

	local ent = self:GetEnemy()
	if IsValid(ent) and ent:IsPlayer() and ent:GetNWFloat('ArrestState') == 1 then
		local push = self:GetCooldown("arrestmove") == 0
		if push then
			self:PushEnemy()
		end
	else
		self:SetCooldown("arrestmove", math.random(45,120))
	end
end
--]]==============================================================================================]]
function NPC:ShouldFireWeapon()
	local ent = self:GetEnemy()
	if IsValid(ent) and ent:IsPlayer() and ent:GetNWFloat('ArrestState') < 2 then
		self.MinShootDistance = 100 
		self.MaxShootDistance = 1000 
		return false
	end
	self.MinShootDistance = 0 
	self.MaxShootDistance = 3000 
	return true
end
--]]==============================================================================================]]
function NPC:PushEnemy()
	local ent = self:GetEnemy()
	if !IsValid(ent) then return end

	self:SetCooldown("arrestmove", math.random(45,120))
	self:SetLastPosition(ent:GetPos())
	self:SetSchedule(SCHED_FORCED_GO)
end

function NPC:KickDoor(door)
	local seq = 'kickdoorbaton'

	if self:LookupSequence(seq) < 1 then
		seq = table.Random(self.MeleeAttackAnimations)
	end

	self:PlayAnimation(seq, false)

	if IsValid(self) then
		timer.Simple(1, function()
			if !IsValid(door) or !IsValid(self) then return end
			self:SetName("officer_" .. self:EntIndex())
			door:SetKeyValue("Speed", "500")
			door:SetKeyValue("Open Direction", "Both directions")
			door:Fire("unlock")
			door:TakeDamage(500, self)
			door:EmitSound("physics/wood/wood_plank_break"..math.random(1,4)..".wav", 80)

			if door:GetClass() == 'prop_door_rotating' then
				door:Fire("openawayfrom", "officer_" .. self:EntIndex(), .01)
			else
				door:Fire("Open")
			end
		end)

		timer.Simple(2, function()
			if !IsValid(door) or !IsValid(self) then return end
			door:SetKeyValue("Speed", "100")
			door.doorbusting = false
		end)

		timer.Simple(3, function()
			if !IsValid(self) then return end
			self.doorbusting = false
			self.readytobust = nil
		end)
	end
end

--]]==============================================================================================]]

hook.Add("PlayerPostThink", "MuR.PoliceNPCLogic", function(ply)
	if ply.LogicNPCThink and ply.LogicNPCThink > CurTime() then return end

	ply.LogicNPCThink = CurTime()+1

	local state = ply:GetNWFloat('ArrestState')
	local di = 3
	if state > 0 then
		di = 1
	end

	for _, ent in ipairs(ents.FindByClass("npc_combine_s")) do
		ent:AddEntityRelationship(ply, di, 99)
	end
end)

if engine.ActiveGamemode() == "sandbox" then
	hook.Remove("PlayerPostThink", "MuR.PoliceNPCLogic")
	NPC.ZBaseStartFaction = "combine"
	function NPC:ShouldFireWeapon()
		return true
	end
end