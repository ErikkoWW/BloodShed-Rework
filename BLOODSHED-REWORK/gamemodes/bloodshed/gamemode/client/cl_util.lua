local meta = FindMetaTable("Player")

net.Receive("MuR.EntityPlayerColor", function()
	local ent = net.ReadEntity()
	local col = net.ReadVector()

	if IsValid(ent) and isvector(col) then
		function ent:GetPlayerColor()
			return col
		end
	end
end)

hook.Add("Think", "MuR_Execute", function()
	RunConsoleCommand("tacrp_drawhud", 0)
	RunConsoleCommand("tacrp_hud_ammo_number", 0)
	RunConsoleCommand("tacrp_hints", 0)
	RunConsoleCommand("tacrp_drawholsters", 0)
	RunConsoleCommand("r_decals", 9999)
end)

-----Finish Screen-----
local logoicon = Material("murdered/logo.png", "smooth")
local killedicon = Material("murdered/result/en/killed.png")
local losedicon = Material("murdered/result/en/losed.png")
local arrestedicon = Material("murdered/result/en/arrested.png")
local aliveicon = Material("murdered/result/en/alive.png")
local zombieicon = Material("murdered/result/en/infected.png")
if MuR.CurrentLanguage == "ru" then
	logoicon = Material("murdered/logo.png", "smooth")
	killedicon = Material("murdered/result/ru/killed.png")
	losedicon = Material("murdered/result/ru/losed.png")
	arrestedicon = Material("murdered/result/ru/arrested.png")
	aliveicon = Material("murdered/result/ru/alive.png")
	zombieicon = Material("murdered/result/ru/infected.png")
end

local function CreateFinishPanel(type, isvote)
	local text, plytext = "", ""

	if type == "innocent" then
		text = MuR.Language["innocentswin"]
	elseif type == "traitor" then
		text = MuR.Language["traitorwin"]
	end

	if LocalPlayer():GetNWFloat('DeathStatus') == 0 then
		plytext = MuR.Language["yousurvived"]
		surface.PlaySound("murdered/theme/win_theme.wav")
	elseif LocalPlayer():GetNWFloat('DeathStatus') == 3 then
		plytext = MuR.Language["youjailed"]
		surface.PlaySound("murdered/theme/lose_theme.wav")
	else
		plytext = MuR.Language["youdied"]
		surface.PlaySound("murdered/theme/lose_theme.wav")
	end

	hook.Add("Think", "ClickerFixMenu", function()
		gui.EnableScreenClicker(input.IsKeyDown(KEY_LALT))
	end)

	MuR.DrawHUD = false
	local dp = vgui.Create("DFrame")
	dp:SetPos(0, 0)
	dp:SetSize(ScrW(), ScrH())
	dp:SetTitle("")
	dp:ShowCloseButton(false)
	dp:SetDraggable(false)
	dp:AlphaTo(0, 0)
	dp:AlphaTo(255, 2, 0)

	dp:AlphaTo(0, 2, 15, function()
		dp:Remove()
		MuR.DrawHUD = true
		hook.Remove("Think", "ClickerFixMenu")
		gui.EnableScreenClicker(false)
	end)

	dp.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0, 0, 0, 80)
		surface.DrawRect(0, 0, We(600), h)
		surface.SetDrawColor(255, 255, 255)
		--surface.SetMaterial(logoicon)
		--surface.DrawTexturedRect(ScrW() / 2 - We(100), ScrH() / 2 - He(200), We(800), He(500))
		draw.SimpleText(MuR.Language["roundended"], "MuR_Font6", We(50), He(50), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(text, "MuR_Font2", We(50), 100, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(MuR.Language["peoplelist"], "MuR_Font2", We(50), He(210), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(plytext, "MuR_Font3", ScrW() / 2 + We(300), ScrH() / 2 - He(250), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(MuR.Language["holdalt"], "MuR_Font1", ScrW() / 2 + We(300), ScrH() - He(20), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

		if isvote then
			draw.SimpleText(MuR.Language["log_vote"], "MuR_Font1", ScrW() / 2 + We(300), ScrH() - He(200), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(MuR.Language["log_vote_info"]..MuR.Data["VoteLog"].."/"..player.GetCount(), "MuR_Font1", ScrW() / 2 + We(300), ScrH() - He(180), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end
	end

	if isvote then
		local b = vgui.Create("DButton", dp)
		b:SetPos(ScrW() / 2 + We(220), ScrH() - He(170))
		b:SetSize(We(160), He(40))
		b:SetText("")
		b.Paint = function(self, w, h)
			surface.SetDrawColor(50,50,50,200)
			surface.DrawRect(0,0,w,h)
			draw.SimpleText(MuR.Language["log_vote_button"], "MuR_Font2", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		b.DoClick = function(self)
			net.Start("MuR.ShowLogScreen")
			net.SendToServer()
			surface.PlaySound("buttons/combine_button1.wav")
			self:Remove()
		end
	end

	--------------------------------------
	local scrollPanel = vgui.Create("DScrollPanel", dp)
	scrollPanel:SetSize(We(520), He(850))
	scrollPanel:SetPos(We(40), He(240))
	local bgColor = Color(25, 25, 25, 200)
	local textColor = Color(255, 255, 255)
	local nameColor = Color(200, 200, 200)

	for _, ply in pairs(player.GetAll()) do
		local nwc = ply:GetNWString("Class")
		local classname = MuR.Language["civilian"]
		local jcolor = Color(100, 150, 200)

		if nwc == "Killer" then
			classname = MuR.Language["murderer"]
			jcolor = Color(200, 50, 50)
		elseif nwc == "Traitor" then
			classname = MuR.Language["traitor"]
			jcolor = Color(200, 50, 50)
		elseif nwc == "Attacker" then
			classname = MuR.Language["rioter"]
			jcolor = Color(200, 50, 50)
		elseif nwc == "Terrorist" or nwc == "Terrorist2" then
			classname = MuR.Language["terrorist"]
			jcolor = Color(200, 50, 50)
		elseif nwc == "Maniac" then
			classname = MuR.Language["maniac"]
			jcolor = Color(200, 50, 50)
		elseif nwc == "Shooter" then
			classname = MuR.Language["shooter"]
			jcolor = Color(200, 50, 50)
		elseif nwc == "Zombie" then
			classname = MuR.Language["zombie"]
			jcolor = Color(200, 50, 50)
		elseif nwc == "Hunter" or nwc == "Defender" then
			classname = MuR.Language["defender"]
			jcolor = Color(50, 75, 175)
		elseif nwc == "Medic" then
			classname = MuR.Language["medic"]
			jcolor = Color(50, 120, 50)
		elseif nwc == "Builder" then
			classname = MuR.Language["builder"]
			jcolor = Color(50, 120, 50)
		elseif nwc == "Soldier" then
			classname = MuR.Language["soldier"]
			jcolor = Color(250, 150, 0)
		elseif nwc == "Officer" then
			classname = MuR.Language["officer"]
			jcolor = Color(75, 100, 200)
		elseif nwc == "FBI" then
			classname = MuR.Language["fbiagent"]
			jcolor = Color(75, 100, 200)
		elseif nwc == "Riot" then
			classname = MuR.Language["riotpolice"]
			jcolor = Color(75, 100, 200)
		elseif nwc == "SWAT" or nwc == "ArmoredOfficer" then
			classname = MuR.Language["swat"]
			jcolor = Color(75, 100, 200)
		elseif nwc == "K_Faction" then
			classname = MuR.Language["k_faction"]
			jcolor = Color(160, 20, 20)
		elseif nwc == "M_Faction" then
			classname = MuR.Language["m_faction"]
			jcolor = Color(25, 25, 255)
		elseif nwc == "War_RUS" then
			classname = MuR.Language["war_rus2"]
			jcolor = Color(200, 50, 50)
		elseif nwc == "War_UKR" then
			classname = MuR.Language["war_ukr2"]
			jcolor = Color(200, 190, 50)
        end

		local playerPanel = vgui.Create("DPanel", scrollPanel)
		playerPanel:SetSize(We(160), He(64))
		playerPanel:Dock(TOP)
		playerPanel:DockMargin(0, 0, 0, 5)

		playerPanel.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, bgColor)
		end

		local avatar = vgui.Create("AvatarImage", playerPanel)
		avatar:SetSize(We(48), He(48))
		avatar:SetPos(We(8), He(8))
		avatar:SetPlayer(ply, He(64))

		local killed = vgui.Create("DPanel", playerPanel)
		killed:Dock(FILL)

		killed.Paint = function(self, w, h)
			if IsValid(ply) and ply:GetNWFloat('Class') == 'Zombie' then
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(zombieicon)
				surface.DrawTexturedRect(0, 0, w, h)
			elseif IsValid(ply) and (ply:GetNWFloat('DeathStatus') == 0 and ply:Alive() or ply:GetNWFloat('DeathStatus') == 4) then
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(aliveicon)
				surface.DrawTexturedRect(0, 0, w, h)
			elseif IsValid(ply) and ply:GetNWFloat('DeathStatus') == 2 then
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(killedicon)
				surface.DrawTexturedRect(0, 0, w, h)
			elseif IsValid(ply) and ply:GetNWFloat('DeathStatus') == 3 then
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(arrestedicon)
				surface.DrawTexturedRect(0, 0, w, h)
			else
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(losedicon)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end

		local name = vgui.Create("DLabel", playerPanel)
		name:SetText(ply:Nick() .. " (" .. ply:GetNWString('Name') .. ")")
		name:SetFont("DermaDefaultBold")
		name:SetTextColor(nameColor)
		name:SetPos(We(64), He(8))
		name:SetSize(We(380), He(24))
		local class = vgui.Create("DLabel", playerPanel)
		class:SetText(classname)
		class:SetTextColor(jcolor)
		class:SetPos(We(64), He(32))
		class:SetSize(We(380), He(16))

		local b = vgui.Create("DButton", avatar)
		b:SetPos(0, 0)
		b:SetSize(We(48), He(48))
		b:SetText("")
		b.id = ply:SteamID64() or ""
		b.Paint = function() end
		b.DoClick = function(self)
			gui.OpenURL("https://steamcommunity.com/profiles/" .. self.id)
		end
	end
end

net.Receive("MuR.FinalScreen", function()
	local str = net.ReadString()
	local vote = net.ReadBool()
	CreateFinishPanel(str, vote)
end)

-----Log Screen-----

-----Help Panel-----
local helppanel = nil

local function OpenHelpHTML()
	if IsValid(helppanel) then return end
	helppanel = vgui.Create("DFrame")
	helppanel:SetTitle(MuR.Language["help"])
	helppanel:SetSize(ScrW() * 0.75, ScrH() * 0.75)
	helppanel:Center()
	helppanel:MakePopup()

	helppanel.Paint = function(self, w, h)
		surface.SetDrawColor(20, 20, 20, 240)
		surface.DrawRect(0, 0, w, h)
	end

	local html = vgui.Create("DHTML", helppanel)
	html:Dock(FILL)
	html:OpenURL("https://www.google.com") -- doesn't work anymore
end

hook.Add("Think", "MuR_HelpWebsite", function()
	if input.IsKeyDown(KEY_F3) then
		OpenHelpHTML()
	end
end)

-----ViewPunch Remake-----
local PUNCH_DAMPING = 9
local PUNCH_SPRING_CONSTANT = 65
local vp_is_calc = false
local vp_punch_angle = Angle()
local vp_punch_angle_velocity = Angle()
local vp_punch_angle_last = vp_punch_angle

hook.Add("Think", "mur_viewpunch_decay", function()
	if not vp_punch_angle:IsZero() or not vp_punch_angle_velocity:IsZero() then
		vp_punch_angle = vp_punch_angle + vp_punch_angle_velocity * FrameTime()
		local damping = 1 - (PUNCH_DAMPING * FrameTime())

		if damping < 0 then
			damping = 0
		end

		vp_punch_angle_velocity = vp_punch_angle_velocity * damping
		local spring_force_magnitude = math.Clamp(PUNCH_SPRING_CONSTANT * FrameTime(), 0, 0.2 / FrameTime())
		vp_punch_angle_velocity = vp_punch_angle_velocity - vp_punch_angle * spring_force_magnitude
		local x, y, z = vp_punch_angle:Unpack()
		vp_punch_angle = Angle(math.Clamp(x, -89, 89), math.Clamp(y, -179, 179), math.Clamp(z, -89, 89))
	else
		vp_punch_angle = Angle()
		vp_punch_angle_velocity = Angle()
	end
end)

hook.Add("Think", "mur_viewpunch_apply", function()
	if vp_punch_angle:IsZero() and vp_punch_angle_velocity:IsZero() then return end
	if LocalPlayer():InVehicle() then return end
	LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles() + vp_punch_angle - vp_punch_angle_last)
	vp_punch_angle_last = vp_punch_angle
end)

local function SetViewPunchAngles(angle)
	if not angle then return end
	vp_punch_angle = angle
end

local function SetViewPunchVelocity(angle)
	if not angle then return end
	vp_punch_angle_velocity = angle * 20
end

local function Viewpunch(angle)
	if not angle then return end
	vp_punch_angle_velocity = vp_punch_angle_velocity + angle * 20
end

function meta:ViewPunchClient(angle)
	--if not IsFirstTimePredicted() then return end
	Viewpunch(angle)
end

net.Receive("MuR.ViewPunch", function()
	local ang = net.ReadAngle()
	Viewpunch(ang)
end)

-----Move Fix-----

hook.Add("SetupMove", "MuR_Move", function(ply, mv, cmd, class)
	local hunger = ply:GetNWFloat('Hunger')
	local stam = ply:GetNWFloat('Stamina')
	local class = ply:GetNWString("Class", "")

	if class == "Zombie" then return end

	if not ply:GetNWBool('GeroinUsed') then
		if ply:IsSprinting() and ply:GetVelocity():Length() > 60 then
			ply:SetNWFloat('Stamina', math.Clamp(stam - FrameTime() / 0.2, 0, 100))
			ply.RunMult = math.min(ply.RunMult + FrameTime() * 180, ply:GetRunSpeed())
			mv:SetMaxSpeed(ply:GetWalkSpeed() + ply.RunMult)
			mv:SetMaxClientSpeed(ply:GetWalkSpeed() + ply.RunMult)
		elseif ply:GetVelocity():Length() < 60 then
			ply:SetNWFloat('Stamina', math.Clamp(stam + FrameTime() / 0.2, 0, 100))
			ply.RunMult = 0
		else
			ply:SetNWFloat('Stamina', math.Clamp(stam + FrameTime(), 0, 100))
			ply.RunMult = 0
		end

		if MuR.Gamemode ~= 6 then
			if stam <= 0 then
				ply.RunMult = 0
			end

			if stam < 10 then
				mv:SetMaxSpeed(ply:GetWalkSpeed() + ply.RunMult / 4)
				mv:SetMaxClientSpeed(ply:GetWalkSpeed() + ply.RunMult / 4)
				ply:SetJumpPower(100)
			elseif stam < 40 then
				mv:SetMaxSpeed(ply:GetWalkSpeed() + ply.RunMult / 2)
				mv:SetMaxClientSpeed(ply:GetWalkSpeed() + ply.RunMult / 2)
				ply:SetJumpPower(130)
			else
				ply:SetJumpPower(160)
			end

			if ply:GetNWBool('LegBroken') then
				ply:SetJumpPower(80)
			end

			if hunger < 20 or ply:GetNWBool('LegBroken') then
				mv:SetMaxSpeed(ply:GetWalkSpeed() / 1.5)
				mv:SetMaxClientSpeed(ply:GetWalkSpeed() / 1.5)
			elseif ply:GetNWFloat('BleedLevel') >= 3 then
				mv:SetMaxSpeed(ply:GetWalkSpeed() / 1.2)
				mv:SetMaxClientSpeed(ply:GetWalkSpeed() / 1.2)
			elseif hunger < 50 or ply:GetNWFloat('BleedLevel') == 2 or ply:GetNWFloat('Guilt') >= 40 then
				mv:SetMaxSpeed(ply:GetWalkSpeed())
				mv:SetMaxClientSpeed(ply:GetWalkSpeed())
			end

			if ply:GetNWFloat('peppereffect') > CurTime() then
				mv:SetMaxClientSpeed(100)
			end
		end
	end
end)

-----Settings Menu-----
local OptionsTab = {
	{
		name = "",
		convar = "",
		type = "bool"
	},
}

local function CreateSettingsPanel()
	local dp = vgui.Create("DFrame")
	dp:SetSize(We(320), He(600))
	dp:Center()
	dp:SetTitle("")
	dp:MakePopup()
	dp:ShowCloseButton(true)
	dp:SetDraggable(true)
	dp:AlphaTo(0, 0)
	dp:AlphaTo(255, 1, 0)

	dp.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 0, 240)
		surface.DrawRect(0, 0, w, h)
		draw.SimpleText(MuR.Language["gamesettings"], "MuR_Font2", We(50), He(15), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	local scrollPanel = vgui.Create("DScrollPanel", dp)
	scrollPanel:SetSize(We(320), He(570))
	scrollPanel:SetPos(We(0), He(30))
end
concommand.Add("mur_settings", CreateSettingsPanel)

local function CreateCharacterVoicePanel()
	local frame = vgui.Create("DFrame")
	frame:SetSize(We(300), He(300))
	frame:Center()
	frame:SetTitle(MuR.Language["dialogue_menu"])
	frame:MakePopup()
	frame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))
	end

	local scrollPanel = vgui.Create("DScrollPanel", frame)
	scrollPanel:Dock(FILL)

	for i = 1, 14 do
		local text = MuR.Language["dialogue_menu"..i]
		local button = scrollPanel:Add("DButton")
		button:SetText(text)
		button:Dock(TOP)
		button:DockMargin(2, 5, 2, 0)
		button.DoClick = function()
			net.Start("MuR.VoiceLines")
			net.WriteFloat(i)
			net.SendToServer()
			frame:Remove()
		end
	end
end
concommand.Add("mur_voicepanel", CreateCharacterVoicePanel)

local PLAYER = FindMetaTable("Player")

function PLAYER:SmoothNetworkMovement()
    if CLIENT then
        local predicted_pos = self:GetPos() + self:GetVelocity() * FrameTime()
        self:SetPos(LerpVector(0.2, self:GetPos(), predicted_pos))
    end

    if SERVER then
        self.PositionHistory = self.PositionHistory or {}
        table.insert(self.PositionHistory, self:GetPos())
		
        if #self.PositionHistory > 10 then
            table.remove(self.PositionHistory, 1)
        end
    end
end


hook.Add("Move", "SmoothPlayerMovement", function(ply)
    ply:SmoothNetworkMovement()
end)