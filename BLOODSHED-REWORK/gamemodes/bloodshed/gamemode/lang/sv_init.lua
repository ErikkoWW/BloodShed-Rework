MuR.Languages = {}

local langFiles = file.Find("bloodshed/gamemode/lang/*.lua", "LUA")

for k, v in ipairs(langFiles) do
	local exp = string.Explode(".", v)[1]
	MuR.Languages[exp] = true

	AddCSLuaFile(v)
end