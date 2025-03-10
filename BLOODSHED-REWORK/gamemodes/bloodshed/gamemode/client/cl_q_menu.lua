--Помогал OctoPass специально для режима
-- Radius of the circular selector (the distance between the center of the selector and the icons)
local selectorRadius = 256
-- Coordinates of the selector center on the screen (by default, screen center)
local selectorCenterX, selectorCenterY = ScrW() / 2, ScrH() / 2
-- Icon size (width and height)
local iconSize = 128

-- a list of icons with materials and functions for processing presses
-- Here you can add or remove the icons by replacing the path to the texture and the click processing function
-- Icons can be taken from https://heyter.github.io/js-famfamfam-search/
local icons = {
	{
		material = Material("murdered/icons/surrender.png"),
		onClick = function()
			LocalPlayer():ConCommand("mur_surrender")
		end,
		description = MuR.Language["use_1"]
	},
	{
		material = Material("murdered/icons/ragdoll.png"),
		onClick = function()
			LocalPlayer():ConCommand("mur_ragdoll")
		end,
		description = MuR.Language["use_2"]
	},
	{
		material = Material("murdered/icons/scream.png"),
		onClick = function()
			LocalPlayer():ConCommand("mur_yell")
		end,
		description = MuR.Language["use_3"]
	},
	{
		material = Material("murdered/icons/suicide.png"),
		onClick = function()
			LocalPlayer():ConCommand("kill")
		end,
		description = MuR.Language["use_4"]
	},
	{
		material = Material("murdered/icons/dropweapon.png"),
		onClick = function()
			LocalPlayer():ConCommand("mur_wep_drop")
		end,
		description = MuR.Language["use_5"]
	},
	{
		material = Material("murdered/icons/unload.png"),
		onClick = function()
			LocalPlayer():ConCommand("mur_wep_unload")
		end,
		description = MuR.Language["use_6"]
	},
}

-- The duration of the animation of the appearance/disappearance of the selector (in seconds)
local fadeDuration = 0.2
-- The current state of animation: 0 is completely disappeared, 1 is completely apparently, the value between 0 and 1 is partially apparently
local fadeState = 0
local clickProcessed = false

local cvar = CreateClientConVar("bloodshed_qmenu_key_temp", 36, true, false, "The keycode to use to open the supposed 'qmenu', 11 through 36, 11 being A and 36 being Z")
local key = cvar:GetInt() or KEY_Z

cvars.AddChangeCallback("bloodshed_qmenu_key_temp", function(_, _, k)
	key = tonumber(k)
end )

hook.Add("Think", "CircleSelectorThink", function()
	if input.IsKeyDown(key) and fadeState < 1 and not clickProcessed and LocalPlayer():Alive() then
		fadeState = math.Clamp(fadeState + FrameTime() / fadeDuration, 0, 1)
		MuR.DrawHUD = false
		gui.EnableScreenClicker(true)
	elseif (not input.IsKeyDown(key) or clickProcessed or not LocalPlayer():Alive()) and fadeState > 0 then
		fadeState = math.Clamp(fadeState - FrameTime() / fadeDuration, 0, 1)

		if fadeState == 0 then
			MuR.DrawHUD = true
			gui.EnableScreenClicker(false)
			clickProcessed = false
		end
	end
end)


local function drawCircle(x, y, radius, segments)
	local circle = {}

	for i = 0, segments - 1 do
		local angle = math.rad((i / segments) * -360)
		local cx, cy = math.cos(angle) * radius, math.sin(angle) * radius

		table.insert(circle, {
			x = x + cx,
			y = y + cy
		})
	end

	draw.NoTexture()
	surface.SetDrawColor(255, 255, 255, 100)
	surface.DrawPoly(circle)
end


local function drawBackground()
	local alpha = fadeState * 200
	draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, alpha))
end

local textFadeState = 0
local textFadeDuration = 0.3
local lastHoveredIcon = nil

local function wrapText(text, maxWidth, font)
	local lines = {}
	local words = string.Explode(" ", text)
	surface.SetFont(font)
	local curLine = ""
	local curLineWidth = 0

	for _, word in ipairs(words) do
		local wordWidth, _ = surface.GetTextSize(word)
		local spaceWidth, _ = surface.GetTextSize(" ")

		if curLineWidth + wordWidth + spaceWidth <= maxWidth then
			if curLine == "" then
				curLine = word
			else
				curLine = curLine .. " " .. word
			end

			curLineWidth = curLineWidth + wordWidth + spaceWidth
		else
			table.insert(lines, curLine)
			curLine = word
			curLineWidth = wordWidth + spaceWidth
		end
	end

	if curLine ~= "" then
		table.insert(lines, curLine)
	end

	return lines
end

local voiceicon = Material("murdered/voice.png", "smooth")
local wantedicon = Material("murdered/wanted.png", "smooth")
local arresticon = Material("murdered/handcuffs.png", "smooth")
local policeicon = Material("murdered/police.png", "smooth")
local swaticon = Material("murdered/swat.png", "smooth")
local pistolicon = Material("murdered/pistol.png", "smooth")
local bloodicon = Material("murdered/blood.png", "smooth")
local brokenicon = Material("murdered/broken.png", "smooth")
local bcircleicon = Material("murdered/blurcircle.png", "smooth")
local stamicon = Material("murdered/run.png", "smooth")

local function drawSelector()
	local curTime = CurTime()
	local iconCount = #icons
	drawCircle(selectorCenterX, selectorCenterY, selectorRadius, 64)
	local hoveredIcon = nil
	local lastHoverSoundPlayed = 0
	local ply = LocalPlayer()
	local class = ply:GetNWString('Class')
	local classname = MuR.Language["civilian"]
	local jcolor = Color(100, 150, 200, fadeState * 255)

	if class == "Killer" then
		classname = MuR.Language["murderer"]
		jcolor = Color(200, 50, 50)
	elseif class == "Traitor" then
		classname = MuR.Language["traitor"]
		jcolor = Color(200, 50, 50)
	elseif class == "Attacker" then
		classname = MuR.Language["rioter"]
		jcolor = Color(200, 50, 50)
	elseif class == "Terrorist" or class == "Terrorist2" then
		classname = MuR.Language["terrorist"]
		jcolor = Color(200, 50, 50)
	elseif class == "Maniac" then
		classname = MuR.Language["maniac"]
		jcolor = Color(200, 50, 50)
	elseif class == "Shooter" then
		classname = MuR.Language["shooter"]
		jcolor = Color(200, 50, 50)
	elseif class == "Zombie" then
		classname = MuR.Language["zombie"]
		jcolor = Color(200, 50, 50)
	elseif class == "Hunter" or class == "Defender" then
		classname = MuR.Language["defender"]
		jcolor = Color(50, 75, 175)
	elseif class == "Medic" then
		classname = MuR.Language["medic"]
		jcolor = Color(50, 120, 50)
	elseif class == "Builder" then
		classname = MuR.Language["builder"]
		jcolor = Color(50, 120, 50)
	elseif class == "Soldier" then
		classname = MuR.Language["soldier"]
		jcolor = Color(250, 150, 0)
	elseif class == "Officer" then
		classname = MuR.Language["officer"]
		jcolor = Color(75, 100, 200)
	elseif class == "FBI" then
		classname = MuR.Language["fbiagent"]
		jcolor = Color(75, 100, 200)
	elseif class == "Riot" then
		classname = MuR.Language["riotpolice"]
		jcolor = Color(75, 100, 200)
	elseif class == "SWAT" or class == "ArmoredOfficer" then
		classname = MuR.Language["swat"]
		jcolor = Color(75, 100, 200)
	elseif class == "K_Faction" then
		classname = MuR.Language["k_faction"]
		jcolor = Color(160, 20, 20)
	elseif class == "M_Faction" then
		classname = MuR.Language["m_faction"]
		jcolor = Color(25, 25, 255)
	end

	local money = ply:GetNWFloat('Money')

	if money >= 0 then
		draw.SimpleText("$" .. money, "MuR_Font4", ScrW() / 2, 50, Color(50, 200, 50, fadeState * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end

	draw.SimpleText(ply:GetNWString('Name'), "MuR_Font4", ScrW()/2 , ScrH()/2 - He(10), Color(255, 255, 255, fadeState * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	draw.SimpleText(classname, "MuR_Font6", We(960), ScrH() - He(500), jcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	draw.SimpleText(MuR.Language['guilt:'] .. ply:GetNWFloat('Guilt', 0) .. "%", "MuR_Font2", ScrW()/2, ScrH() - He(10), Color(255, 255, 255, fadeState * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

	if ply:GetNWFloat('ArrestState') > 0 then
		surface.SetDrawColor(255, 255, 255, fadeState * 255)
		surface.SetMaterial(wantedicon)
		surface.DrawTexturedRect(We(20), ScrH() - He(180), We(48), He(48))

		if ply:GetNWFloat('ArrestState') == 1 then
			surface.SetDrawColor(255, 255, 255, fadeState * 255)
			surface.SetMaterial(arresticon)
			surface.DrawTexturedRect(We(80), ScrH() - He(180), We(48), He(48))
		elseif ply:GetNWFloat('ArrestState') == 2 then
			surface.SetDrawColor(255, 255, 255, fadeState * 255)
			surface.SetMaterial(pistolicon)
			surface.DrawTexturedRect(We(80), ScrH() - He(180), We(48), He(48))
		end
	end

	for i, icon in ipairs(icons) do
		local angle = math.rad((i - 1) / iconCount * 360 + curTime * 10)
		local x, y = selectorCenterX + math.cos(angle) * selectorRadius, selectorCenterY + math.sin(angle) * selectorRadius
		local mouseX, mouseY = gui.MousePos()
		local isHovered = math.Distance(mouseX, mouseY, x, y) <= iconSize / 2
		local newSize = isHovered and iconSize * 1.2 or iconSize
		local alpha = fadeState * 255
		surface.SetMaterial(icon.material)
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.DrawTexturedRect(x - newSize / 2, y - newSize / 2, newSize, newSize)

		if isHovered then
			hoveredIcon = icon

			if lastHoveredIcon ~= hoveredIcon then
				if CurTime() - lastHoverSoundPlayed > 0.2 then
					surface.PlaySound("garrysmod/ui_click.wav")
					lastHoverSoundPlayed = CurTime()
				end
			end

			if input.IsMouseDown(MOUSE_LEFT) and not clickProcessed then
				icon.onClick()
				clickProcessed = true
			end
		end
	end

	if hoveredIcon then
		if lastHoveredIcon ~= hoveredIcon then
			textFadeState = 0
			lastHoveredIcon = hoveredIcon
		end

		textFadeState = math.Clamp(textFadeState + FrameTime() / textFadeDuration, 0, 1)
	else
		textFadeState = math.Clamp(textFadeState - FrameTime() / textFadeDuration, 0, 1)
	end

	if lastHoveredIcon and textFadeState > 0 then
		local text = lastHoveredIcon.description or ""
		local font = "MuR_Font3"
		surface.SetFont(font)
		local textW, textH = surface.GetTextSize(text)
		local maxWidth = math.min(textW, ScrW() * 0.8)
		local wrappedText = wrapText(text, maxWidth, font)
		local lines = #wrappedText
		local totalTextHeight = lines * textH
		local startY = selectorCenterY - totalTextHeight / 2

		for i, line in ipairs(wrappedText) do
			local lineWidth, _ = surface.GetTextSize(line)
			local lineX = selectorCenterX - lineWidth / 2
			local lineY = startY + (i + 2) * textH
			local textAlpha = fadeState * textFadeState * 255

			local textColor = (lastHoveredIcon.description == MuR.Language["use_4"])
                          		and Color(199, 0, 0, textAlpha)
                          		or Color(255, 255, 255, textAlpha)
       		draw.SimpleTextOutlined(line, font, lineX, lineY, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, textAlpha))
		end
	end
end

hook.Add("HUDPaint", "CircleSelectorPaint", function()
	if fadeState == 0 then return end
	drawBackground()
	drawSelector()
end)

hook.Add("GUIMouseReleased", "CircleSelectorMouse", function(mouseCode)
	if mouseCode == MOUSE_LEFT then
		if fadeState == 1 then
			shouldClose = true
			keyReleased = false
			fadeDirection = -1
		end

		clickProcessed = false
	end
end)

hook.Add("KeyRelease", "CircleSelectorKeyRelease", function(ply, k)
	if k == key and not keyReleased then
		shouldClose = true
		keyReleased = true
	end
end)