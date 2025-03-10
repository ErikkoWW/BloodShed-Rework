if CLIENT then
	if not FLASHLIGHT_WOUND_FIX_ENTS then
		FLASHLIGHT_WOUND_FIX_ENTS = {}
	end

	------------------------------------------------------------------------------------------------------------------=#
	local function printTableContents()
	end

	-- print("---- TABLE CONTENTS ----")
	-- if table.IsEmpty(FLASHLIGHT_WOUND_FIX_ENTS) then
	--	 print("none")
	-- else
	--	 PrintTable(FLASHLIGHT_WOUND_FIX_ENTS)
	-- end
	-- print("----------------------------------------------")
	------------------------------------------------------------------------------------------------------------------=#
	------------------------------------------------------------------------------------------------------------------=#
	local function addToTable(ent)
		if ent:IsPlayer() then
			FLASHLIGHT_WOUND_FIX_ENTS[ent:SteamID()] = ent
		else
			table.insert(FLASHLIGHT_WOUND_FIX_ENTS, ent)
		end

		printTableContents()
	end

	------------------------------------------------------------------------------------------------------------------=#
	------------------------------------------------------------------------------------------------------------------=#
	local function removeFromTable(ent)
		table.RemoveByValue(FLASHLIGHT_WOUND_FIX_ENTS, ent)
		printTableContents()
	end

	------------------------------------------------------------------------------------------------------------------=#
	-- The meat of the addon --
	hook.Add("PreDrawEffects", "PreDrawEffects_FlashlightWoundFix", function()
		if not LocalPlayer():FlashlightIsOn() then return end
		local drawModelCalls = 0

		for _, ent in ipairs(table.Copy(FLASHLIGHT_WOUND_FIX_ENTS)) do
			-- Remove invalid ent from table
			if not IsValid(ent) then
				removeFromTable(ent)
				continue
			end

			-- Distance check
			if LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > GetConVar("r_flashlightfar"):GetInt() ^ 2 then continue end
			-- Magic
			render.SetBlend(0)
			ent:DrawModel()
			drawModelCalls = drawModelCalls + 1
		end
	end)

	------------------------------------------------------------------------------------------------------------------=#
	-- NPCS, RAGDOLLS, NEXTBOTS --
	hook.Add("OnEntityCreated", "OnEntityCreated_FlashlightWoundFix", function(ent)
		if ent:IsNPC() or ent:IsNextBot() or ent:GetClass() == "prop_ragdoll" then
			addToTable(ent)
		end
	end)

	------------------------------------------------------------------------------------------------------------------=#
	-- CLIENTSIDE RAGDOLLS --
	hook.Add("CreateClientsideRagdoll", "CreateClientsideRagdoll_FlashlightWoundFix", function(ent, rag)
		removeFromTable(ent) -- Remove the entity from the table to prevent visual weirdness
		addToTable(rag) -- Add the ragdoll instead
	end)
	------------------------------------------------------------------------------------------------------------------=#
end