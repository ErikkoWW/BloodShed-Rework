local meta = FindMetaTable("Player")

function meta:Surrender(force, moment, id, dur, copmodel)
	if self:GetNWBool("GeroinUsed") or self:IsRolePolice() and not string.match(self:GetNWString("SVAnim"), "rd_") then return end

	if moment then
		timer.Simple(30, function()
			if not IsValid(ent) then return end
			ent:SetRenderFX(kRenderFxFadeSlow)

			timer.Simple(4, function()
				if not IsValid(ent) then return end
				ent:Remove()
			end)
		end)

		self:ScreenFade(SCREENFADE.IN, color_black, 1, 0)
		self:SetSVAnimation("sequence_ron_arrest_start_npc_0" .. id)
		self:Freeze(true)
		self:SetNWFloat("DeathStatus", 3)
		if copmodel then
			local ent = ents.Create("prop_dynamic")
			ent:SetModel(table.Random(MuR.PlayerModels["Police"]))
			ent:SetPos(self:GetPos())
			ent:SetAngles(Angle(0, self:EyeAngles().y, 0))
			ent:Spawn()
			ent:DropToFloor()
			ent:ResetSequence("sequence_ron_arrest_start_player_0" .. id)
			copmodel = ent
			self:EmitSound("murdered/other/arrest_body.mp3", 60)
		end
		timer.Simple(dur, function()
			if not IsValid(self) then return end
			local ent = ents.Create("prop_dynamic")
			ent:TransferModelData(self)
			ent:SetPos(self:GetPos() + self:GetForward() * 16)
			ent:SetAngles(Angle(0, self:EyeAngles().y, 0))
			ent:Spawn()
			ent:DropToFloor()
			ent:ResetSequence("sequence_ron_arrest_wiggleloop")
			ent:SetRenderMode(RENDERMODE_TRANSALPHA)
			ent:MakePlayerColor(self:GetPlayerColor())

			self:StopRagdolling()
			self:KillSilent()
			self:SetSVAnimation("")
			self:Freeze(false)
			MuR:GiveAnnounce("arrested", self)

			-- self:SetNWFloat("Guilt", math.Clamp(self:GetNWFloat("Guilt", 0) - 10, 0, 100))

			if IsValid(copmodel) then
				copmodel:Remove()
			end
		end)
	else
		if self:GetNWString("SVAnim") ~= "" then
			self:SetSVAnimation("sequence_ron_comply_exit_0" .. math.random(1,3), true)
		else
			self:SetSVAnimation("sequence_ron_comply_start_0" .. math.random(1,4))
		end
	end
end

function MuR:SpawnPolice(type, pos)
	local tab = MuR.PoliceClasses[type]
	if not istable(tab) then return end

	if type ~= "zombie" then
		local class, wclass = tab.npcs[math.random(1, #tab.npcs)], tab.weps[math.random(1, #tab.weps)]
		local ent = ZBaseSpawnZBaseNPC(class, pos, nil, wclass)
		ent.IsPolice = true

		timer.Simple(2, function()
			if not IsValid(ent) then return end
			local pos = MuR:GetRandomPos(tobool(math.random(0,4)))
			if isvector(pos) then
				ent:SetLastPosition(pos)
				ent:SetSchedule(SCHED_FORCED_GO_RUN)
			end
			--print(pos)
		end)
	else
		local class = tab[math.random(1, #tab)]
		local ent = ZBaseSpawnZBaseNPC(class, pos)
	end
end

function MuR:CheckPoliceReinforcment()
	local pa = MuR:CountPlayerPolice()
	pa = pa + MuR:CountNPCPolice()
	if (MuR.PoliceState == 2 or MuR.PoliceState == 4) and pa == 0 then
		MuR.PoliceArriveTime = CurTime() + (60 + 2 * player.GetCount())
		MuR.PoliceState = 5
	end
	if MuR.PoliceState == 6 and pa == 0 then
		timer.Simple(3, function()
			if MuR.PoliceState ~= 6 then return end
			MuR:SpawnPlayerPolice(true)
		end)
	end
end

local function PushApart(npc1, npc2)
	local pos1 = npc1:GetPos()
	local pos2 = npc2:GetPos()
	if pos1:DistToSqr(pos2) > 10000 then return end
	local dir = (pos1 - pos2):GetNormalized()
	local pushForce = 25
	local npc1allow = not npc1:IsPlayer()
	local npc2allow = not npc2:IsPlayer()

	if npc1allow then
		npc1:SetVelocity(dir * pushForce)
	end
	if npc2allow then
		npc2:SetVelocity(-dir * pushForce)
	end
end

hook.Add("ShouldCollide", "MuR_NoCollisionNPCs", function(ent1, ent2)
	if ent1 == ent2 then return false end
	local allow1 = ent1:IsNPC() and ent1.IsPolice and not ent1.DoingPlayAnim or ent1:IsPlayer() and ent1:IsRolePolice()
	local allow2 = ent2:IsNPC() and ent2.IsPolice and not ent1.DoingPlayAnim or ent2:IsPlayer() and ent2:IsRolePolice()
	if allow1 and allow2 then
		PushApart(ent1, ent2)
		return false
	end
end)

hook.Add("EntityTakeDamage", "MuR_NoCollisionNPCs", function(ent, dmg)
	local att = dmg:GetAttacker()
	local allow1 = ent:IsNPC() and ent.IsPolice or ent:IsPlayer() and ent:IsRolePolice()
	local allow2 = att:IsNPC() and att.IsPolice or att:IsPlayer() and att:IsRolePolice()
	if allow1 and allow2 then
		return true
	end
end)