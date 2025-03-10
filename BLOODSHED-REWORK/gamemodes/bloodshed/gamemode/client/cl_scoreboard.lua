local scoreboard = nil
local openmenu = nil

local timeString = ""
local function updtime()
    timer.Create("UpdateTime", 1, 0, function()
        timeString = string.FormattedTime(CurTime(), "%02i:%02i")
    end) return timeString
end 

local function CreateScoreboard()

	if IsValid(scoreboard) then return end
	scoreboard = vgui.Create("DPanel")
	scoreboard:SetSize(We(800), He(660))
	scoreboard:Center()
	scoreboard:AlphaTo(0, 0)
	scoreboard:AlphaTo(255, 0.2)
	scoreboard:MakePopup()

	scoreboard.Paint = function(self, w, h)
		draw.RoundedBox(16, 0, 0, w, h, Color(0, 0, 0, 200))
	end

	

	local title = vgui.Create("DLabel", scoreboard)
	if MuR.GamemodeCount > 0 then
		title:SetText("  " .. MuR.Language["plylist"] .. "  |  " .. MuR.Language["startscreen_gamemode"] .. MuR.Language["gamename"..MuR.GamemodeCount])
	else
		title:SetText("  " .. MuR.Language["plylist"])
	end
	title:SetFont("MuR_Font3")
	title:SetTextColor(Color(255, 255, 255))
	title:SetSize(We(200), He(40))
	title:SetPos(We(150), He(10))
	
	local scrollPanel = vgui.Create("DScrollPanel", scoreboard)
	scrollPanel:SetSize(We(800), He(660))
	scrollPanel:GetVBar():SetWide(0)

	local playerList = vgui.Create("DListLayout", scrollPanel)
	local xx, yy = scrollPanel:GetSize()
	playerList:SetSize(xx - 2, yy)
	playerList:Add(title)

	local localPlayer = LocalPlayer()
	local showDeadOnly = not localPlayer:Alive()
	
	for _, ply in ipairs(player.GetAll()) do
		local killedicon = Material("murdered/result/en/killed.png")
		--if showDeadOnly and !ply:Alive() then continue end -- Skip alive players if local player is dead

		local playerPanel = vgui.Create("DPanel")
		local class = ply:GetNWString("Class", "")
		playerPanel:SetHeight(He(64))
		playerPanel:DockMargin(5, 0, 5, 5)

		if MuR.GamemodeCount == 11 or MuR.GamemodeCount == 12 or MuR.GamemodeCount == 13 then
			if class == "Terrorist2" or class == "Attacker"	or class == "K_Faction" then 
				playerPanel.Paint = function(self, w, h)
					draw.RoundedBox(8, 0, 0, w, h, Color(200, 0, 0, 55))
				end	
			elseif class == "SWAT" or class == "Riot" or class == "M_Faction" then
				playerPanel.Paint = function(self, w, h)
					draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 201, 55))
				end
			end	
		else	
			playerPanel.Paint = function(self, w, h)
				draw.RoundedBox(8, 0, 0, w, h, Color(100, 0, 0, 56))
			end
		end




		if ply ~= LocalPlayer() then
			local muteButton = vgui.Create("DButton", playerPanel)
			muteButton:SetPos(We(760), He(20))
			muteButton:SetSize(We(24), He(24))
			muteButton:SetText("")

			muteButton.Paint = function(self, w, h)
				if IsValid(ply) then
					local muteIcon = ply:IsMuted() and "icon16/sound_mute.png" or "icon16/sound.png"
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(Material(muteIcon))
					surface.DrawTexturedRect(0, 0, w, h)
				end
			end

			muteButton.DoClick = function()
				ply:SetMuted(not ply:IsMuted())
			end
		end

		local nameLabel = vgui.Create("DLabel", playerPanel)
		nameLabel:SetText(ply:Nick())
		nameLabel:SetPos(We(64), He(4))
		nameLabel:SetSize(We(400), He(40))
		nameLabel:SetFont("MuR_Font3")
		nameLabel:SetTextColor(Color(255, 255, 255))

		local nameLabel = vgui.Create("DLabel", playerPanel)
		nameLabel:SetText(MuR.Language["guilt:"] .. ply:GetNWFloat('Guilt') .. "%")
		nameLabel:SetPos(We(64), He(24))
		nameLabel:SetSize(We(400), He(40))
		nameLabel:SetFont("MuR_Font1")
		nameLabel:SetTextColor(Color(255, 255, 255))

		local nameLabel = vgui.Create("DLabel", playerPanel)
		nameLabel:SetText("Ping:  " .. ply:Ping().. "")
		nameLabel:SetPos(We(680), He(12))
		nameLabel:SetSize(We(400), He(40))
		nameLabel:SetFont("MuR_Font2")
		nameLabel:SetTextColor(Color(255, 255, 255))

		local avatarImage = vgui.Create("AvatarImage", playerPanel)
		avatarImage:SetPos(We(5), He(5))
		avatarImage:SetSize(We(56), He(56))
		avatarImage:SetPlayer(ply, 64)

		if showDeadOnly and not ply:Alive() then
			playerPanel.Paint = function(self, w, h)
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(killedicon)
				surface.DrawTexturedRect(0, 0, w - 120, h)
			end
			
		end

		local click = vgui.Create("DButton", playerPanel)
		click:SetSize(playerPanel:GetWide(), playerPanel:GetTall())
		click:SetText("")
		click.Paint = function() end -- Invisible button

		click.DoClick = function()
			if IsValid(openmenu) then openmenu:Remove() end 
			local menu = DermaMenu()
			openmenu = menu

			menu:AddOption("View Profile", function()
				gui.OpenURL("https://steamcommunity.com/profiles/" .. (ply:SteamID64() or ""))
			end)

			menu:AddOption("Copy ID64", function()
				SetClipboardText(ply:SteamID64())
			end)

			menu:AddOption("Mute", function()
				ply:SetMuted(not ply:IsMuted())
			end)

			-- ULX Admin Actions
			if LocalPlayer():query("ulx goto") then
				menu:AddSpacer()
				menu:AddOption("Goto", function()
					RunConsoleCommand("ulx", "goto", ply:Nick())
				end)
			end

			if LocalPlayer():query("ulx bring") then
				menu:AddOption("Bring", function()
					RunConsoleCommand("ulx", "bring", ply:Nick())
				end)
			end

			if LocalPlayer():query("ulx slay") then
				menu:AddOption("Slay", function()
					RunConsoleCommand("ulx", "slay", ply:Nick())
				end)
			end

			if LocalPlayer():query("ulx kick") then
				menu:AddOption("Kick", function()
					Derma_StringRequest(
						"Kick Player",
						"Enter a reason to kick " .. ply:Nick(),
						"",
						function(reason)
							RunConsoleCommand("ulx", "kick", ply:Nick(), reason)
						end
					)
				end)
			end

			if LocalPlayer():query("ulx ban") then
				menu:AddOption("Ban", function()
					Derma_StringRequest(
						"Ban Duration",
						"Enter ban duration (in minutes) for " .. ply:Nick(),
						"",
						
						function(duration)
							Derma_StringRequest(
								"Ban Reason",
								"Enter reason for banning " .. ply:Nick(),
								"",
								function(reason)
									RunConsoleCommand("ulx", "ban", ply:Nick(), duration, reason)
								end
							)
						end
					)
				end)
			end
			menu:Open()
		end

		playerList:Add(playerPanel)
	end

	
	local closeButton = vgui.Create("DButton", scoreboard)
	closeButton:SetSize(We(20), He(20))
	closeButton:SetPos(We(760), He(10))
	closeButton:SetText("X")
	closeButton:SetFont("MuR_Font2")
	closeButton:SetTextColor(Color(255, 255, 255))

	closeButton.Paint = function(self, w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(200, 0, 0, 0))
	end

	closeButton.DoClick = function()
		if IsValid(scoreboard) then
			scoreboard:Remove()
		end
	end
	
end

hook.Add("ScoreboardShow", "ShowScoreboard", function()
	CreateScoreboard()

	return true
end)

hook.Add("ScoreboardHide", "HideScoreboard", function()
	if IsValid(scoreboard) then
		scoreboard:AlphaTo(0, 0.2, 0, function()
			scoreboard:Remove()
		end)
	end

	if IsValid(openmenu) then
		openmenu:Remove()
		openmenu = nil
	end
end)
