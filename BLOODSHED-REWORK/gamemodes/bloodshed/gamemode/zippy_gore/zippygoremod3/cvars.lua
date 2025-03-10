ZGM3_CVARS = {
	-- Enable:
	["zippygore3_enable"] = true,
	-- Health:
	["zippygore3_misc_bones_health_mult"] = 6,
	["zippygore3_root_bone_health_mult"] = 12,
	-- Damage:
	["zippygore3_phys_damage_mult"] = 0.5,
	["zippygore3_explosion_damage_mult"] = 8,
	["zippygore3_bullet_damage_mult"] = 1,
	-- Gibbing:
	["zippygore3_disable_never_gib_damage"] = false,
	["zippygore3_disable_always_gib_damage"] = true,
	["zippygore3_gib_any_ragdoll"] = true,
	["zippygore3_gib_dissolving_ragdoll"] = true,
	-- Gibs:
	["zippygore3_gib_limit"] = 300,
	["zippygore3_gib_lifetime"] = 180,
	["zippygore3_gib_edible"] = false,
	["zippygore3_gib_heath_give"] = 10,
	-- Effects:
	["zippygore3_bleed_effect"] = true,
	-- Developer:
	["zippygore3_print_gibbed_bone"] = false,
	-- Hidden:
	["zippygore3_dismemberment"] = false,
}

-- Workaround
local saved_cvars_file = "zippygore3_saved_cvars.json"

if not file.Exists(saved_cvars_file, "DATA") then
	file.Write(saved_cvars_file, "[]")
end

-- Get all saved cvars:
local saved_cvars = util.JSONToTable(file.Read(saved_cvars_file))

-- Set all saved cvar:
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if CLIENT then
	function ZippyGoreMod3_ChangeCvar(cvar, v)
		net.Start("ZippyGoreMod3_ChangeCvar")
		net.WriteString(cvar)
		net.WriteString(v)
		net.SendToServer()
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SERVER then
	util.AddNetworkString("ZippyGoreMod3_ChangeCvar")

	net.Receive("ZippyGoreMod3_ChangeCvar", function(_, ply)
		if not ply:IsSuperAdmin() then return end
		local cvar = net.ReadString()
		local v = net.ReadString()
		-- Save cvar:
		saved_cvars[cvar] = v
		file.Write(saved_cvars_file, util.TableToJSON(saved_cvars))
	end)
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------