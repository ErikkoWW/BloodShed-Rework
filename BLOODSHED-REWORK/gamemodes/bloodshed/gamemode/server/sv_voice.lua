
---
--- Taken from DarkRP
--- https://github.com/FPtje/DarkRP/blob/be404e9983e0ed357bae157b2121f0c2b73801a1/gamemode/modules/base/sv_gamemode_functions.lua#L293
---

--[[local roomTrResult = {}
local roomTrResult = {}
local roomTr = {output = roomTrResult}
local function IsInRoom(listenerShootPos, talkerShootPos, talker)
    roomTr.start = talkerShootPos
    roomTr.endpos = listenerShootPos

    roomTr.filter = talker
    roomTr.collisiongroup = COLLISION_GROUP_WORLD
    roomTr.mask = MASK_SOLID_BRUSHONLY
    util.TraceLine(roomTr)

    return not roomTrResult.HitWorld
end

local voicedistance = 550 * 550
local canhearcache = {}

for _, ply in ipairs(player.GetAll()) do
    canhearcache[ply] = {}
end

local gridSize = 550
local floor = math.floor

local grid
local plytogrid = {
    {},
    {}
}

timer.Create("DarkRPCanHearPlayersVoice", 0.3, 0, function()
    local players = player.GetHumans()

    -- Clear old values
    plytogrid[1] = {}
    plytogrid[2] = {}
    grid = {}

    local plyPos = {}
    local eyePos = {}

    -- Get the grid position of every player O(N)
    for _, ply in ipairs(players) do
        local pos = ply:GetPos()
        plyPos[ply] = pos
        eyePos[ply] = ply:EyePos()
        local x = floor(pos.x / gridSize)
        local y = floor(pos.y / gridSize)

        local row = grid[x] or {}
        local cell = row[y] or {}

        table.insert(cell, ply)
        row[y] = cell
        grid[x] = row

        plytogrid[1][ply] = x
        plytogrid[2][ply] = y

        canhearcache[ply] = {} -- Initialize output variable
    end

    -- Check all neighbouring cells for every player.
    -- We are only checking in 1 direction to avoid duplicate check of cells
    for _, ply1 in ipairs(players) do
        local gridX = plytogrid[1][ply1]
        local gridY = plytogrid[2][ply1]
        local ply1Pos = plyPos[ply1]
        local ply1EyePos = eyePos[ply1]

        for i = 0, 3 do
            local vOffset = 1 - ((i >= 3) and 1 or 0)
            local hOffset = -(i % 3-1)
            local x = gridX + hOffset
            local y = gridY + vOffset

            local row = grid[x]
            if not row then continue end

            local cell = row[y]
            if not cell then continue end

            for _, ply2 in ipairs(cell) do
                local canTalk =
                    ply1Pos:DistToSqr(plyPos[ply2]) < voicedistance and IsInRoom(ply1EyePos, eyePos[ply2], ply2)

                canhearcache[ply1][ply2] = canTalk and ply2:Alive()
                canhearcache[ply2][ply1] = canTalk and ply1:Alive()
            end
        end
    end

    -- Doing a pass-through inside every cell to compute the interactions inside of the cells.
    -- Each grid check is O(N(N+1)/2) where N is the number of players inside the cell.
    for _, row in pairs(grid) do
        for _, cell in pairs(row) do
            local count = #cell
            for i = 1, count do
                local ply1 = cell[i]
                for j = i + 1, count do
                    local ply2 = cell[j]
                    local canTalk =
                        plyPos[ply1]:DistToSqr(plyPos[ply2]) < voicedistance and IsInRoom(eyePos[ply1], eyePos[ply2], ply2)

                    canhearcache[ply1][ply2] = canTalk and ply2:Alive()
                    canhearcache[ply2][ply1] = canTalk and ply1:Alive()
                end
            end
        end
    end
end)

hook.Add("PlayerDisconnect", "DarkRPCanHear", function(ply)
    canhearcache[ply] = nil
end)

function GM:PlayerCanHearPlayersVoice(listener, talker)
    if MuR.GameStarted and MuR.TimeCount + 12 > CurTime() or MuR.Ending then return true end
    if not talker:Alive() and not listener:Alive () then return true end
    if not talker:Alive() and listener:Alive() then return false end --and listener:Alive() then return false end

    return canhearcache[listener][talker] == true, true
end
]]