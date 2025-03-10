if CLIENT then
	net.Receive("ZippyGore3_OnGibEffect", function()
		local data = net.ReadTable()
		local effectdata = EffectData()
		effectdata:SetFlags(data.blood_color or -1)
		effectdata:SetOrigin(data.pos_min)
		effectdata:SetStart(data.pos_max)
		util.Effect("mur_ongib", effectdata)
	end)

	net.Receive("ZippyGore3_OnGib_BloodGush", function()
		local data = net.ReadTable()
		local effectdata = EffectData()
		effectdata:SetEntity(data.ent)
		effectdata:SetAttachment(data.bone)
		util.Effect("mur_blood_gush", effectdata)
	end)
else
	util.AddNetworkString("ZippyGore3_OnGibEffect")
	util.AddNetworkString("ZippyGore3_OnGib_BloodGush")
end

if SERVER then
	hook.Add("Think", "ZippyGore3_ForcePhysbonePositions_Think", function()
		for _, rag in ipairs(ZGM3_RAGDOLLS) do
			if rag.ZippyGoreMod3_GibbedPhysBoneParents then
				rag:ZippyGoreMod3_ForcePhysBonePos()
			end
		end
	end)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if not SERVER then return end
local ENT = FindMetaTable("Entity")

local blood_particles = {
	[BLOOD_COLOR_RED] = ZGM3_INSANE_BLOOD_EFFECTS and "blood_stream_goop_large" or "blood_impact_red_01_goop",
	[BLOOD_COLOR_ANTLION] = "blood_impact_yellow_01",
	[BLOOD_COLOR_ANTLION_WORKER] = "blood_impact_yellow_01",
	[BLOOD_COLOR_GREEN] = "blood_impact_yellow_01",
	[BLOOD_COLOR_ZOMBIE] = "blood_impact_yellow_01",
	[BLOOD_COLOR_YELLOW] = "blood_impact_yellow_01",
	[BLOOD_COLOR_ZGM3SYNTH] = "blood_impact_synth_01",
}

local blood_decals = {
	[BLOOD_COLOR_RED] = "Blood",
	[BLOOD_COLOR_ANTLION] = "YellowBlood",
	[BLOOD_COLOR_ANTLION_WORKER] = "YellowBlood",
	[BLOOD_COLOR_GREEN] = "YellowBlood",
	[BLOOD_COLOR_ZOMBIE] = "YellowBlood",
	[BLOOD_COLOR_YELLOW] = "YellowBlood",
}

local bleed_timer_name = "ZippyGore3_LimbBleedEffectTimer"

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZippyGoreMod3_BleedEffect(phys_bone)
	if not ZGM3_CVARS["zippygore3_bleed_effect"] then return end
	local timer_name_real = bleed_timer_name .. self:EntIndex() .. "_Bone: " .. phys_bone
	local delayMult = self.ZippyGoreMod3_BloodColor == BLOOD_COLOR_ZGM3SYNTH and 3 or 1 -- Make synth blood less intense.

	timer.Create(timer_name_real, math.Rand(0.1, 0.4) * delayMult, math.random(12, 16) / delayMult, function()
		local effect_pos = IsValid(self) and self:GetBonePosition(self:TranslatePhysBoneToBone(phys_bone))

		if not IsValid(self) or not effect_pos then
			timer.Remove(timer_name_real)

			return
		end

		local particleName = blood_particles[self.ZippyGoreMod3_BloodColor]

		if not particleName then
			timer.Remove(timer_name_real)

			return
		end

		ParticleEffect(particleName, effect_pos, AngleRand())

		if blood_decals[self.ZippyGoreMod3_BloodColor] and timer.RepsLeft(timer_name_real) == 0 then
			local tr = util.TraceLine({
				start = effect_pos + Vector(0, 0, 10),
				endpos = effect_pos - Vector(0, 0, 50),
				filter = self,
			})

			local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(VectorRand(-1,1))
			effectdata:SetMagnitude(1)
			effectdata:SetRadius(16)
			effectdata:SetEntity(self)
			util.Effect("mur_blood_splatter_effect", effectdata, true, true )
		end
	end)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZippyGoreMod3_ForcePhysBonePos()
	for phys_bone, parent_physbone in pairs(self.ZippyGoreMod3_GibbedPhysBoneParents) do
		local gibbed_physobj = self:GetPhysicsObjectNum(phys_bone)
		local parent_physobj = self:GetPhysicsObjectNum(parent_physbone)
		gibbed_physobj:SetPos(parent_physobj:GetPos())
		gibbed_physobj:SetAngles(parent_physobj:GetAngles())
		--gibbed_physobj:SetVelocity( Vector(0, 0, 0) )
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZippyGoreMod3_CreateLimbRagdoll(SeveredPhysBone, damageData)
	-- Create the ragdoll:
	local limb_ragdoll = ents.Create("prop_ragdoll")
	limb_ragdoll:SetPos(self:GetPos())
	limb_ragdoll:SetAngles(self:GetAngles())
	limb_ragdoll:SetModel(self:GetModel())
	limb_ragdoll:DrawShadow(false)
	limb_ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	limb_ragdoll:Spawn()
	limb_ragdoll:ZippyGoreMod3_BecomeGibbableRagdoll(self.ZippyGoreMod3_BloodColor)
	limb_ragdoll:ZippyGoreMod3_BleedEffect(SeveredPhysBone)
	limb_ragdoll.ZippyGoreMod3_GibbedPhysBones = {}
	--limb_ragdoll.ZippyGoreMod3_FakeRootBone = SeveredPhysBone
	limb_ragdoll.ZippyGoreMod3_Ragdoll = false -- Disable gibbing limb ragdoll.

	-- Give limb realistic blood if insane blood effects addon is active.
	if ZGM3_INSANE_BLOOD_EFFECTS and self.ZippyGoreMod3_BloodColor == BLOOD_COLOR_RED then
		limb_ragdoll:RealisticBlood_Setup()
	end

	local severedBone = limb_ragdoll:TranslatePhysBoneToBone(SeveredPhysBone)

	-- Position it:
	for i = 0, limb_ragdoll:GetPhysicsObjectCount() - 1 do
		local phys_obj = limb_ragdoll:GetPhysicsObjectNum(i)
		phys_obj:SetPos(self:GetPhysicsObjectNum(i):GetPos())
		phys_obj:SetAngles(self:GetPhysicsObjectNum(i):GetAngles())
	end

	-- Get all child bones of the bone that was dismembered:
	local child_bones = {}

	local function get_all_child_bones_recursive(bone)
		for _, v in ipairs(limb_ragdoll:GetChildBones(bone)) do
			if not self.ZippyGoreMod3_GibbedPhysBones[self:TranslateBoneToPhysBone(v)] then
				child_bones[v] = true
				get_all_child_bones_recursive(v)
			end
		end
	end

	get_all_child_bones_recursive(severedBone)
	-- Get all parent bones of the bone that was dismembered:
	local parent_bones = {}

	local function get_all_parent_bones_recursive(bone)
		local parent_bone = limb_ragdoll:GetBoneParent(bone)
		parent_bones[parent_bone] = true

		if parent_bone ~= 0 then
			get_all_parent_bones_recursive(parent_bone)
		end
	end

	get_all_parent_bones_recursive(severedBone)

	-- Remove all bones that are not supposed to be there:
	local function remove_bone(bone)
		limb_ragdoll:ManipulateBoneScale(bone, Vector(0, 0, 0))
		limb_ragdoll:ManipulateBonePosition(bone, Vector(0, 0, 0) / 0) -- Thanks Rama (only works on certain graphics cards!)
		self:TakeDamage(999999)
		local phys_bone = limb_ragdoll:TranslateBoneToPhysBone(bone)

		if not limb_ragdoll.ZippyGoreMod3_GibbedPhysBones[phys_bone] then
			local phys_bone_bone_translated = limb_ragdoll:TranslatePhysBoneToBone(phys_bone)

			if not child_bones[phys_bone_bone_translated] and phys_bone_bone_translated ~= severedBone then
				-- Nocollide physbone and make it light:
				local phys_obj = limb_ragdoll:GetPhysicsObjectNum(phys_bone)
				phys_obj:EnableCollisions(false)
				phys_obj:SetMass(0.1)

				-- Remove physbone's constraint and continuously force the bone to be positioned at the rootbone:
				if not limb_ragdoll.ZippyGoreMod3_GibbedPhysBoneParents then
					limb_ragdoll.ZippyGoreMod3_GibbedPhysBoneParents = {}
				end

				if not parent_bones[phys_bone_bone_translated] then
					limb_ragdoll.ZippyGoreMod3_GibbedPhysBoneParents[phys_bone] = 0
					limb_ragdoll:RemoveInternalConstraint(phys_bone) -- Thanks Rama
				end
			end

			limb_ragdoll.ZippyGoreMod3_GibbedPhysBones[phys_bone] = true
		end
	end

	for i = 0, limb_ragdoll:GetBoneCount() - 1 do
		if i ~= severedBone and not child_bones[i] then
			remove_bone(i)
		end
	end

	-- Visual fix attempt:
	for parent_bone in pairs(parent_bones) do
		local parent_physbone = limb_ragdoll:TranslateBoneToPhysBone(parent_bone)
		limb_ragdoll.ZippyGoreMod3_GibbedPhysBoneParents[parent_physbone] = SeveredPhysBone
	end

	-- Remove contraint:
	limb_ragdoll:RemoveInternalConstraint(SeveredPhysBone) -- Thanks Rama
	-- Push limb:
	gibbed_physobj = limb_ragdoll:GetPhysicsObjectNum(SeveredPhysBone)
	gibbed_physobj:SetVelocity(damageData.ForceVec:GetNormalized() * damageData.Damage)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZippyGoreMod3_BreakPhysBone(phys_bone_idx, data)
	local gibbed_bone = self:TranslatePhysBoneToBone(phys_bone_idx)

	local function gib_bone_recursive(bone, dismember, MakeLimbRag)
		self:ManipulateBoneScale(bone, Vector(0, 0, 0))
		-- Remove bleed effects that shouldn't exist anymore:
		local timer_name_real = bleed_timer_name .. self:EntIndex() .. "_Bone: " .. phys_bone_idx

		if timer.Exists(timer_name_real) then
			timer.Remove(timer_name_real)
		end

		local phys_bone = self:TranslateBoneToPhysBone(bone)

		if phys_bone ~= -1 then
			if not self.ZippyGoreMod3_GibbedPhysBones then
				self.ZippyGoreMod3_GibbedPhysBones = {}
			end

			if not self.ZippyGoreMod3_GibbedPhysBones[phys_bone] then
				local phys_obj = self:GetPhysicsObjectNum(phys_bone)

				if phys_obj then
					-- Nocollide physbone:
					phys_obj:EnableCollisions(false)

					-- Remove physbone's constraint and continuously force the bone to be positioned at its parent bone:
					if not self.ZippyGoreMod3_GibbedPhysBoneParents then
						self.ZippyGoreMod3_GibbedPhysBoneParents = {}
					end

					-- Don't do it for the rootbone:
					if phys_bone ~= 0 then
						self.ZippyGoreMod3_GibbedPhysBoneParents[phys_bone] = self:TranslateBoneToPhysBone(self:GetBoneParent(bone))
						self:RemoveInternalConstraint(phys_bone) -- Thanks Rama
					end

					-- Unspagettify (old method) (thanks Rama):
					-- self:SetSaveValue( "m_ragdoll.list["..phys_bone.."].parentIndex", self:TranslateBoneToPhysBone(self:GetBoneParent( bone )) )
					-- self:SetSaveValue( "m_ragdoll.list["..phys_bone.."].originParentSpace", Vector(0,0,0) )
					-- Gibs/Create limb ragdoll: --------------------------------------------------------------------------
					local damageData = {
						Damage = data.damage,
						ForceVec = data.forceVec,
					}

					if dismember then
						if MakeLimbRag and phys_bone ~= 0 then
							self:ZippyGoreMod3_CreateGibs(phys_bone, damageData)
						elseif phys_bone == 0 then
							self:ZippyGoreMod3_CreateGibs(phys_bone, damageData)
						end
					else
						self:ZippyGoreMod3_CreateGibs(phys_bone, damageData)
					end

					MuR:CreateBloodPool(self, self:TranslatePhysBoneToBone(phys_bone), 3, 0)
					timer.Remove("RagdollStruggle"..self:EntIndex())

					if IsValid(self:GetOwner()) and self.isRDRag and sefl:GetOwner():IsPlayer() then
						for i = 1, math.random(2,3) do
							self:GetOwner():DamagePlayerSystem("blood")
						end
						if self:GetBoneName(bone) == "ValveBiped.Bip01_Head1" then
							self:GetOwner():Kill()
						end
						self.Gibbed = true
						self:GetOwner():TimeGetUpChange(99999, true)
						if isstring(self:GetOwner().LastVoiceLine) then
							self:GetOwner():StopSound(self:GetOwner().LastVoiceLine)
						end
					end

					--------------------------------------------------------------------------=#
					-- Effect --------------------------------------------------------------------------
					local physObjPos = phys_obj:GetPos()
					local aabb_min, aabb_max = phys_obj:GetAABB()
					net.Start("ZippyGore3_OnGibEffect")

					net.WriteTable({
						blood_color = self.ZippyGoreMod3_BloodColor,
						pos_min = physObjPos + aabb_min,
						pos_max = physObjPos + aabb_max
					})

					net.SendPVS(physObjPos)

					-- net.Start("ZippyGore3_OnGib_BloodGush")
					-- net.WriteTable({
					--	 ent = self,
					--	 bone = bone,
					-- })
					-- net.SendPVS(physObjPos)
					--------------------------------------------------------------------------=#
					-- Sounds --------------------------------------------------------------------------
					if bone == 0 then
						self:EmitSound("ZippyGore3OnRootBoneGib")
					else
						self:EmitSound("ZippyGore3OnGib")
					end

					--------------------------------------------------------------------------=#
					self.ZippyGoreMod3_GibbedPhysBones[phys_bone] = true
				end
			end

			for _, v in ipairs(self:GetChildBones(bone)) do
				gib_bone_recursive(v, dismember, phys_bone == 0)
			end
		end
	end

	-- Gib the bone along with all its children:
	gib_bone_recursive(gibbed_bone, data.dismember, true)

	if phys_bone_idx == 0 then
		-- Remove ragdoll if root bone is gibbed:
		self:Remove()
	elseif blood_particles[self.ZippyGoreMod3_BloodColor] then
		-- Otherwise do a bleeding effect from the severed part:
		self:ZippyGoreMod3_BleedEffect(phys_bone_idx)
	end

	-- Developer print thingy:
	if ZGM3_CVARS["zippygore3_print_gibbed_bone"] then
		PrintMessage(HUD_PRINTCENTER, self:GetBoneName(gibbed_bone))
		PrintMessage(HUD_PRINTTALK, self:GetBoneName(gibbed_bone))
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------