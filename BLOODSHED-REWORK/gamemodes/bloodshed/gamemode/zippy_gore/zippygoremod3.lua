-- Decide if insane blood effects are installed:
if CLIENT then
	net.Receive("ZippyGore3_InsaneBloodEffectsInstalled", function()
		ZGM3_INSANE_BLOOD_EFFECTS = true
	end)

	hook.Add("InitPostEntity", "ZippyGore3_InitPostEntity", function()
		net.Start("ZippyGore3_CheckInsaneBloodEffectsInstalled")
		net.SendToServer()
	end)
end

if SERVER then
	ZGM3_INSANE_BLOOD_EFFECTS = file.Exists("autorun/server/zippy_realistic_blood.lua", "LUA")
	util.AddNetworkString("ZippyGore3_CheckInsaneBloodEffectsInstalled")
	util.AddNetworkString("ZippyGore3_InsaneBloodEffectsInstalled")

	net.Receive("ZippyGore3_CheckInsaneBloodEffectsInstalled", function()
		if ZGM3_INSANE_BLOOD_EFFECTS then
			net.Start("ZippyGore3_InsaneBloodEffectsInstalled")
			net.Broadcast()
		end
	end)
end

-- New synth blood color:
BLOOD_COLOR_ZGM3SYNTH = 7

-- Run files:
local function lua_file(name, cl)
	local full_name = "zippygoremod3/" .. name .. ".lua"
	AddCSLuaFile(full_name)

	if not (cl and SERVER) then
		include(full_name)
	end
end

-- Shared
lua_file("cvars")
lua_file("sounds")
lua_file("particles")
lua_file("dismemberment")
lua_file("default_gibs")

-- Server
if SERVER then
	lua_file("setup")
	lua_file("damage")
	lua_file("dmginfo_ext")
	lua_file("gibs")
end