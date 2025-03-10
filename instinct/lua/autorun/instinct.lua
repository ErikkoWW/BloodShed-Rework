if not CLIENT then return end

local markScriptedEntities = CreateClientConVar("instinct_mark_scripted_entities", "1", true, false, "Whether to mark scripted entities with Instinct")
local UIMarkersPlayers = CreateClientConVar("instinct_ui_markers_players", "1", true, false, "Whether to show UI markers for players with Instinct")
local UIMarkersEntities = CreateClientConVar("instinct_ui_markers_entities", "1", true, false, "Whether to show UI markers for entities with Instinct")

local PlaySound = CreateClientConVar("instinct_play_sound", "1", true, false, "Whether to play a sound when using Instinct")
local ScreenShake = CreateClientConVar("instinct_screen_shake", "1", true, false, "Whether to shake the screen when using Instinct")

local MaxRadius = CreateClientConVar("instinct_scan_maxradius", "10000", true, false, "The maximum radius of the Instinct scan")
local TravelTime = CreateClientConVar("instinct_scan_traveltime", "5", true, false, "The time it takes for the Instinct scan to reach its maximum radius")
local Cooldown = CreateClientConVar("instinct_scan_cooldown", "10", true, false, "The cooldown of the Instinct scan")

concommand.Add("instinct_scan_default", function()
	MaxRadius:SetInt(10000)
	TravelTime:SetInt(5)
	Cooldown:SetInt(7)
end)

local BorderSphereUnit = BorderSphereUnit
local player_GetAll = player.GetAll
local math_floor = math.floor
local math_min = math.min
local string_len = string.len
local string_sub = string.sub
local tonumber = tonumber
local Lerp = Lerp

local SPHERE_CONFIG = {
    COLOR = Color(255, 0, 0),
    RADIUS = 60,
    DETAIL = 32,
    THICKNESS = 16,
}

local SCAN_CONFIG = {
    CURRENT_RADIUS = 0,
    MAX_RADIUS = 10000,
    START_SPEED = 300,
    TIME_UNTIL_COMPLETION = 5,
    FADE_START = 0.8,
    LAST_TIME = 0,
    START_TIME = 0,
    START_DURATION = 0.5,
    COOLDOWN = 7,
    LAST_USE = 0,
    MARK_DURATION = 5,
    MARK_FADE_TIME = 2,
    IS_SCANNING = false,
}

local markedEntities = {}

local function calculateAlpha()
    local currentTime = CurTime()
    local progressRatio = SCAN_CONFIG.CURRENT_RADIUS / MaxRadius:GetInt()
    local timeSinceStart = currentTime - SCAN_CONFIG.START_TIME
    local cooldownRatio = (currentTime - SCAN_CONFIG.LAST_USE) / Cooldown:GetInt()
    
    local fadeAlpha = 255
    if progressRatio >= SCAN_CONFIG.FADE_START then
        local fadeProgress = (progressRatio - SCAN_CONFIG.FADE_START) / (1 - SCAN_CONFIG.FADE_START)
        fadeAlpha = math.max(0, math.floor((1 - fadeProgress) * 255))
    end
    
    local cooldownAlpha = 255
    if cooldownRatio >= 0.8 then
        local cooldownFadeProgress = (cooldownRatio - 0.8) / 0.2
        cooldownAlpha = math.max(0, math.floor((1 - cooldownFadeProgress) * 255))
    end
    
    return math.min(fadeAlpha, cooldownAlpha)
end

local function calculatePosition(t)
    local s = MaxRadius:GetInt()
    local v0 = SCAN_CONFIG.START_SPEED
    local T = TravelTime:GetInt()
    
    t = math.min(t, T)
    
    local a = 2 * (s - v0 * T) / (T * T)
    return math.min(v0 * t + 0.5 * a * t * t, s)
end

local function calculateSpeed(deltaTime)
    local currentTime = CurTime()
    local elapsedTime = currentTime - SCAN_CONFIG.START_TIME
    
    elapsedTime = math.min(elapsedTime, TravelTime:GetFloat())
    
    local startProgress = math.min(elapsedTime / SCAN_CONFIG.START_DURATION, 1)
    local startMultiplier = startProgress * startProgress
    
    if SCAN_CONFIG.CURRENT_RADIUS >= MaxRadius:GetInt() then
        return 0
    end
    
    local v0 = SCAN_CONFIG.START_SPEED
    local T = TravelTime:GetFloat()
    local a = 2 * (MaxRadius:GetInt() - v0 * T) / (T * T)
    local v = v0 + a * elapsedTime
    
    return math.max(0, v * startMultiplier)
end

local function canUseInstinct()
    local class = LocalPlayer():GetNWString("class")

    if class == "Maniac" or class == "Zombie" then
        local canUse = CurTime() - SCAN_CONFIG.LAST_USE >= Cooldown:GetInt()
        if canUse then
            SCAN_CONFIG.IS_SCANNING = false
            SCAN_CONFIG.CURRENT_RADIUS = 0
        end
        return canUse
    end
    
    return false
end



local function isHostileNPC(npc)
    if not IsValid(npc) then return false end
    
    local friendlyClasses = {
		"npc_citizen",
		"npc_breen",
		"npc_alyx",
		"npc_kleiner",
		"npc_magnusson",
		"npc_monk",
		"npc_mossman",
		"npc_odessa",
		"npc_vortigaunt",
		"npc_barney",
		"npc_dog",
		"npc_crow",
		"npc_seagull",
		"npc_pigeon",
		"npc_eli",
		"npc_fisherman",
		"npc_gman",
    }
    
    return not table.HasValue(friendlyClasses, npc:GetClass())
end

function EntityColor(ent)
    local baseColor
    
    if ent:IsPlayer() then
        baseColor = Color(150, 0, 0)
    else
        return Color(255, 255, 255)
    end
    
    if ent:IsPlayer() then
        local health = ent:Health()
        local maxHealth = ent:GetMaxHealth()
        
        if health and maxHealth and maxHealth > 0 then
            local healthPercentage = math.Clamp(health / maxHealth, 0, 1)
            
            local darkenFactor = 0.15 + (healthPercentage * 0.75)
            
            return Color(
                math.Round(baseColor.r * darkenFactor),
                math.Round(baseColor.g * darkenFactor),
                math.Round(baseColor.b * darkenFactor),
                baseColor.a
            )
        end
    end

    return baseColor
end

function MaskEntity(ent)
    if not markedEntities[ent] then return end
    
    local currentTime = CurTime()
    local markData = markedEntities[ent]
    local color = markData.color
    
    local alpha = 255
    local timeSinceMark = currentTime - markData.time
    
    if timeSinceMark > SCAN_CONFIG.MARK_DURATION then
        local fadeProgress = (timeSinceMark - SCAN_CONFIG.MARK_DURATION) / SCAN_CONFIG.MARK_FADE_TIME
        alpha = math.max(0, 255 * (1 - fadeProgress))
        
        if alpha == 0 then
            markedEntities[ent] = nil
            return
        end
    end

    render.SetBlend(1)
    render.SetColorModulation(1, 1, 1)
    
    render.SetStencilEnable(true)
    render.SetStencilReferenceValue(0)
    render.SetStencilPassOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.ClearStencil()

    render.SetStencilCompareFunction(STENCIL_NEVER)
    render.SetStencilFailOperation(STENCIL_REPLACE)
    render.SetStencilReferenceValue(0x1C)
    render.SetStencilWriteMask(0x55)

    ent:DrawModel()

    render.SetStencilTestMask(0xF3)
    render.SetStencilReferenceValue(0x10)
    render.SetStencilCompareFunction(STENCIL_EQUAL)

    local markColor = Color(color.r, color.g, color.b, alpha)
    render.ClearBuffersObeyStencil(markColor.r, markColor.g, markColor.b, markColor.a, false)

    render.SetStencilEnable(false)
end

local function isInSphere(ent, spherePos, radius)
    if not IsValid(ent) then return false end
    local entPos = ent:GetPos()
    return entPos:DistToSqr(spherePos) <= radius * radius
end

concommand.Add("instinct", function()
    if canUseInstinct() then
		if PlaySound:GetBool() then
			surface.PlaySound("instinct/ping3.mp3")
		end

		if ScreenShake:GetBool() then
			util.ScreenShake(Vector(0, 0, 0), 2, 3, 2, 1000)
		end
        SCAN_CONFIG.CURRENT_RADIUS = 0
        SCAN_CONFIG.LAST_TIME = CurTime()
        SCAN_CONFIG.START_TIME = CurTime()
        SCAN_CONFIG.LAST_USE = CurTime()
        SCAN_CONFIG.IS_SCANNING = true
    end
end)

hook.Add("PostDrawTranslucentRenderables", "Instinct", function()
    local currentTime = CurTime()
    
    for ent, markData in pairs(markedEntities) do
        if IsValid(ent) then
            markData.color = EntityColor(ent)
            MaskEntity(ent)
        else
            markedEntities[ent] = nil
        end
    end

    if currentTime - SCAN_CONFIG.LAST_USE >= Cooldown:GetInt() then
        SCAN_CONFIG.IS_SCANNING = false
        SCAN_CONFIG.CURRENT_RADIUS = 0
        return
    end

    if not SCAN_CONFIG.IS_SCANNING then return end

    local deltaTime = currentTime - SCAN_CONFIG.LAST_TIME
    SCAN_CONFIG.LAST_TIME = currentTime
   
    local speed = calculateSpeed(deltaTime)
    local newRadius = SCAN_CONFIG.CURRENT_RADIUS + speed * deltaTime
    
    SCAN_CONFIG.CURRENT_RADIUS = math.min(newRadius, MaxRadius:GetInt())
   
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
   
    local spherePos = ply:WorldSpaceCenter()
    for _, ent in pairs(ents.GetAll()) do
        if IsValid(ent) and ent:IsPlayer() and ent != ply then
            if ent:GetClass() == "gmod_hands" or ent:GetClass() == "mg_viewmodel" or 
            (ent:IsScripted() and ent:GetModel() == "models/error.mdl") or 
            (ent:IsScripted() and ent.PrintName == "Gib")
            then continue end

            if (ent:IsScripted() and not ent:GetClass():find("ammo")) and not markScriptedEntities:GetBool() then continue end

            if isInSphere(ent, spherePos, SCAN_CONFIG.CURRENT_RADIUS) and not markedEntities[ent] then
                markedEntities[ent] = {
                    time = currentTime,
                    color = EntityColor(ent)
                }
            end
        end
    end

    if SCAN_CONFIG.CURRENT_RADIUS < MaxRadius:GetInt() then
        local alpha = calculateAlpha()
        local sphereColor = Color(
            SPHERE_CONFIG.COLOR.r,
            SPHERE_CONFIG.COLOR.g,
            SPHERE_CONFIG.COLOR.b,
            alpha
        )
       
        BorderSphereUnit(
            sphereColor,
            spherePos,
            SCAN_CONFIG.CURRENT_RADIUS,
            SPHERE_CONFIG.DETAIL,
            SPHERE_CONFIG.THICKNESS
        )
    else
        SCAN_CONFIG.IS_SCANNING = false
        SCAN_CONFIG.CURRENT_RADIUS = 0
    end
end)

local SPHERE_NUMBER_RULES = {[0]=2,[1]=1,[3]=2,[5]=1,[7]=2,[9]=1}

function BorderSphereUnit(color, pos, radius, detail, thickness)
    radius = math_floor(radius)
    thickness = math_floor(thickness or 24)
    detail = math_min(math_floor(detail or 32), 100)
    
    if thickness >= radius then 
        thickness = radius 
    end
    
    local lastDigit = tonumber(string_sub(tostring(radius), -1))
    local rule = SPHERE_NUMBER_RULES[lastDigit]
    if rule == 1 then 
        ds = 1 
    elseif rule == 2 then 
        ds = 0.50 
    end

    local viewEntity = LocalPlayer():GetViewEntity()
    local cam_pos, cam_angle
    
    if viewEntity == LocalPlayer() then
        cam_pos = LocalPlayer():EyePos()
        cam_angle = LocalPlayer():GetAimVector():Angle()
    else
        cam_pos = viewEntity:GetPos()
        cam_angle = viewEntity:GetAngles()
    end
    
    local cam_normal = cam_angle:Forward()
    
    render.SetStencilEnable(true)
    render.SetStencilReferenceValue(0x55)
    render.SetStencilTestMask(0x1C)
    render.SetStencilWriteMask(0x1C)
    render.ClearStencil()
    
    render.SetColorMaterial()
    
    local detailWithDs = detail + ds
    local radiusMinusThickness = radius - thickness
    
    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
    render.SetStencilZFailOperation(STENCILOPERATION_INVERT)
    
    local invisibleColor = Color(0, 0, 0, 0)
    render.DrawSphere(pos, -radius, detail, detail, invisibleColor)
    render.DrawSphere(pos, radius, detail, detail, invisibleColor)
    render.DrawSphere(pos, -radiusMinusThickness, detailWithDs, detailWithDs, invisibleColor)
    render.DrawSphere(pos, radiusMinusThickness, detailWithDs, detailWithDs, invisibleColor)
    
    render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
    render.DrawSphere(pos, radius + 0.25, detailWithDs, detailWithDs, invisibleColor)
    
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)
    cam.IgnoreZ(true)
    render.SetStencilReferenceValue(1)
    render.DrawQuadEasy(cam_pos + cam_normal * 10, -cam_normal, 10000, 10000, color, cam_angle.roll)
    
    cam.IgnoreZ(false)
    render.SetStencilEnable(false)
end

---------
-- HUD --
---------

-- Player Markers

local HUD_CONFIG = {
    HEIGHT = 60,
    WIDTH = 200,
    PADDING = 20,
    CORNER_RADIUS = 8,
    BACKGROUND_COLOR = Color(0, 51, 102, 230),
    TEXT_COLOR = Color(255, 255, 255, 255),
    AVATAR_SIZE = 40,
    MIN_VERTICAL_OFFSET = 10,

    -- Animation settings
    WIDTH_EXPANSION_TIME = 0.5,
    LENGTH_EXPANSION_TIME = 0.5,
    EXPANSION_DELAY = 0,
	CONTENT_FADE_TIME = 0.2,

    -- Text settings
    NAME_FONT = "Trebuchet24",
    STAT_FONT = "Trebuchet18",
    STAT_COLOR = Color(255, 255, 255, 255),
    HAMMER_TO_METERS = 0.01904,
}


local avatarMaterials = {}

local function GetPlayerAvatar(ply)
    if not IsValid(ply) then return end
    
    if not avatarMaterials[ply] then
        avatarMaterials[ply] = vgui.Create("AvatarImage")
        avatarMaterials[ply]:SetSize(HUD_CONFIG.AVATAR_SIZE, HUD_CONFIG.AVATAR_SIZE)
        avatarMaterials[ply]:SetPlayer(ply, HUD_CONFIG.AVATAR_SIZE)
        avatarMaterials[ply]:ParentToHUD()
        avatarMaterials[ply]:SetPaintedManually(true)
    end
    
    return avatarMaterials[ply]
end

hook.Add("PlayerDisconnected", "CleanupPlayerAvatars", function(ply)
    if avatarMaterials[ply] then
        avatarMaterials[ply]:Remove()
        avatarMaterials[ply] = nil
    end
end)

local function DrawRoundedBoxWithBorder(radius, x, y, w, h, color, borderColor, borderSize)
    draw.RoundedBox(radius, x - borderSize, y - borderSize, w + borderSize * 2, h + borderSize * 2, borderColor)
    draw.RoundedBox(radius, x, y, w, h, color)
end

local function GetPlayerScreenBounds(ply)
    local mins, maxs = ply:OBBMins(), ply:OBBMaxs()
    local pos = ply:GetPos()
    
    local bottomPos = (pos + mins):ToScreen()
    local topPos = (pos + Vector(0, 0, maxs.z)):ToScreen()
    
    return bottomPos, topPos
end

local function easeOutCubic(x)
    return 1 - math.pow(1 - x, 3)
end

local function easeOutExpo(x)
    return x == 1 and 1 or 1 - math.pow(2, -10 * x)
end

local function CalculateAnimationProgress(markData)
    local currentTime = CurTime()
    local timeSinceMark = currentTime - markData.time
    
    if timeSinceMark <= HUD_CONFIG.WIDTH_EXPANSION_TIME then
        local progress = timeSinceMark / HUD_CONFIG.WIDTH_EXPANSION_TIME
        return {
            width = easeOutExpo(progress),
            height = 0,
            alpha = 255,
            contentAlpha = 0
        }
    end
    
    if timeSinceMark <= HUD_CONFIG.WIDTH_EXPANSION_TIME + HUD_CONFIG.EXPANSION_DELAY then
        return {
            width = 1,
            height = 0,
            alpha = 255,
            contentAlpha = 0
        }
    end
    
    local heightStart = HUD_CONFIG.WIDTH_EXPANSION_TIME + HUD_CONFIG.EXPANSION_DELAY
    local heightTime = timeSinceMark - heightStart
    if heightTime <= HUD_CONFIG.LENGTH_EXPANSION_TIME then
        local progress = heightTime / HUD_CONFIG.LENGTH_EXPANSION_TIME
        return {
            width = 1,
            height = easeOutCubic(progress),
            alpha = 255,
            contentAlpha = 0
        }
    end
    
    local contentStart = heightStart + HUD_CONFIG.LENGTH_EXPANSION_TIME
    local contentTime = timeSinceMark - contentStart
    if contentTime <= HUD_CONFIG.CONTENT_FADE_TIME then
        local fadeProgress = contentTime / HUD_CONFIG.CONTENT_FADE_TIME
        return {
            width = 1,
            height = 1,
            alpha = 255,
            contentAlpha = math.min(255, fadeProgress * 255)
        }
    end
    
    if timeSinceMark > SCAN_CONFIG.MARK_DURATION then 
        local fadeStart = SCAN_CONFIG.MARK_DURATION
        local fadeProgress = (timeSinceMark - fadeStart) / SCAN_CONFIG.MARK_FADE_TIME
        local fadeAlpha = math.max(0, 255 * (1 - easeOutCubic(fadeProgress)))
        return {
            width = 1,
            height = 1,
            alpha = fadeAlpha,
            contentAlpha = fadeAlpha
        }
    end
    
    return {
        width = 1,
        height = 1,
        alpha = 255,
        contentAlpha = 255
    }
end

local function GetPlayerStats(ply)
    if not IsValid(ply) then return end
    
    local health = math.Clamp(ply:Health(), 0, ply:GetMaxHealth())
    local armor = math.Clamp(ply:Armor(), 0, 100)
    local healthPercentage = math.Round((health / ply:GetMaxHealth()) * 100)
    local armorPercentage = armor
    
    local distance = LocalPlayer():GetPos():Distance(ply:GetPos()) * HUD_CONFIG.HAMMER_TO_METERS
    local distanceRounded = math.Round(distance, 1)
    
    return {
        health = healthPercentage,
        armor = armorPercentage,
        distance = distanceRounded
    }
end

local function DrawPlayerMarker(ply, markData)
    if not IsValid(ply) then return end
   
    local animation = CalculateAnimationProgress(markData)
    if animation.alpha <= 0 then return end
   
    local bottomPos, topPos = GetPlayerScreenBounds(ply)
    if not (bottomPos.visible or topPos.visible) then return end
   
    local stats = GetPlayerStats(ply)
    if not stats then return end
   
    local currentWidth = HUD_CONFIG.WIDTH * animation.width
    local currentHeight = HUD_CONFIG.HEIGHT * animation.height
   
    local boxX = topPos.x - (currentWidth / 2)
    local boxY = topPos.y - currentHeight - HUD_CONFIG.MIN_VERTICAL_OFFSET
   
    if animation.height > 0 then
        local bgColor = ColorAlpha(HUD_CONFIG.BACKGROUND_COLOR, animation.alpha)
        DrawRoundedBoxWithBorder(
            HUD_CONFIG.CORNER_RADIUS,
            boxX,
            boxY,
            currentWidth,
            currentHeight,
            bgColor,
            ColorAlpha(markData.color, animation.alpha),
            2
        )
       
        if animation.width == 1 and animation.height == 1 then
            local avatar = GetPlayerAvatar(ply)
            if avatar then
                local avatarX = boxX + HUD_CONFIG.PADDING
                local avatarY = boxY + (HUD_CONFIG.HEIGHT - HUD_CONFIG.AVATAR_SIZE) / 2
                
                avatar:SetAlpha(animation.contentAlpha)
                avatar:SetPos(avatarX, avatarY)
                avatar:PaintManual()
                
                surface.SetDrawColor(ColorAlpha(markData.color, animation.contentAlpha))
                surface.DrawOutlinedRect(
                    avatarX - 1,
                    avatarY - 1,
                    HUD_CONFIG.AVATAR_SIZE + 2,
                    HUD_CONFIG.AVATAR_SIZE + 2,
                    2
                )
            end
           
            local contentX = boxX + HUD_CONFIG.PADDING + HUD_CONFIG.AVATAR_SIZE + 10
            local nameY = boxY + 4
            local statsY = nameY + 30
           
            draw.SimpleText(ply:Nick(), HUD_CONFIG.NAME_FONT, contentX, nameY,
                ColorAlpha(HUD_CONFIG.TEXT_COLOR, animation.contentAlpha))
           
            local distanceText = string.format("%.1fm", stats.distance)
            draw.SimpleText(distanceText, HUD_CONFIG.STAT_FONT, contentX, nameY + 17,
                ColorAlpha(HUD_CONFIG.TEXT_COLOR, animation.contentAlpha)
            )
           
            local healthText = string.format("HP: %d%%", stats.health)
            draw.SimpleText(healthText, HUD_CONFIG.STAT_FONT, contentX, statsY,
                Color(80, 255, 80, animation.contentAlpha)
            )
           
            surface.SetFont(HUD_CONFIG.STAT_FONT)
            local healthWidth = surface.GetTextSize(healthText)
           
            if stats.armor > 0 then
                draw.SimpleText(string.format("AP: %d%%", stats.armor),
                    HUD_CONFIG.STAT_FONT,
                    contentX + healthWidth + 10,
                    statsY,
                    Color(80, 180, 255, animation.contentAlpha)
                )
            end
        end
    else
        surface.SetDrawColor(ColorAlpha(markData.color, animation.alpha))
        surface.DrawRect(boxX, topPos.y - HUD_CONFIG.MIN_VERTICAL_OFFSET, currentWidth, 2)
    end
end

-- Entity Markers
local AIM_CONFIG = {
    DOT_THRESHOLD = 0.98,
    MAX_DISTANCE = 2000,
    ANIMATION_SPEED = 2,
    REVERSE_ANIMATION_TIME = 0.25
}

local aimedEntities = {}
local function isLookingAtEntity(ent)
    if not IsValid(ent) then return false end
    
    local ply = LocalPlayer()
    if not IsValid(ply) then return false end
    
    local plyPos = ply:EyePos()
    local aimVector = ply:GetAimVector()
    local entPos = ent:GetPos() + ent:OBBCenter()
    
    local directionToEnt = (entPos - plyPos):GetNormalized()
    local dotProduct = aimVector:Dot(directionToEnt)
    
    return dotProduct > AIM_CONFIG.DOT_THRESHOLD
end

local function CalculateEntityAnimationProgress(markData)
    local currentTime = CurTime()
    local timeSinceMark = (currentTime - markData.time) * AIM_CONFIG.ANIMATION_SPEED
    
    if markData.reversing then
        local reverseProgress = (currentTime - markData.reverseStartTime) / AIM_CONFIG.REVERSE_ANIMATION_TIME
        if reverseProgress >= 1 then
            return { width = 0, height = 0, alpha = 0, contentAlpha = 0 }
        end
        reverseProgress = easeOutCubic(reverseProgress)
        return {
            width = 1 - reverseProgress,
            height = 1 - reverseProgress,
            alpha = 255 * (1 - reverseProgress),
            contentAlpha = 255 * (1 - reverseProgress)
        }
    end
    
    if timeSinceMark <= HUD_CONFIG.WIDTH_EXPANSION_TIME then
        local progress = timeSinceMark / HUD_CONFIG.WIDTH_EXPANSION_TIME
        return {
            width = easeOutExpo(progress),
            height = 0,
            alpha = 255,
            contentAlpha = 0
        }
    end
    
    if timeSinceMark <= HUD_CONFIG.WIDTH_EXPANSION_TIME + HUD_CONFIG.EXPANSION_DELAY then
        return {
            width = 1,
            height = 0,
            alpha = 255,
            contentAlpha = 0
        }
    end
    
    local heightStart = HUD_CONFIG.WIDTH_EXPANSION_TIME + HUD_CONFIG.EXPANSION_DELAY
    local heightTime = timeSinceMark - heightStart
    if heightTime <= HUD_CONFIG.LENGTH_EXPANSION_TIME then
        local progress = heightTime / HUD_CONFIG.LENGTH_EXPANSION_TIME
        return {
            width = 1,
            height = easeOutCubic(progress),
            alpha = 255,
            contentAlpha = 0
        }
    end
    
    local contentStart = heightStart + HUD_CONFIG.LENGTH_EXPANSION_TIME
    local contentTime = timeSinceMark - contentStart
    if contentTime <= HUD_CONFIG.CONTENT_FADE_TIME then
        local fadeProgress = contentTime / HUD_CONFIG.CONTENT_FADE_TIME
        return {
            width = 1,
            height = 1,
            alpha = 255,
            contentAlpha = math.min(255, fadeProgress * 255)
        }
    end
    
    return {
        width = 1,
        height = 1,
        alpha = 255,
        contentAlpha = 255
    }
end

local BACKGROUND_COLORS = {
    PLAYER = Color(0, 51, 102, 230),
    HOSTILE = Color(102, 0, 0, 230),
    FRIENDLY = Color(0, 102, 0, 230),
    ITEM = Color(0, 102, 102, 230),
    ENTITY = Color(102, 0, 102, 230),
    VEHICLE = Color(0, 0, 102, 230),
}

local function GetEntityDisplayName(ent)
    if not IsValid(ent) then return "Unknown" end
	
    if ent.PrintName and ent.PrintName != "" then
        return ent.PrintName
    elseif ent.GetPrintName and ent:GetPrintName() != "" then
        return ent:GetPrintName()
    else
        return ent:GetClass()
    end
end

local function GetEntityBackgroundColor(ent)
    if ent:IsPlayer() then
        return BACKGROUND_COLORS.PLAYER
    else
        return BACKGROUND_COLORS.ENTITY
    end
end

local function WrapText(text, font, maxWidth)
    surface.SetFont(font)
    
    if surface.GetTextSize(text) <= maxWidth then
        return text
    end
    
    -- If text is too long, truncate with ellipsis
    local ellipsis = "..."
    local currentText = text
    local width = surface.GetTextSize(currentText .. ellipsis)
    
    while width > maxWidth and #currentText > 0 do
        currentText = string.sub(currentText, 1, #currentText - 1)
        width = surface.GetTextSize(currentText .. ellipsis)
    end
    
    return currentText .. ellipsis
end


local function DrawEntityMarker(ent, markData)
    if not IsValid(ent) then return end
    
    -- Skip UI markers for buttons / C_BaseEntity, it looks ugly and is not useful
    if ent:GetClass() == "class C_BaseEntity" or 
       ent:GetClass() == "func_button" or 
       ent:GetClass():find("button") then
        return
    end
    
    local animation = CalculateEntityAnimationProgress(markData)
    if animation.alpha <= 0 then return end
    
    local bottomPos, topPos = GetPlayerScreenBounds(ent)
    if not (bottomPos.visible or topPos.visible) then return end
    
    local currentWidth = HUD_CONFIG.WIDTH * animation.width
    local currentHeight = HUD_CONFIG.HEIGHT * animation.height
    
    local boxX = topPos.x - (currentWidth / 2)
    local boxY = topPos.y - currentHeight - HUD_CONFIG.MIN_VERTICAL_OFFSET
    
    if animation.height > 0 then
        local bgColor = ColorAlpha(GetEntityBackgroundColor(ent), animation.alpha)
        DrawRoundedBoxWithBorder(
            HUD_CONFIG.CORNER_RADIUS,
            boxX,
            boxY,
            currentWidth,
            currentHeight,
            bgColor,
            ColorAlpha(markData.color, animation.alpha),
            2
        )
        
        if animation.width == 1 and animation.height == 1 then
            if not markData.modelPanel then
				local model = ent:GetModel()
				if not model or model == "" or model == "models/error.mdl" then
					markData.noValidModel = true
				else
					markData.modelPanel = vgui.Create("DModelPanel")
					markData.modelPanel:SetSize(HUD_CONFIG.AVATAR_SIZE, HUD_CONFIG.AVATAR_SIZE)
					markData.modelPanel:SetModel(model)

					local originalPaint = markData.modelPanel.Paint
					
					markData.modelPanel.Paint = function(self, w, h)
						surface.SetDrawColor(255, 255, 255, 255)
						surface.DrawRect(0, 0, w, h)
						originalPaint(self, w, h)
					end
					
					markData.modelPanel:SetPaintedManually(true)
				end
			end
            
            local modelX = boxX + HUD_CONFIG.PADDING
            local modelY = boxY + (HUD_CONFIG.HEIGHT - HUD_CONFIG.AVATAR_SIZE) / 2
            
            if markData.modelPanel then
                markData.modelPanel:SetAlpha(animation.contentAlpha)
                markData.modelPanel:SetPos(modelX, modelY)
                markData.modelPanel:PaintManual()
                
                surface.SetDrawColor(ColorAlpha(markData.color, animation.contentAlpha))
                surface.DrawOutlinedRect(
                    modelX - 1,
                    modelY - 1,
                    HUD_CONFIG.AVATAR_SIZE + 2,
                    HUD_CONFIG.AVATAR_SIZE + 2,
                    2
                )
            end
            
            -- Draw entity information
            local contentX = boxX + HUD_CONFIG.PADDING
            if markData.modelPanel then
                contentX = contentX + HUD_CONFIG.AVATAR_SIZE + 10
            end
            
            local nameY = boxY + 2
            local statsY = nameY + 30
            
			local availableWidth = currentWidth - (contentX - boxX) - HUD_CONFIG.PADDING

			local displayName = WrapText(GetEntityDisplayName(ent), HUD_CONFIG.NAME_FONT, availableWidth)
			draw.SimpleText(
				displayName,
				HUD_CONFIG.NAME_FONT,
				contentX,
				nameY,
				ColorAlpha(HUD_CONFIG.TEXT_COLOR, animation.contentAlpha)
			)
            
            -- Distance
            local distance = LocalPlayer():GetPos():Distance(ent:GetPos()) * HUD_CONFIG.HAMMER_TO_METERS
            local distanceText = string.format("%.1fm", distance)
            draw.SimpleText(
                distanceText,
                HUD_CONFIG.STAT_FONT,
                contentX,
                nameY + 18,
                ColorAlpha(HUD_CONFIG.TEXT_COLOR, animation.contentAlpha)
            )
            
        end
    else
        surface.SetDrawColor(ColorAlpha(markData.color, animation.alpha))
        surface.DrawRect(boxX, topPos.y - HUD_CONFIG.MIN_VERTICAL_OFFSET, currentWidth, 2)
    end
end


hook.Add("EntityRemoved", "CleanupModelPanels", function(ent)
    if markedEntities[ent] and markedEntities[ent].modelPanel then
        markedEntities[ent].modelPanel:Remove()
        markedEntities[ent].modelPanel = nil
    end
end)

local function calculateAimPriority(ent)
    if not IsValid(ent) then return -1 end
    
    local ply = LocalPlayer()
    if not IsValid(ply) then return -1 end
    
    local plyPos = ply:EyePos()
    local aimVector = ply:GetAimVector()
    local entPos = ent:GetPos() + ent:OBBCenter()
    
    local directionToEnt = (entPos - plyPos):GetNormalized()
    local dotProduct = aimVector:Dot(directionToEnt)
    
    return dotProduct
end

-- HUD Drawing
hook.Add("HUDPaint", "DrawMarkersAndEntities", function()
    -- Draw player markers first (unchanged)
    for ent, markData in pairs(markedEntities) do
        if IsValid(ent) and ent:IsPlayer() and UIMarkersPlayers:GetBool() then
            DrawPlayerMarker(ent, markData)
        end
    end
    
    local currentTime = CurTime()
    
	if not UIMarkersEntities:GetBool() then return end

    -- Update aimed entities status
    for ent, markData in pairs(markedEntities) do
        if IsValid(ent) and not ent:IsPlayer() and not ent:IsWeapon() and ent:GetClass() != "func_button" then
            local isAimed = isLookingAtEntity(ent)
            
            if isAimed then
                if not aimedEntities[ent] then
                    aimedEntities[ent] = {
                        time = currentTime,
                        color = EntityColor(ent),
                        reversing = false
                    }
                elseif aimedEntities[ent].reversing then
                    aimedEntities[ent].reversing = false
                end
            elseif aimedEntities[ent] and not aimedEntities[ent].reversing then
                aimedEntities[ent].reversing = true
                aimedEntities[ent].reverseStartTime = currentTime
            end
        end
    end
    
    -- Cleanup invalid entities
    for ent, markData in pairs(aimedEntities) do
        if not IsValid(ent) or not markedEntities[ent] or 
           (markData.reversing and CurTime() - markData.reverseStartTime >= AIM_CONFIG.REVERSE_ANIMATION_TIME) then
            aimedEntities[ent] = nil
        end
    end
    
    -- Create a sorted list of entities to draw
    local entitiesToDraw = {}
    for ent, markData in pairs(aimedEntities) do
        if IsValid(ent) and markedEntities[ent] then
            table.insert(entitiesToDraw, {
                entity = ent,
                markData = markData,
                priority = calculateAimPriority(ent)
            })
        end
    end
    
    -- Sort entities by aim priority (lowest to highest, so closest to aim draws last)
    table.sort(entitiesToDraw, function(a, b)
        return a.priority < b.priority
    end)
    
    -- Draw entities in sorted order
    for _, data in ipairs(entitiesToDraw) do
        DrawEntityMarker(data.entity, data.markData)
    end
end)
