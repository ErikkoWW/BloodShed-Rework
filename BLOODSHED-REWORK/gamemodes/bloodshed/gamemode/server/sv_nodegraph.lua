MuR.AI_Nodes = {}
local found_ai_nodes = false
local M = {}
local SIZEOF_INT = 4
local SIZEOF_SHORT = 2
local AINET_VERSION_NUMBER = 37

local function toUShort(b)
	local i = {string.byte(b, 1, SIZEOF_SHORT)}

	return i[1] + i[2] * 256
end

local function toInt(b)
	local i = {string.byte(b, 1, SIZEOF_INT)}

	i = i[1] + i[2] * 256 + i[3] * 65536 + i[4] * 16777216
	if i > 2147483647 then return i - 4294967296 end

	return i
end

local function ReadInt(f)
	return toInt(f:Read(SIZEOF_INT))
end

local function ReadUShort(f)
	return toUShort(f:Read(SIZEOF_SHORT))
end

if found_ai_nodes then return end
f = file.Open("maps/graphs/" .. game.GetMap() .. ".ain", "rb", "GAME")
if not f then return end
found_ai_nodes = true
local ainet_ver = ReadInt(f)
local map_ver = ReadInt(f)

if ainet_ver ~= AINET_VERSION_NUMBER then
	MsgN("Unknown graph file")

	return
end

local numNodes = ReadInt(f)

if numNodes < 0 then
	MsgN("Graph file has an unexpected amount of nodes")

	return
end

for i = 1, numNodes do
	local v = Vector(f:ReadFloat(), f:ReadFloat(), f:ReadFloat())
	local yaw = f:ReadFloat()
	local flOffsets = {}

	for i = 1, NUM_HULLS do
		flOffsets[i] = f:ReadFloat()
	end

	local nodetype = f:ReadByte()
	local nodeinfo = ReadUShort(f)
	local zone = f:ReadShort()

	if nodetype == 4 or nodetype == 3 then
		goto cont
	end

	local node = {
		pos = v,
		yaw = yaw,
		offset = flOffsets,
		type = nodetype,
		info = nodeinfo,
		zone = zone,
		neighbor = {},
		numneighbors = 0,
		link = {},
		numlinks = 0
	}

	table.insert(MuR.AI_Nodes, node.pos)
	::cont::
end

function MuR:GetRandomPos(underroof, frompos, mindist, maxdist, withoutply)
	local newtab = {}
	local tab = MuR.AI_Nodes

	if #tab > 0 then
		for i = 1, #tab do
			local pos = tab[i]

			local tr = util.TraceLine({
				start = pos,
				endpos = pos + Vector(0, 0, 9999),
			})

			local tr2 = util.TraceHull({
				start = pos + Vector(0, 0, 2),
				endpos = pos + Vector(0, 0, 2),
				filter = function(ent) return true end,
				mins = Vector(-16, -16, 0),
				maxs = Vector(16, 16, 72),
				mask = MASK_SHOT_HULL,
			})

			if tr.HitSky and underroof or not tr.HitSky and not underroof or tr2.Hit then continue end

			if frompos then
				local dist = frompos:DistToSqr(pos)
				if dist < mindist ^ 2 or dist > maxdist ^ 2 then continue end
			end

			if not withoutply then
				local visible = false
				local tab = player.GetAll()

				for i = 1, #tab do
					local ply = tab[i]

					if ply:Alive() and ply:VisibleVec(pos) then
						visible = true
						break
					end
				end
			end

			if visible then continue end
			table.insert(newtab, pos)
		end
	end

	if #newtab > 0 then
		return newtab[math.random(1, #newtab)]
	else
		return nil
	end
end

function MuR:FindPositionInRadius(pos, dist)
	local spawnPositions = {}
	local trace = {}
	trace.start = pos
	trace.mask = MASK_SOLID

	trace.filter = function(ent)
		if ent:IsPlayer() or ent:IsNPC() or string.match(ent:GetClass(), "_door") then
			return false
		else
			return true
		end
	end

	trace.endpos = pos - Vector(0, 0, 1000)
	local result = util.TraceLine(trace)

	if result.Hit then
		local floorPos = result.HitPos
		trace.endpos = floorPos + Vector(0, 0, 1000)
		result = util.TraceLine(trace)

		if result.Hit then
			local ceilingPos = result.HitPos
			local height = math.abs(ceilingPos.z - floorPos.z)

			for i = 0, 360 do
				local offset = Vector(math.random(-dist, dist), math.random(-dist, dist), 0)
				local spawnPos = floorPos + offset + Vector(0, 0, height / 2)
				trace.start = spawnPos
				trace.endpos = spawnPos + Vector(0, 0, 1000)
				result = util.TraceLine(trace)

				if result.Hit then
					trace.start = result.HitPos
					trace.endpos = result.HitPos - Vector(0, 0, 1000)
					result = util.TraceLine(trace)

					if result.Hit and result.HitPos.z - pos.z >= 4 then
						table.insert(spawnPositions, result.HitPos + Vector(0, 0, 8))
					end
				end
			end
		end
	end

	return table.Random(spawnPositions)
end

function MuR:GiveRandomTableWithChance(tab, extra)
	local totalChance = 0
	local tab2 = table.Copy(tab)
	local t = {}

	if isfunction(extra) then
		for i, subtable in pairs(tab2) do
			if extra(subtable) then
				table.insert(t, subtable)
			end
		end
	else
		t = table.Copy(tab2)
	end

	if #t == 0 then return end

	for _, subtable in pairs(t) do
		totalChance = totalChance + subtable.chance
	end

	local randomValue = math.random(totalChance)
	local currentChance = 0

	for i, subtable in pairs(t) do
		currentChance = currentChance + subtable.chance
		if randomValue <= currentChance then return subtable, i end
	end
end