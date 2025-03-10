local ent = FindMetaTable("Entity")
local pl = FindMetaTable("Player")
local grabKeysHeld = {
    [KEY_LSHIFT] = false, -- Left hand
    [KEY_LALT] = false    -- Right hand
}

local function TransferBones(base, ragdoll)
	if not IsValid(base) or not IsValid(ragdoll) then return end

	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local bone = ragdoll:GetPhysicsObjectNum(i)

		if IsValid(bone) then
			local pos, ang = base:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))

			if pos then
				bone:SetPos(pos)
			end

			if ang then
				bone:SetAngles(ang)
			end
		end
	end
end

local function VelocityOnAllBones(ragdoll, vel)
	if not IsValid(ragdoll) then return end

	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local bone = ragdoll:GetPhysicsObjectNum(i)

		if IsValid(bone) then
			bone:SetVelocity(vel)
			bone:SetMass(8)
		end
	end
end

local function GetCorrectTypeOfBone(name)
	local type = "other"

	local bonetab = {
		["head"] = {
			["ValveBiped.Bip01_Head1"] = true,
			["ValveBiped.Bip01_Neck1"] = true,
		},
		["torso"] = {
			["ValveBiped.Bip01_Pelvis"] = true,
			["ValveBiped.Bip01_Spine"] = true,
			["ValveBiped.Bip01_Spine1"] = true,
			["ValveBiped.Bip01_Spine2"] = true,
			["ValveBiped.Bip01_Spine4"] = true,
		},
		["r_leg"] = {
			["ValveBiped.Bip01_R_Thigh"] = true,
			["ValveBiped.Bip01_R_Calf"] = true,
			["ValveBiped.Bip01_R_Foot"] = true,
			["ValveBiped.Bip01_R_Toe0"] = true,
		},
		["l_leg"] = {
			["ValveBiped.Bip01_L_Thigh"] = true,
			["ValveBiped.Bip01_L_Calf"] = true,
			["ValveBiped.Bip01_L_Foot"] = true,
			["ValveBiped.Bip01_L_Toe0"] = true,
		},
		["r_hand"] = {
			["ValveBiped.Bip01_R_Clavicle"] = true,
			["ValveBiped.Bip01_R_UpperArm"] = true,
			["ValveBiped.Bip01_R_Forearm"] = true,
			["ValveBiped.Bip01_R_Hand"] = true,
		},
		["l_hand"] = {
			["ValveBiped.Bip01_L_Clavicle"] = true,
			["ValveBiped.Bip01_L_UpperArm"] = true,
			["ValveBiped.Bip01_L_Forearm"] = true,
			["ValveBiped.Bip01_L_Hand"] = true,
		},
	}

	for k, v in pairs(bonetab) do
		if v[name] then
			type = k
		end
	end

	return type
end

-------------------PLAYER FUNCTIONS----------------------------

function pl:GetRD()
	return self:GetNWEntity("RD_Ent")
end

local ItemType = {
	["mur_loot_bandage"] = "Bandage",
	["mur_loot_medkit"] = "Medkit",
	["mur_f1"] = "F1",
	["mur_m67"] = "M67",
}

function pl:GiveRagdollWeapon(ent, awep)
	if not IsValid(awep) or not IsValid(ent) then return end
	if IsValid(ent.Weapon) then
		if awep == ent.Weapon.Weapon and self:IsBot() then return end
		ent.Weapon:Remove()
	end
	timer.Simple(0.001, function()
		if not IsValid(ent) or not IsValid(awep) then return end
		if not awep.RagdollType and MuR.WeaponToRagdoll[awep:GetClass()] then
			awep.RagdollType = MuR.WeaponToRagdoll[awep:GetClass()]
		end
		if awep.Melee == true then
			local wep = ents.Create("murwep_ragdoll_melee")
			wep.Owner = ent

			if IsValid(awep) and awep.RagdollType then
				wep.Weapon = awep
				wep.type = awep.RagdollType
			end

			wep:SetPos(self:GetPos())
			wep:Spawn()
			ent.Weapon = wep
			self:SetNWEntity("RD_Weapon", wep)
		elseif ItemType[awep:GetClass()] then
			local wep = ents.Create("murwep_ragdoll_item")
			wep.Owner = ent

			if IsValid(awep) then
				wep.Weapon = awep
				wep.type = ItemType[awep:GetClass()]
			end

			wep:SetPos(self:GetPos())
			wep:Spawn()
			ent.Weapon = wep
			self:SetNWEntity("RD_Weapon", wep)
		else
			local wep = ents.Create("murwep_ragdoll_weapon")
			wep.Owner = ent

			if IsValid(awep) and awep:GetMaxClip1() > 0 and awep.ArcticTacRP and awep.RagdollType then
				wep.Weapon = awep
				wep.type = awep.RagdollType
			end

			wep:SetPos(self:GetPos())
			wep:Spawn()
			ent.Weapon = wep
			self:SetNWEntity("RD_Weapon", wep)
		end
	end)
end	

function pl:CreateAdvancedRagdoll()
	if IsValid(self:GetRD()) then return end
	local vel = self:GetVelocity()
	local ent = ents.Create("prop_ragdoll")
	ent:TransferModelData(self)
	ent:SetNWVector("RagColor", self:GetPlayerColor())
	ent:Spawn()
	ent.DelayBetweenStruggle = 0
	ent.Moans = 0
	ent.Male = self.Male
	ent.DelayBetweenMoans = 0
	ent.IsDead = false
	ent.isRDRag = true
	ent.Owner = self
	ent.OwnerDead = self
	ent.MaxBlood = 40
	ent.PlyColor = self:GetPlayerColor()
	ent:SetNWString("Name", self:Nick())
	ent:MakePlayerColor(ent.PlyColor)
	ent:ZippyGoreMod3_BecomeGibbableRagdoll(BLOOD_COLOR_RED)
	ent.delta = CurTime()
	ent:SetFlexScale(0.5)
	ent:GetPhysicsObject():Sleep()
	ent:GetPhysicsObject():SetMass(20)
	timer.Simple(0.1, function()
		if !IsValid(ent) or !IsValid(self) then return end
		net.Start("MuR.RD_Cam")
		net.WriteEntity(ent)
		net.Send(self)
	end)
	local function PhysCallback(ent, data)
		if data.Speed > 210 and data.HitEntity:IsPlayer() and IsValid(ent.Owner) and data.HitEntity:GetMoveType() ~= MOVETYPE_NOCLIP then
			data.HitEntity:StartRagdolling()
		end
	end
	ent:AddCallback("PhysicsCollide", PhysCallback)

	TransferBones(self, ent)
	VelocityOnAllBones(ent, vel)
	local awep = self:GetActiveWeapon()

	self:SetNWEntity("RD_Weapon", NULL)
	self:SetNWEntity("RD_Ent", ent)
	self:SetNWEntity("RD_EntCam", ent)
	self:SetFOV(0)
	self:GiveRagdollWeapon(ent, self:GetActiveWeapon())

	return ent
end

function pl:StartRagdolling(moans, dam, gibs)
	if self:GetNWBool("GeroinUsed") then return end
	moans = moans or 0
	dam = dam or 0
	local ent = self:CreateAdvancedRagdoll()
	self:Flashlight(false)
	self.IsRagStanding = self:OnGround()

	if IsValid(ent) then
		ent.Moans = 0
		self:TimeGetUpChange(3 + dam / 2, true)

		if gibs then
			ent:ZippyGoreMod3_DamageRagdoll(gibs)
		end
	end

	return ent
end

function pl:UnconnectRagdoll(died)
	local rag = self:GetRD()

	if IsValid(rag) then
		rag.IsDead = true
		rag.Owner = nil
		self:StopRagdolling(true)
		rag:GrabHand(false, false)
		rag:GrabHand(false, true)

		if died then
			timer.Create("RagdollStruggle"..rag:EntIndex(), math.Rand(0.2,0.6), math.random(16,64), function()
				if !IsValid(rag) then return end
				rag:StruggleBone()
			end)
		end
	end
end

function pl:StopRagdolling(keeprag, playanim)
	local rag = self:GetRD()
	self:SetNWEntity("RD_Ent", NULL)
	self:SetNoDraw(false)
	self:SetNotSolid(false)
	self:DrawShadow(true)
	self:SetPos(self:GetPos() + Vector(0, 0, 32))

	--[[
	if playanim then
		self:Freeze(true)
		self:SelectWeapon("mur_hands")
		local time = self:SetSVAnimation("mur_getup" .. math.random(1, 3), true)

		timer.Simple(time, function()
			if not IsValid(self) then return end
			self:Freeze(false)
		end)
	else
		self:Freeze(false)
		self:SetSVAnimation("")
	end
	]]--

	if not keeprag and IsValid(rag) then
		rag:Remove()
	end
end

-------------------------ENTITY FUNCTIONS------------------------------
function ent:TransferModelData(from)
	local ent1Model = from:GetModel()
	local ent1Skin = from:GetSkin()
	local ent1BodyGroups = from:GetNumBodyGroups()
	self:SetModel(ent1Model)
	self:SetSkin(ent1Skin)

	for i = 0, ent1BodyGroups - 1 do
		self:SetBodygroup(i, from:GetBodygroup(i))
	end
end

function ent:StruggleBone()
	local vel1 = VectorRand(-100, 100)
	local vel2 = VectorRand(-25, 25)

	for i = 0, self:GetPhysicsObjectCount() - 1 do
		local bone = self:GetPhysicsObjectNum(i)

		if IsValid(bone) then
			if math.random(1, 10) == 1 then
				bone:SetVelocity(vel1)
				bone:ApplyTorqueCenter(vel2)
			end
		end
	end
end

function ent:RollBone(inputState, isstanding)
	if IsValid(self.Owner) then
		local ang = self.Owner:EyeAngles()
		local viewForward = ang:Forward()
		local viewRight = ang:Right()
		local viewUp = ang:Up()
		local viewRightFlat = viewForward:Cross(Vector(0, 0, 1))
		local viewForwardYawOnly = (viewForward * Vector(1, 1, 0)):GetNormalized()
		local hasMoveInput = inputState[IN_FORWARD] or inputState[IN_BACK] or inputState[IN_MOVERIGHT] or inputState[IN_MOVELEFT]
		local moveValues = Vector((inputState[IN_MOVERIGHT] and 1 or 0) - (inputState[IN_MOVELEFT] and 1 or 0), (inputState[IN_FORWARD] and 1 or 0) - (inputState[IN_BACK] and 1 or 0), 0)
		local moveInput2d = ((moveValues.y * viewForwardYawOnly) + (moveValues.x * viewRightFlat)):GetNormalized()
		local torque = Vector(-moveInput2d.y, moveInput2d.x, 0) * 30
		local bonerh1 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_R_Hand")))
		local bonelh1 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_L_Hand")))
		local bone1 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Spine")))
		local bone2 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Spine1")))
		local bone3 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Spine2")))
		local bone4 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Spine4")))
		local bone5 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Pelvis")))
		local bone6 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_L_Calf")))
		local bone7 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_R_Calf")))
		local bone8 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Head1")))
		local bonelf = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_L_Foot")))
		local bonerf = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_R_Foot")))

		if (IsValid(self.RightHandGrab) or IsValid(self.LeftHandGrab)) and self.Owner:KeyDown(IN_FORWARD) then
			local torque = self.Owner:GetAimVector() * 30

			if IsValid(self.LeftHandGrab) or IsValid(self.RightHandGrab) then
				local ent = constraint.GetAllConstrainedEntities(game.GetWorld())[self]

				if IsValid(ent) then
					torque = self.Owner:GetAimVector() * 150
				end
			end
			
			bonerh1:ApplyForceCenter(torque * 2.5)
			bonelh1:ApplyForceCenter(torque * 2.5)
			bone3:ApplyForceCenter(torque)
			bone4:ApplyForceCenter(torque)
			bone8:ApplyForceCenter(torque)
		else
			bone1:ApplyTorqueCenter(torque)
			bone2:ApplyTorqueCenter(torque)
			bone3:ApplyTorqueCenter(torque)
			bone4:ApplyTorqueCenter(torque)
			bone5:ApplyTorqueCenter(torque)
			bone6:ApplyTorqueCenter(torque)
			bone7:ApplyTorqueCenter(torque)
		end

		if isstanding then
			local pos1 = MuR:BoneData(self, "ValveBiped.Bip01_Spine4")
			local tr = util.TraceLine({
				start = pos1,
				endpos = pos1 - Vector(0, 0, 999999),
				filter = function(ent) 
					if IsValid(self.Weapon) and ent == self.Weapon or ent == self then
						return false 
					else
						return true
					end
				end,
			})
			local pos2 = tr.HitPos
			local isright = math.floor(CurTime()*2)%2 == 0
			local bone_forward = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_L_Foot")))
			local bone_back = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_R_Foot")))
			if isright then
				bone_forward = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_R_Foot")))
				bone_back = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_L_Foot")))
			end

			local rightcoef = 0
			local forwardcoef = 0
			local mult = 1
			if self.Owner:Health() < 40 then
				mult = 0
			elseif self.Owner:Health() < 60 then
				mult = 0.4
			elseif self.Owner:Health() < 75 then
				mult = 0.7
			end
			if mult == 0 then return end
			if inputState[IN_FORWARD] then
				forwardcoef = 32*mult
			elseif inputState[IN_BACK] then
				forwardcoef = -12*mult
			end

			if inputState[IN_MOVERIGHT] then
				rightcoef = 16*mult
			elseif inputState[IN_MOVELEFT] then
				rightcoef = -16*mult
			end

			local p = {}
			p.secondstoarrive = 0.5
			p.pos = tr.HitPos + self.Owner:GetForward()*forwardcoef + self.Owner:GetRight()*rightcoef + Vector(0, 0, 4*mult)
			p.angle = bone_forward:GetAngles()
			p.maxangular = 670
			p.maxangulardamp = 100
			p.maxspeed = 600
			p.maxspeeddamp = 20
			p.teleportdistance = 0
			p.deltatime = CurTime() - self.delta

			bone_forward:Wake()
			bone_forward:ComputeShadowControl(p)

			p.pos = tr.HitPos - self.Owner:GetForward()*forwardcoef/2 - self.Owner:GetRight()*rightcoef + Vector(0, 0, 4*mult)

			bone_back:Wake()
			bone_back:ComputeShadowControl(p)

			p.maxspeeddamp = 150
			p.secondstoarrive = 0.2
			p.pos = bone3:GetPos() + self.Owner:GetForward()*forwardcoef + self.Owner:GetRight()*rightcoef
			local angs = self.Owner:GetForward():Angle()
			angs:Normalize()
			p.ang = angs

			bone3:Wake()
			bone3:ComputeShadowControl(p)
		end
	end
end

function ent:JumpOutGrab()
	if self.GrabOverTime and self.GrabOverTime > CurTime() then return end
	if self.Owner:GetNWFloat("Stamina") > 30 and self.Owner:Health() > 40 then
		local torque = self.Owner:GetAimVector() * 1500

		if self.Owner.IsRagStanding then
			torque = self.Owner:GetAimVector() * 2000
		end

		if IsValid(constraint.GetAllConstrainedEntities(game.GetWorld())[self]) then
			torque = self.Owner:GetAimVector() * 400
		end

		self.GrabOverTime = CurTime()+1
		self:GrabHand(false, false)
		self:GrabHand(false, true)
		self.Owner:SetNWFloat("Stamina", math.Clamp(self.Owner:GetNWFloat("Stamina") - 30, 0, 100))

		timer.Simple(0.1, function()
			if not IsValid(self) then return end

			for i = 0, self:GetPhysicsObjectCount() - 1 do
				local phys = self:GetPhysicsObjectNum(i)
				phys:ApplyForceCenter(torque)
			end
		end)
	end
end

function ent:StartRagdollAnimation(model, name)
	--[[if name == "" then
		if IsValid(self.ragdollAnimationEnt) then
			self.ragdollAnimationEnt:Remove()
		end
	else
		if IsValid(self.ragdollAnimationEnt) and name != self.ragdollAnimationEnt:GetRagdollAnimation() then
			self.ragdollAnimationEnt:Remove()
		end
		local p = ents.Create("ragdoll_animation")
		p:SetModel(model)
		p:SetPos(self:GetPos()-Vector(0,0,32))
		p:SetAngles(Angle(0,self.Owner:EyeAngles().y,0))
		p:SetRagdollAnimation(name)
		p:SetRagdoll(self)
		p:Spawn()
		self.ragdollAnimationEnt = p
	end]]--
end

function ent:PullHand(type, power)
	if IsValid(self.Owner) then
		local eang = self.Owner:EyeAngles()
		local torque = self.Owner:GetAimVector() * power
		local bonerh1 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_R_Hand")))
		local bonerh2 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_R_Forearm")))
		local bonelh1 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_L_Hand")))
		local bonelh2 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_L_Forearm")))
		local bonec = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Spine")))
		local bones4 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Spine4")))
		local boneh = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Head1")))

		local isgrab = IsValid(constraint.GetAllConstrainedEntities(game.GetWorld())[self])

		if type == "right" then
			local p = {}
			local havewep = IsValid(self.Weapon)
			if havewep then
				p.secondstoarrive = 0.25
				p.pos = boneh:GetPos() + eang:Forward()*25 + eang:Right()*2
				p.angle = self.Owner:GetAimVector():Angle() + Angle(20, 0, 180)
				p.maxangular = 670
				p.maxangulardamp = 250
				p.maxspeed = 600
				p.maxspeeddamp = 50
				p.teleportdistance = 0
				p.deltatime = 0.1
				
				local p = {}
				p.secondstoarrive = 1
				p.pos = boneh:GetPos() + eang:Up()*20
				p.angle = self.Owner:GetAimVector():Angle() + Angle(0, 0, 90)
				p.maxangular = 400
				p.maxangulardamp = 100
				p.maxspeed = 200
				p.maxspeeddamp = 50
				p.teleportdistance = 0
				p.deltatime =  0.1

				boneh:Wake()
				boneh:ComputeShadowControl(p)
			else
				p.secondstoarrive = 0.4
				p.pos = boneh:GetPos() + eang:Forward()*(isgrab and 50 or 30) + eang:Right()*15
				p.angle = self.Owner:GetAimVector():Angle() + Angle(0, 0, 90)
				p.maxangular = 670
				p.maxangulardamp = 100
				p.maxspeed = 600
				p.maxspeeddamp = 50
				p.teleportdistance = 0
				p.deltatime = 0.1
			end

			bonerh1:Wake()
			bonerh1:ComputeShadowControl(p)
			self.delta = CurTime()
		elseif type == "left" then
			local p = {}
			p.secondstoarrive = 0.4
			p.pos = boneh:GetPos() + eang:Forward()*(isgrab and 50 or 30) - eang:Right()*15
			p.angle = self.Owner:GetAimVector():Angle() + Angle(0, 0, 90)
			p.maxangular = 670
			p.maxangulardamp = 100
			p.maxspeed = 600
			p.maxspeeddamp = 50
			p.teleportdistance = 0
			p.deltatime =  0.1

			bonelh1:Wake()
			bonelh1:ComputeShadowControl(p)
			self.delta = CurTime()
		elseif type == "all" then
			if IsValid(self.Weapon) and self.Weapon.data.twohand then
				local p = {}
				p.secondstoarrive = 0.2
				p.pos = boneh:GetPos() + eang:Forward()*30 + eang:Right()*10
				p.angle = self.Owner:GetAimVector():Angle() + Angle(0, 0, 90)
				p.maxangular = 400
				p.maxangulardamp = 200
				p.maxspeed = 100
				p.maxspeeddamp = 100
				p.teleportdistance = 0
				p.deltatime =  0.1

				bonelh1:Wake()
				bonelh1:ComputeShadowControl(p)

				p.pos = boneh:GetPos() + eang:Forward()*8 + eang:Right()*8
				p.angle = self.Owner:GetAimVector():Angle() + Angle(0, 0, 90)

				bonerh1:Wake()
				bonerh1:ComputeShadowControl(p)
				
				self.delta = CurTime()
			elseif IsValid(self.Weapon) and !self.Weapon.data.twohand then
				local p = {}
				p.secondstoarrive = 0.6
				p.pos = boneh:GetPos()  + eang:Forward()*(isgrab and 50 or 30) - eang:Right()*15
				p.angle = self.Owner:GetAimVector():Angle() + Angle(0, 0, 90)
				p.maxangular = 400
				p.maxangulardamp = 100
				p.maxspeed = 200
				p.maxspeeddamp = 50
				p.teleportdistance = 0
				p.deltatime = 0.1

				bonelh1:Wake()
				bonelh1:ComputeShadowControl(p)

				p.pos = boneh:GetPos()  + eang:Forward()*(isgrab and 50 or 30) + eang:Right()*15
				p.secondstoarrive = 0.25
				p.pos = boneh:GetPos() + eang:Forward()*30 + eang:Right()*5
				p.angle = self.Owner:GetAimVector():Angle() + Angle(20, 0, 180)
				p.maxangular = 670
				p.maxangulardamp = 250
				p.maxspeed = 600
				p.maxspeeddamp = 50
				p.teleportdistance = 0
				p.deltatime = 0.1
				bonerh1:Wake()
				bonerh1:ComputeShadowControl(p)
				self.delta = CurTime()
			else
				local p = {}
				p.secondstoarrive = 0.5
				p.pos = boneh:GetPos()  + eang:Forward()*(isgrab and 50 or 30) - eang:Right()*15
				p.angle = self.Owner:GetAimVector():Angle() + Angle(0, 0, 90)
				p.maxangular = 400
				p.maxangulardamp = 100
				p.maxspeed = 200
				p.maxspeeddamp = 50
				p.teleportdistance = 0
				p.deltatime = 0.1

				bonelh1:Wake()
				bonelh1:ComputeShadowControl(p)
				p.pos = boneh:GetPos()  + eang:Forward()*(isgrab and 50 or 30) + eang:Right()*15
				bonerh1:Wake()
				bonerh1:ComputeShadowControl(p)
				self.delta = CurTime()
			end
		end
	end
end

function ent:FireHand(reload)
	if IsValid(self.Owner) then
		local recoil = self.Weapon.Weapon.Recoil
		if not recoil then
			recoil = 1
		end
		local torque = self.Weapon:GetUp() * (500 * recoil)
		local bone1 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_R_Hand")))
		local bone2 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_R_Forearm")))

		if self.Weapon.data.twohand then
			bone1 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_L_Hand")))
			bone2 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_L_Forearm")))
		end

		if reload then
			local bones = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Spine4")))
			torque = (bones:GetPos() - bone1:GetPos()):GetNormalized() * 1000
		end

		bone1:ApplyForceCenter(torque)
		bone2:ApplyForceCenter(torque)
	end
end

function ent:GetUpToStandPos()
	if IsValid(self.Owner) then
		local he = 74
		if self.Owner:Health() < 10 then
			he = 48
		elseif self.Owner:Health() < 20 then
			he = 56
		elseif self.Owner:Health() < 50 then
			he = 64
		end
		if he > 48 and IsValid(self.Weapon) and self.Weapon:GetClass() == "murwep_ragdoll_melee" and self.Owner:KeyDown(IN_DUCK) then
			he = 48
		end
		local pos1 = MuR:BoneData(self, "ValveBiped.Bip01_Spine4")
		local tr = util.TraceLine({
			start = pos1,
			endpos = pos1 - Vector(0, 0, 999999),
			mask = MASK_PLAYERSOLID,
			filter = function(e) 
				if IsValid(self.Weapon) and e == self.Weapon or e == self then 
					return false 
				else
					return true
				end 
			end,
		})
		local pos2 = tr.HitPos
		local eang = self.Owner:EyeAngles()
		local bones1 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Pelvis")))
		local bones2 = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Spine4")))
		local boneh = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_Head1")))
		local p = {}
		p.secondstoarrive = 0.1
		p.pos = pos2+Vector(0,0,he)
		p.angle = self.Owner:GetAimVector():Angle()
		p.maxangular = 400
		p.maxangulardamp = 10
		p.maxspeed = 200
		p.maxspeeddamp = 50
		p.teleportdistance = 0
		p.deltatime = CurTime() - self.delta

		boneh:Wake()
		boneh:ComputeShadowControl(p)

		p.pos = bones1:GetPos() + self.Owner:GetForward() + self.Owner:GetRight()/2
		local angs = self.Owner:GetForward():Angle()
		angs:Normalize()
		p.ang = angs
		p.secondstoarrive = 0.05

		bones1:Wake()
		bones1:ComputeShadowControl(p)
		p.pos = bones2:GetPos() + self.Owner:GetForward() + self.Owner:GetRight()/2
		bones2:Wake()
		bones2:ComputeShadowControl(p)
	end
end

local function FindClosestEntity(pos, filter, allowWorld, directionBias, ent)
	local radius = 10
	if not filter then
		filter = function(e)
			if IsValid(ent.Weapon) and e == ent.Weapon or e == ent then 
				return false 
			else
				return true
			end 
		end
	end

	local trace = {
		start = pos + directionBias * radius / 2,
		endpos = pos + directionBias * radius / 2,
		mins = Vector(-radius / 2, -radius / 2, -radius / 2),
		maxs = Vector(radius / 2, radius / 2, radius / 2),
		filter = filter,
		mask = MASK_SHOT,
		ignoreworld = not allowWorld
	}

	local res = util.TraceHull(trace)
	if not res or not res.Hit or not res.Entity then return end

	return res.Entity, res.PhysicsBone, res.Entity:GetPhysicsObjectNum(res.PhysicsBone)
end

function ent:Initialize()
    self:SetNWBool("LeftHandIcon", false)
    self:SetNWBool("RightHandIcon", false)
end

function ent:GrabHand(bool, isright)
	if isright then
		if bool and not IsValid(self.RightHandGrab) then
			local limbBone = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_R_Hand")))
			local prop, physObjId, physObj = FindClosestEntity(limbBone:GetPos(), nil, true, limbBone:GetVelocity():GetNormalized(), self)
			if not prop or ((not IsValid(prop) or not IsValid(physObj)) and not prop:IsWorld()) then print("[Server] No valid prop found for right hand grab.") return end
      
			local weld = constraint.Weld(self, prop, self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_R_Hand")), physObjId, 5000, false, false)
			self.RightHandGrab = weld
			self:SetNWBool("RightHandIcon", true) -- Sync to client
			print("[Server] Right hand grab activated.")
			self:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 7) .. ".wav", 50, 110, 1.5)
		elseif not bool and IsValid(self.RightHandGrab) then
			self.RightHandGrab:Remove()
			self:SetNWBool("RightHandIcon", false) -- Sync to client
			print("[Server] Right hand grab released.")
			self:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 7) .. ".wav", 50, 70, 1.5)
		end
	else
		if bool and not IsValid(self.LeftHandGrab) then
			local limbBone = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_L_Hand")))
			local prop, physObjId, physObj = FindClosestEntity(limbBone:GetPos(), nil, true, limbBone:GetVelocity():GetNormalized(), self)
			if not prop or ((not IsValid(prop) or not IsValid(physObj)) and not prop:IsWorld()) then print("[Server] No valid prop found for left hand grab.") return false end
			local weld = constraint.Weld(self, prop, self:TranslateBoneToPhysBone(self:LookupBone("ValveBiped.Bip01_L_Hand")), physObjId, 5000, false, false)
			self.LeftHandGrab = weld
			self:SetNWBool("LeftHandIcon", true) -- Sync to client
			print("[Server] Left hand grab activated.")
			self:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 7) .. ".wav", 50, 110)
		elseif not bool and IsValid(self.LeftHandGrab) then
			self.LeftHandGrab:Remove()
			self:SetNWBool("LeftHandIcon", false) -- Sync to client
			print("[Server] Left hand grab released.")
			self:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 7) .. ".wav", 50, 70)
		end
	end
end

function ent:GiveDamageOnRag(dmg)
	local att = dmg:GetAttacker()
	local dm = dmg:GetDamage()
	local pos = dmg:GetDamagePosition()
	local dt = dmg:GetDamageType()
	local dir = dmg:GetDamageForce()
	local bonename = self:GetNearestBoneFromPos(pos, dir)
	local bonetype = GetCorrectTypeOfBone(bonename)
	if att == self or att:IsPlayer() and !IsValid(att:GetRD()) and dt == 1 or att:GetClass() == "prop_ragdoll" and att == self or string.match(att:GetClass(), "murwep_ragdoll_") and dm < 50 or dt == 1 and dm <= 10 then
		dm = 0
	end

	if dmg:IsExplosionDamage() then
		dm = dmg:GetDamage() * 2
	elseif att:IsWorld() or string.match(att:GetClass(), "prop_") and dt == DMG_CRUSH then
		dm = dmg:GetDamage() * 0.2

		if dm < 10 then
			dm = 0
		end
	end

	if bonetype == "r_hand" or bonetype == "l_hand" then
		dm = dm * 0.4
	elseif bonetype == "r_leg" or bonetype == "l_leg" then
		dm = dm * 0.6
	elseif bonetype == "torso" then
		dm = dm * 1
	elseif bonetype == "head" then
		dm = dm * 4
	end

	if dm > 5 and self.MaxBlood > 0 then
		self.MaxBlood = self.MaxBlood - 1
		MuR:CreateBloodPool(self, self:LookupBone(bonename), 1, 0)
	end

	local ply = self.Owner

	if IsValid(ply) and ply:Alive() and dm > 0 then
		self:TakeImpact(dm, bonename, dir)
		dmg:SetDamage(dm)
		ply:TakeDamageInfo(dmg)
		ply:TimeGetUpChange(dm / 6)
	end
end

function ent:TakeImpact(dm, bonename, dir)
	local normal = dir:GetNormalized()*dm*50
	local bone = self:GetPhysicsObjectNum(self:TranslateBoneToPhysBone(self:LookupBone(bonename)))
	local standing = self.Owner.IsRagStanding
	bone:ApplyForceCenter(normal)

	
	if standing then
		timer.Simple(math.Rand(0.01, 0.4), function()
			if !IsValid(self) or !IsValid(self.Owner) then return end
			self.Owner.IsRagStanding = true
		end)
	end
	
end

function ent:GetNearestBoneFromPos(pos, dir)
	dir = dir:GetNormalized()
	dir:Mul(1024 * 8)

	local tr = {}
	tr.start = pos
	tr.endpos = pos + dir
	tr.filter = function(ent)
		return ent == self
	end
	tr.ignoreworld = true

	local result = util.TraceLine(tr)
	if result.Entity ~= self then
		tr.endpos = pos - dir

		local result = util.TraceLine(tr)
		local pb = result.PhysicsBone

		pb = self:GetBoneName(self:TranslatePhysBoneToBone(pb))
		return pb
	else
		local pb = result.PhysicsBone

		pb = self:GetBoneName(self:TranslatePhysBoneToBone(pb))
		return pb
	end
end

function ent:MakeEffects(ply)
	local dmg = ply.LastDamageInfo
	if not dmg then return end
	local type = dmg[1]
	local boneid = self:LookupBone(self:GetNearestBoneFromPos(dmg[2], dmg[4]))
	local eff = 0
	local name = GetCorrectTypeOfBone(boneid)

	if ply:GetNWFloat("BleedLevel") > 1 then
		eff = 2
	end

	if type == DMG_FALL or type == DMG_CLUB or type == DMG_CRUSH then
		eff = -1
	end

	if type == DMG_SLASH or dmg[3] then
		eff = 2
	end

	if eff >= 0 then
		MuR:CreateBloodPool(self, boneid, eff, 1)
	end
end

------------------------HOOKS-----------------------------------

hook.Add("PlayerSwitchWeapon", "MuR_ChangeWeaponInRagdoll", function(ply, oldwep, wep)
	if (MuR.Gamemode == 5 or MuR.Gamemode == 11 or MuR.Gamemode == 12 or MuR.Gamemode == 13) and MuR.TimeCount + 22 > CurTime() or ply:GetNWString("Class") == "Zombie" and IsValid(wep) and wep:GetClass() != "mur_zombie" then
		return true
	end
	local rag = ply:GetRD()
	if IsValid(rag) then
		ply:GiveRagdollWeapon(rag, wep)
	end
end)

hook.Add("InitPostEntity", "MuR.Init", function()
	function pl:CreateRagdoll()
	end

	function pl:GetRagdollEntity()
		return self:GetRD()
	end
end)

hook.Add("Think", "MuR.RagdollDamage", function(ply)
	for _, ply in ipairs(player.GetAll()) do
		local rag = ply:GetRD()

		if IsValid(rag) and ply:Alive() then

			for key, isHeld in pairs(grabKeysHeld) do
                if isHeld then
                    rag:GrabHand(true, key == KEY_LALT) -- Keep grabbing while key is held
                end
            end

			ply:SetNoDraw(true)
			ply:SetNotSolid(true)
			ply:DrawShadow(false)
			ply:SetActiveWeapon(nil)
			local pos = rag:GetAttachment(rag:LookupAttachment("eyes")).Pos - Vector(0, 0, 56)
			local tr = util.TraceLine( {
				start = rag:GetAttachment(rag:LookupAttachment("eyes")).Pos,
				endpos = rag:GetAttachment(rag:LookupAttachment("eyes")).Pos - Vector(0, 0, 100),
				filter = {rag, ply, rag.Weapon},
				mask = MASK_SHOT
			})
			if tr.HitPos:DistToSqr(pos) > 1000 then
				pos = rag:GetPos()
			end
			ply:SetPos(pos)
			ply:SetVelocity(-ply:GetVelocity())
			ply:SetNWEntity("RD_EntCam", rag)
			--ply:SetSVAnimation("rd_getup1")
			ply:ExitVehicle()

			local posh = MuR:BoneData(rag, "ValveBiped.Bip01_Pelvis")

			if ply:KeyDown(IN_ATTACK) and ply:KeyDown(IN_ATTACK2) then
				rag:PullHand("all", 120)
			elseif ply:KeyDown(IN_ATTACK) then
				rag:PullHand("left", 120)
			elseif ply:KeyDown(IN_ATTACK2) then
				rag:PullHand("right", 120)
			end

			local wep = rag.Weapon

			if IsValid(wep) then
				wep:Shoot(ply:KeyDown(IN_DUCK))

				if ply:KeyDown(IN_RELOAD) then
					wep:Reload()
				end
			end

			local hpos = MuR:BoneData(rag, "ValveBiped.Bip01_Spine4")
			local standing = ply.IsRagStanding
			if MuR:CheckHeight(rag, hpos) > 120 or rag.Gibbed then
				ply.IsRagStanding = false
			end
			if standing then
				rag:GetUpToStandPos()
			end

			if ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) then
				local tab = {
					[IN_MOVELEFT] = ply:KeyDown(IN_MOVELEFT),
					[IN_MOVERIGHT] = ply:KeyDown(IN_MOVERIGHT),
					[IN_FORWARD] = ply:KeyDown(IN_FORWARD),
					[IN_BACK] = ply:KeyDown(IN_BACK),
				}

				rag:RollBone(tab, standing)
			end
		end
	end

	for _, rag in ipairs(ents.FindByClass("prop_ragdoll")) do
		if rag.isRDRag then
			if not rag.IsDead and rag.Moans > 0 and rag.DelayBetweenMoans < CurTime() then
				rag.Moans = rag.Moans - 1
				rag.DelayBetweenMoans = CurTime() + 6

				if rag.Male then
					rag:EmitSound("vo/npc/male01/moan0" .. math.random(1, 5) .. ".wav", 60)
				else
					rag:EmitSound("vo/npc/female01/moan0" .. math.random(1, 5) .. ".wav", 60)
				end
			end

			if rag.Moans > 0 and not rag.IsDead and rag.DelayBetweenStruggle < CurTime() then
				rag.DelayBetweenStruggle = CurTime() + math.Rand(0.1, 1)
				rag:StruggleBone()
			end
		end
	end
end)

hook.Add("PlayerSpawn", "MuR.RagdollDamage", function(ply)
	local rag = ply:GetRD()

	if IsValid(rag) then
		rag:Remove()
	end

	ply:SetNWEntity("RD_EntCam", NULL)
end)

hook.Add("PlayerDeath", "MuR.RagdollDamage", function(ply)
	local rag = ply:GetRD()

	if ply.LastDamageInfo then
		local type = ply.LastDamageInfo[1]
		if type == DMG_CLUB or type == DMG_CRUSH then
			ply:PlayVoiceLine("death_blunt", true)
		else
			ply:PlayVoiceLine("death_default", true)
		end
	end

	if IsValid(rag) then
		rag.Inventory = {}

		for _, wep in ipairs(ply:GetWeapons()) do
			if wep.CantDrop then continue end
			ply:DropWeapon(wep)
			wep:SetPos(wep:GetPos() + VectorRand(-12, 12))
			wep:SetNoDraw(true)
			wep:SetNotSolid(true)
			table.insert(rag.Inventory, wep)
			local phys = wep:GetPhysicsObject()

			if IsValid(phys) then
				phys:EnableMotion(false)
			end
		end

		rag:MakeEffects(ply)
		ply:UnconnectRagdoll(true)
		local rag_old = ply:GetRagdollEntity()

		if IsValid(rag_old) then
			rag_old:Remove()
		end
	else
		local rag = ply:CreateAdvancedRagdoll()
		rag:MakeEffects(ply)
		ply:UnconnectRagdoll(true)
	end
end)

hook.Add("EntityTakeDamage", "MuR.RagdollDamage", function(ent, dmg)
	local dt = dmg:GetDamageType()
	local att = dmg:GetAttacker()

	if ent.isRDRag then
		ent:GiveDamageOnRag(dmg)
	end

	if ent:IsPlayer() and IsValid(ent:GetRD()) then
		ent:TimeGetUpChange(dmg:GetDamage() / 6)
	end

	if ent:IsPlayer() and ent:Alive() then
		local dm = dmg:GetDamage()

		if dm >= 10 and ent:Armor() <= 0 then
			local chance = math.random(1, 100)

			if (chance <= 15 or dm >= 50 or ent:Health() <= 50 and chance <= 30) and ent:GetNWString("SVAnim") != "mur_surrender" then
				local rag = ent:StartRagdolling(dm / 25, dm / 5, dmg)
			end
		end

		if dm >= 10 then
			if dt == DMG_CLUB or att:IsWorld() or string.match(att:GetClass(), "prop_") then
				ent:PlayVoiceLine("death_blunt")
			else
				ent:PlayVoiceLine("death_default")
			end
		end
	end
end)

hook.Add("PlayerButtonDown", "Murdered_Ragdolling_GrabHold", function(ply, but)
    local rag = ply:GetRD()
    if IsValid(rag) and ply:Alive() then
		if but == KEY_LSHIFT or but == KEY_LALT then
   		    grabKeysHeld[but] = true
      		rag:GrabHand(true, but == KEY_LALT) -- true = grab, isright = KEY_LALT
			
		end
    end
end)

hook.Add("PlayerButtonUp", "Murdered_Ragdolling_GrabRelease", function(ply, but)
    local rag = ply:GetRD()
    if IsValid(rag) and ply:Alive() then
		if but == KEY_LSHIFT or but == KEY_LALT then
        	grabKeysHeld[but] = false
        	rag:GrabHand(false, but == KEY_LALT) -- false = release, isright = KEY_LALT
        end
    end
end)

hook.Add("PlayerButtonDown", "Murdered_Ragdolling", function(ply, but)
	local rag = ply:GetRD()

	if IsValid(rag) and ply:Alive() then
		if but == KEY_SPACE then
			rag:JumpOutGrab()
		elseif but == KEY_C then
			local pos = MuR:BoneData(rag, "ValveBiped.Bip01_Pelvis")

			if ply:TimeGetUp(true) and MuR:CheckHeight(rag, pos) < 72 and ply:CanGetUp() and not rag.Gibbed then
				if MuR:CheckHeight(rag, pos) < 24 then
					ply:StopRagdolling(false, true)
				else
					ply:StopRagdolling(false)
				end
			end
		elseif but == KEY_F then
			if not ply.IsRagStanding then
				ply.IsRagStanding = false
			end
			ply.IsRagStanding = !ply.IsRagStanding
		end
	end
end)

hook.Add("PlayerSwitchFlashlight", "MuR_BlockFlashLight", function(ply, enabled)
	if enabled and IsValid(ply:GetRD()) then return end
end)
