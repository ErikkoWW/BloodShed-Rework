MuR = MuR or {}

function MuR.server(path)
	include(path)
end

function MuR.shared(path)
	AddCSLuaFile(path)
	include(path)
end

function MuR.client(path)
	AddCSLuaFile(path)
end

MuR.client("cl_init.lua")
MuR.shared("shared.lua")

local config = file.Read("bloodshed/" .. game.GetMap() .. ".lua", "LUA")

if config then
	RunString(config)
end