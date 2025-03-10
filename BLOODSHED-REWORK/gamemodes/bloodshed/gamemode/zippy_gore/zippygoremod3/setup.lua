local ENT = FindMetaTable("Entity")
ZGM3_RAGDOLLS = {}

local vj_red_blood_decals = {
	["Blood"] = BLOOD_COLOR_RED,
	["VJ_Blood_Red"] = BLOOD_COLOR_RED,
	["VJ_L4D_Blood"] = BLOOD_COLOR_RED,
	["VJ_LNR_Blood_Red"] = BLOOD_COLOR_RED,
	["VJ_Manhunt_Blood_Red"] = BLOOD_COLOR_RED,
	["VJ_Manhunt_Blood_DarkRed"] = BLOOD_COLOR_RED,
	["VJ_Green_Blood"] = BLOOD_COLOR_RED, -- For Crunchy!!
	["VJ_Infected_Blood"] = BLOOD_COLOR_RED, -- For Crunchy!!
	["YellowBlood"] = BLOOD_COLOR_YELLOW,
	["VJ_Blood_Yellow"] = BLOOD_COLOR_YELLOW,
	["VJ_Blood_White"] = BLOOD_COLOR_ZGM3SYNTH,
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZippyGoreMod3_GetEngineBloodFromVJBlood()
	return self.IsVJBaseSNPC and self.CustomBlood_Decal and self.CustomBlood_Decal[1] and vj_red_blood_decals[self.CustomBlood_Decal[1]]
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:ZippyGoreMod3_BecomeGibbableRagdoll(blood_color)
	-- Mark as ragdoll that can be gibbed:
	self.ZippyGoreMod3_Ragdoll = true
	table.insert(ZGM3_RAGDOLLS, self)

	self:CallOnRemove("RemoveFrom_ZGM3_RAGDOLLS", function()
		table.RemoveByValue(ZGM3_RAGDOLLS, self)
	end)

	-- Blood color:
	self.ZippyGoreMod3_BloodColor = blood_color

	if blood_color == false then
		self.ZippyGore3_VariableBloodColor = true
	end

	-- Health:
	self.ZippyGoreMod3_PhysBoneHPs = {}
	local root_health_mult = ZGM3_CVARS["zippygore3_root_bone_health_mult"]
	local health_mult = ZGM3_CVARS["zippygore3_misc_bones_health_mult"]

	for i = 0, self:GetPhysicsObjectCount() - 1 do
		self.ZippyGoreMod3_PhysBoneHPs[i] = self:GetPhysicsObjectNum(i):GetSurfaceArea() * 0.25 * ((i == 0 and root_health_mult) or health_mult)
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("CreateEntityRagdoll", "CreateEntityRagdoll_ZippyGoreMod3", function(own, rag)
	if ZGM3_CVARS["zippygore3_enable"] == false then return end

	if own:IsNPC() or own:IsNextBot() or own:IsPlayer() then
		local e_blood_color = own:GetBloodColor()
		local blood_color_to_use = (e_blood_color ~= -1 and e_blood_color) or (own.UsesRealisticBlood and 0) or own:ZippyGoreMod3_GetEngineBloodFromVJBlood() or own.ZippyGoreMod3_BackupBloodColor

		if blood_color_to_use and blood_color_to_use ~= -1 and blood_color_to_use ~= BLOOD_COLOR_MECH then
			-- Make ragdoll gibbable:
			rag:ZippyGoreMod3_BecomeGibbableRagdoll(blood_color_to_use)

			-- Damage the ragdoll with the same damage that was applied last time to its owner:
			if own.ZippyGoreMod3_LastDMGINFO then
				rag:ZippyGoreMod3_DamageRagdoll(own.ZippyGoreMod3_LastDMGINFO)
			end
		end
	end
end)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Add("OnEntityCreated", "OnEntityCreated_ZippyGoreMod3", function(ent)
	if ZGM3_CVARS["zippygore3_enable"] == false then return end
	if ZGM3_CVARS["zippygore3_gib_any_ragdoll"] == false or ent:GetClass() ~= "prop_ragdoll" then return end

	timer.Simple(0, function()
		if IsValid(ent) and not ent.ZippyGoreMod3_Ragdoll and not ent.ZippyGoreMod3_IsGibRagdoll then
			ent:ZippyGoreMod3_BecomeGibbableRagdoll(false)
		end
	end)
end)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------