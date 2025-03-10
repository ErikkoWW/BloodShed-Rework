MuR.DrawHUD = true
MuR.ShowDeathLog = false
MuR.GamemodeCount = 0
MuR.Data = {}
MuR.Data["PoliceState"] = 0
MuR.Data["PoliceArriveTime"] = 0
MuR.Data["War"] = false
MuR.Data["ExfilPos"] = Vector()

net.Receive("MuR.SendDataToClient", function()
	local str = net.ReadString()
	local value = net.ReadTable()[1]
	MuR.Data[str] = value
end)

net.Receive("MuR.PlaySoundOnClient", function()
	local str = net.ReadString()
	surface.PlaySound(str)
end)

local hide = {
	["CHudHealth"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudBattery"] = true,
	["CHudCrosshair"] = true,
	["CHudDamageIndicator"] = true,
}

local voiceicon = Material("murdered/voice.png", "smooth")
local wantedicon = Material("murdered/wanted.png", "smooth")
local arresticon = Material("murdered/handcuffs.png", "smooth")
local policeicon = Material("murdered/police.png", "smooth")
local swaticon = Material("murdered/swat.png", "smooth")
local assaulticon = Material("murdered/assault.png")
local helipadicon = Material("murdered/exfil.png")
local pistolicon = Material("murdered/pistol.png", "smooth")
local bloodicon = Material("murdered/blood.png", "smooth")
local brokenicon = Material("murdered/broken.png", "smooth")
local bcircleicon = Material("murdered/blurcircle.png", "smooth")
local stamicon = Material("murdered/run.png", "smooth")
local vinmat = Material("murdered/vin.png", "smooth")
local axonmat = Material("murdered/axon.png", "smooth")
local cal1 = Material("ui/9mm.png")
local cal2 = Material("ui/762.png")
local cal3 = Material("ui/556.png")
local cal4 = Material("ui/357.png")
local cal5 = Material("ui/12gauge.png")

function We(x)
	return x / 1920 * ScrW()
end

function He(y)
	return y / 1080 * ScrH()
end

hook.Add("HUDShouldDraw", "HideHUD", function(name)
	if hide[name] then return false end
end)

hook.Add("DrawDeathNotice", "DisableKillfeed", function() return 0, 0 end)

local icon = Material("icon32/unmuted.png")
local function iconfunc()
	surface.SetDrawColor(0, 0, 0, 0)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(200, 200, 200, 200)
end

local ply = player.GetAll()

--[[]
hook.Add("PlayerStartVoice", "ImageOnVoice", function(ply)
    if not ply:Alive() and ply:GetObserverMode() == OBS_MODE_NONE then
        hook.Add("HUDPaint", "ImageOnVoice", iconfunc)
    end
end)

hook.Add("PlayerEndVoice", "ImageOnVoice", function(ply)
    if not ply:Alive() and ply:GetObserverMode() == OBS_MODE_NONE then
        hook.Remove("HUDPaint", "ImageOnVoice", iconfunc)
    end
end)]]

local function shouldShowVoiceIcon(ply)
    if not IsValid(ply) then return false end
    return not ply:Alive()
end

hook.Add("PlayerStartVoice", "ImageOnVoice", function(ply)
    if shouldShowVoiceIcon(ply) then
        hook.Add("HUDPaint", "ImageOnVoice", iconfunc)
    else
        hook.Remove("HUDPaint", "ImageOnVoice")
        return true
    end
end)

hook.Add("PlayerEndVoice", "ImageOnVoice", function(ply)
    if shouldShowVoiceIcon(ply) then
        hook.Remove("HUDPaint", "ImageOnVoice")
    end
end)

local detector_delay = 0
local stamalpha = 0
local wepalpha = 0

hook.Add("HUDPaint", "MurderedHUD", function()
	local ply = LocalPlayer()
	local guilt = tonumber(ply:GetNWFloat("Guilt", 0))

	if guilt >= 90 then
		local alpha = math.cos(CurTime() * 4) * 255

		if alpha < 0 then
			alpha = alpha * -1
		end

		draw.SimpleText(MuR.Language["guiltwarning"], "MuR_Font2", ScrW() / 2, ScrH() / 2 - He(300), Color(200, 200 - ((guilt / 100) * 200), 200 - ((guilt / 100) * 200), alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end

	if MuR.DrawHUD and ply:Alive() then
		if ply:GetNWString("Class") == "Zombie" then
			surface.SetDrawColor(100, 0, 0, 50)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		else
			if MuR.Data["ExfilPos"] and MuR.Data["PoliceState"] == 8 then
				if MuR.Data["ExfilPos"]:DistToSqr(ply:GetPos()) < 40000 then
					local alpha = math.abs(math.cos(CurTime() * 2) * 255)
					draw.SimpleText(MuR.Language["evac_zone"], "MuR_Font3", ScrW()/2, He(100), Color(200, 200, 20, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				local pos = (MuR.Data["ExfilPos"] + Vector(0,0,32)):ToScreen()
				surface.SetMaterial(helipadicon)
				surface.SetDrawColor(255,255,255,200)
				surface.DrawTexturedRect(pos.x - 24, pos.y - 24, 48, 48)
				draw.SimpleText(math.floor(ply:GetPos():Distance(MuR.Data["ExfilPos"]) / 80) .. "m", "MuR_Font1", pos.x + 20, pos.y, Color(255,255,255,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end

		if ply:GetNWString("Class") == "War_RUS" then
			if detector_delay < CurTime() then
				detector_delay = CurTime() + math.random(120, 240)
				local tab = {}

				for _, ply in ipairs(player.GetAll()) do
					if ply:GetNWString("Class") == "War_UKR" and ply:Alive() then
						local rnd = VectorRand(-1000, 1000)
						rnd.z = ply:GetPos().z
						tab[#tab + 1] = ply:GetPos() + rnd
					end
				end

				if #tab > 0 then
					local alpha = 255
					local pos = tab[math.random(1, #tab)]
					surface.PlaySound("ambient/levels/prison/radio_random" .. math.random(1, 15) .. ".wav")

					hook.Add("HUDPaint", "WARDetector", function()
						local pr = pos:ToScreen()
						alpha = alpha - FrameTime() * 5
						surface.SetMaterial(stamicon)
						surface.SetDrawColor(200, 200, 50, alpha)
						surface.DrawTexturedRect(pr.x - 16, pr.y - 16, 32, 32)
						draw.SimpleText(MuR.Language["ruarmedforcesintelligence"] .. math.floor(ply:GetPos():Distance(pos) / 80) .. "m", "MuR_Font2", pr.x + 20, pr.y - 10, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						draw.SimpleText(MuR.Language["enemythere"], "MuR_Font1", pr.x + 20, pr.y + 8, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

						if alpha <= 0 or not MuR.DrawHUD then
							hook.Remove("HUDPaint", "WARDetector")
						end
					end)
				end
			end
		elseif ply:GetNWString("Class") == "War_UKR" then
			if detector_delay < CurTime() then
				detector_delay = CurTime() + math.random(120, 240)
				local tab = {}

				for _, ply in ipairs(player.GetAll()) do
					if ply:GetNWString("Class") == "War_RUS" and ply:Alive() then
						local rnd = VectorRand(-1000, 1000)
						rnd.z = ply:GetPos().z
						tab[#tab + 1] = ply:GetPos() + rnd
					end
				end

				if #tab > 0 then
					local alpha = 255
					local pos = tab[math.random(1, #tab)]
					surface.PlaySound("ambient/levels/prison/radio_random" .. math.random(1, 15) .. ".wav")

					hook.Add("HUDPaint", "WARDetector", function()
						local pr = pos:ToScreen()
						alpha = alpha - FrameTime() * 5
						surface.SetMaterial(stamicon)
						surface.SetDrawColor(200, 200, 50, alpha)
						surface.DrawTexturedRect(pr.x - 16, pr.y - 16, 32, 32)
						draw.SimpleText(MuR.Language["ukarmedforcesintelligence"] .. math.floor(ply:GetPos():Distance(pos) / 80) .. "m", "MuR_Font2", pr.x + 20, pr.y - 10, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						draw.SimpleText(MuR.Language["enemythere"], "MuR_Font1", pr.x + 20, pr.y + 8, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

						if alpha <= 0 or not MuR.DrawHUD then
							hook.Remove("HUDPaint", "WARDetector")
						end
					end)
				end
			end
		else
			detector_delay = CurTime() + math.random(60, 120)
		end

		local wep = ply:GetActiveWeapon()
		local drawweapon = IsValid(wep) and wep:GetPrintName()

		if drawweapon then
			local w, h = ScrW(), ScrH()
			local ammo = wep:Clip1()
			local maxammo = wep:GetMaxClip1()
			local ammotype = wep:GetPrimaryAmmoType()

			if ammo == maxammo + 1 and ammo > -1 then
				draw.SimpleText(MuR.Language["fullmag+"], "MuR_Font4", w - We(40), h - He(100), Color(0, 155, 3, wepalpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			elseif ammo == maxammo and ammo > -1 then
				draw.SimpleText(MuR.Language["fullmag"], "MuR_Font4", w - We(40), h - He(100), Color(0, 155, 3, wepalpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			elseif ammo >= maxammo - maxammo / 3 and ammo > -1 then
				draw.SimpleText(MuR.Language["almostfullmag"], "MuR_Font4", w - We(40), h - He(100), Color(152, 201, 7, wepalpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			elseif ammo >= maxammo / 2 then
				draw.SimpleText(MuR.Language["halfmag"], "MuR_Font4", w - We(40), h - He(100), Color(225, 217, 5, wepalpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			elseif ammo <= maxammo - maxammo / 4 and ammo > 0 and ammo > -1 then
				draw.SimpleText(MuR.Language["almostemptymag"], "MuR_Font4", w - We(40), h - He(100), Color(177, 126, 7, wepalpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			elseif ammo == 0 and ammo > -1 then
				draw.SimpleText(MuR.Language["emptymag"], "MuR_Font4", w - We(40), h - He(100), Color(255, 0, 0, wepalpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			end

			if wep:GetPrimaryAmmoType() == 3 then
				surface.SetMaterial(cal1)
				surface.SetDrawColor(255, 255, 255, wepalpha)
				surface.DrawTexturedRect(w - We(85), h - He(110), We(50), He(50))
			elseif wep:GetPrimaryAmmoType() == 1 or wep:GetPrimaryAmmoType() == 13 then
				surface.SetMaterial(cal2)
				surface.SetDrawColor(255, 255, 255, wepalpha)
				surface.DrawTexturedRect(w - We(140), h - He(140), We(100), He(90))
			elseif wep:GetPrimaryAmmoType() == 4 then
				surface.SetMaterial(cal3)
				surface.SetDrawColor(255, 255, 255, wepalpha)
				surface.DrawTexturedRect(w - We(130), h - He(140), We(100), He(100))
			elseif wep:GetPrimaryAmmoType() == 5 then
				surface.SetMaterial(cal4)
				surface.SetDrawColor(255, 255, 255, wepalpha)
				surface.DrawTexturedRect(w - We(103), h - He(140), We(100), He(100))
			elseif wep:GetPrimaryAmmoType() == 7 then
				surface.SetMaterial(cal5)
				surface.SetDrawColor(255, 255, 255, wepalpha)
				surface.DrawTexturedRect(w - We(109), h - He(130), We(70), He(70))
			end
		end

		if input.IsKeyDown(KEY_E) then
			wepalpha = 255
		else
			wepalpha = math.max(wepalpha - FrameTime() * 255, 0)
		end

		local tr = ply:GetEyeTrace().Entity

		if IsValid(tr) and tr:GetPos():DistToSqr(ply:GetPos()) < 10000 then
			local candraw = ply:GetNWEntity("RD_EntCam") ~= tr

			if tr:IsPlayer() and tr:GetNWString("Class") == "Zombie" then
				candraw = false
			end

			if candraw then
				if tr:GetClass() == "prop_ragdoll" then
					local parsed = markup.Parse("<font=MuR_Font0><colour=255,255,255>E<colour=200,200,0>" .. MuR.Language["ragdoll_use"])
					parsed:Draw(ScrW() / 2, ScrH() / 2 + He(30), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				draw.SimpleText((tr.Nick and tr:Nick()) or tr:GetNWString("Name"), "MuR_Font5", ScrW() / 2, ScrH() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			if tr:GetNWBool("BreakableThing") and tr.Health and tr:Health() > 0 then
				local parsed = markup.Parse("<font=MuR_Font1><colour=255,255,255>" .. MuR.Language["strength"] .. "<colour=200," .. math.floor((tr:Health() / tr:GetMaxHealth()) * 200) .. "," .. math.floor((tr:Health() / tr:GetMaxHealth()) * 200) .. ">" .. tr:Health() .. "")
				parsed:Draw(ScrW() / 2, ScrH() / 2 + He(30), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		local hunger = ply:GetNWFloat("Hunger")

		if hunger < 20 then
			draw.SimpleText(MuR.Language["hungermax"], "MuR_Font2", ScrW() / 2, ScrH() - He(10), Color(200, 50, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		elseif hunger < 50 then
			draw.SimpleText(MuR.Language["hungermedium"], "MuR_Font2", ScrW() / 2, ScrH() - He(10), Color(200, 150, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		elseif hunger < 80 then
			draw.SimpleText(MuR.Language["hungersmall"], "MuR_Font2", ScrW() / 2, ScrH() - He(10), Color(225, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end

		if ply:IsKiller() then
			local stab = ply:GetNWFloat("Stability")
			local stage = 0

			if stab < 60 then
				draw.SimpleText(MuR.Language["stability_message"], "MuR_Font1", We(20), ScrH() - He(10), Color(200, 20, 20, math.abs(math.sin(CurTime()*2)*255)), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			end

			if stab < 10 then
				for i = 1, math.random(16,24) do
					draw.SimpleText(MuR.Language["kill_them"], "MuR_Font3", We(math.random(-100, ScrW()+100)), He(math.random(-100, ScrH()+100)), Color(200, 20, 20, math.abs(math.sin(CurTime()*4)*255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				if math.random(1,50) == 1 then
					ply:ViewPunchClient(AngleRand(-5,5))
				end
				surface.SetDrawColor(20,0,0,math.abs(math.sin(CurTime()*4)*255))
				surface.SetMaterial(vinmat)
				surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			elseif stab < 25 then
				for i = 1, math.random(8,16) do
					draw.SimpleText(MuR.Language["kill_them"], "MuR_Font2", We(math.random(-100, ScrW()+100)), He(math.random(-100, ScrH()+100)), Color(220, 160, 160, math.abs(math.sin(CurTime()*3)*255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				if math.random(1,75) == 1 then
					ply:ViewPunchClient(AngleRand(-3,3))
				end
				surface.SetDrawColor(10,0,0,math.abs(math.sin(CurTime()*3)*200))
				surface.SetMaterial(vinmat)
				surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			elseif stab < 40 then
				for i = 1, math.random(4,8) do
					draw.SimpleText(MuR.Language["kill_them"], "MuR_Font1", We(math.random(-100, ScrW()+100)), He(math.random(-100, ScrH()+100)), Color(255, 255, 255, math.abs(math.sin(CurTime()*2)*255)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				if math.random(1,100) == 1 then
					ply:ViewPunchClient(AngleRand(-1,1))
				end
				surface.SetDrawColor(0,0,0,math.abs(math.sin(CurTime()*2)*150))
				surface.SetMaterial(vinmat)
				surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			elseif stab < 60 then
				for i = 1, math.random(1,4) do
					draw.SimpleText(MuR.Language["kill_them"], "MuR_Font1", We(math.random(-100, ScrW()+100)), He(math.random(-100, ScrH()+100)), Color(255, 255, 255, math.abs(math.sin(CurTime())*20)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end



			local parsed = markup.Parse("<font=MuR_Font2><colour=255,255,255>"..MuR.Language["stability"].."<colour=200," .. math.floor(stab/100 * 200) .. "," .. math.floor(stab/100 * 200) .. ">" .. math.floor(stab) .. "%")
			parsed:Draw(20, ScrH() - He(30), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		end

		local stam = math.Clamp(ply:GetNWFloat("Stamina") , 0, 100)

		if stam < 95 then
			stamalpha = math.Clamp(stamalpha + FrameTime(), 0, 100)
		else
			stamalpha = math.Clamp(stamalpha - FrameTime(), 0, 100)
		end

		surface.SetMaterial(stamicon)
		surface.SetDrawColor(200, 3 * stam , 0, 255 * stamalpha)
		surface.DrawTexturedRect(ScrW() - We(48), ScrH() / 2 - He(190), 32, 32)
		surface.SetDrawColor(20, 20, 20, 50 * stamalpha)
		surface.DrawRect(ScrW() - We(40), ScrH() / 2 - He(150), 15, 300)
		surface.SetDrawColor(200, 3 * stam , 0, 255 * stamalpha)
		surface.DrawRect(ScrW() - We(38), ScrH() / 2 - He(148), 11, 2.96 * stam)
		local lvl = ply:GetNWFloat("BleedLevel")
		local hbl = ply:GetNWBool("HardBleed")

		if lvl == 1 and not hbl then
			surface.SetMaterial(bloodicon)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(ScrW() - We(48), ScrH() / 2 - He(250), 36, 36)
			local alpha = math.cos(CurTime()) * 255

			if alpha < 0 then
				alpha = alpha * -1
			end

			draw.SimpleText(MuR.Language["smallbleed"], "MuR_Font2", ScrW() - We(50), ScrH() / 2 - He(232), Color(200, 100, 100, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		elseif lvl == 2 and not hbl then
			surface.SetMaterial(bloodicon)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(ScrW() - We(48), ScrH() / 2 - He(250), 36, 36)
			surface.SetMaterial(bloodicon)
			surface.SetDrawColor(200, 200, 200)
			surface.DrawTexturedRect(ScrW() - We(35), ScrH() / 2 - He(230), 24, 24)
			local alpha = math.cos(CurTime() * 2) * 255

			if alpha < 0 then
				alpha = alpha * -1
			end

			draw.SimpleText(MuR.Language["mediumbleed"], "MuR_Font2", ScrW() - We(50), ScrH() / 2 - He(232), Color(200, 20, 20, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		elseif lvl >= 3 and not hbl then
			surface.SetMaterial(bloodicon)
			surface.SetDrawColor(175, 175, 175)
			surface.DrawTexturedRect(ScrW() - We(48), ScrH() / 2 - He(250), 36, 36)
			surface.SetMaterial(bloodicon)
			surface.SetDrawColor(150, 150, 150)
			surface.DrawTexturedRect(ScrW() - We(35), ScrH() / 2 - He(230), 24, 24)
			surface.SetMaterial(bloodicon)
			surface.SetDrawColor(125, 125, 125)
			surface.DrawTexturedRect(ScrW() - We(54), ScrH() / 2 - He(228), 30, 30)
			local alpha = math.cos(CurTime() * 4) * 255

			if alpha < 0 then
				alpha = alpha * -1
			end

			draw.SimpleText(MuR.Language["highbleed"], "MuR_Font2", ScrW() - We(50), ScrH() / 2 - He(232), Color(180, 0, 0, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		elseif hbl then
			surface.SetMaterial(bloodicon)
			surface.SetDrawColor(175, 175, 175)
			surface.DrawTexturedRect(ScrW() - We(48), ScrH() / 2 - He(250), 36, 36)
			surface.SetMaterial(bloodicon)
			surface.SetDrawColor(150, 150, 150)
			surface.DrawTexturedRect(ScrW() - We(35), ScrH() / 2 - He(230), 24, 24)
			surface.SetMaterial(bloodicon)
			surface.SetDrawColor(125, 125, 125)
			surface.DrawTexturedRect(ScrW() - We(54), ScrH() / 2 - He(228), 30, 30)
			local alpha = math.cos(CurTime() * 4) * 255

			if alpha < 0 then
				alpha = alpha * -1
			end

			draw.SimpleText(MuR.Language["criticalbleed"], "MuR_Font2", ScrW() - We(50), ScrH() / 2 - He(232), Color(160, 0, 0, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		if ply:GetNWBool("LegBroken") then
			surface.SetMaterial(brokenicon)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(ScrW() - We(48), ScrH() / 2 - He(290), 36, 36)
			local alpha = math.cos(CurTime() * 4) * 255

			if alpha < 0 then
				alpha = alpha * -1
			end

			draw.SimpleText(MuR.Language["legbroken"], "MuR_Font2", ScrW() - We(55), ScrH() / 2 - He(272), Color(180, 0, 0, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
	end

	if MuR.Data["PoliceState"] == 1 then
		local time = MuR.Data["PoliceArriveTime"] - CurTime() + 0.5
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(policeicon)
		surface.DrawTexturedRect(We(20 + math.cos(CurTime() * 4) * 8), He(20 + math.sin(CurTime() * 4) * 8), We(96), He(96))
		local red = math.cos(CurTime() * 6) > 0
		local alpha = math.cos(CurTime() * 10) * 200

		if alpha < 0 then
			alpha = alpha * -1
		end

		if red then
			surface.SetDrawColor(25, 25, 200, alpha)
			surface.SetMaterial(bcircleicon)
			surface.DrawTexturedRect(We(20 + math.cos(CurTime() * 4) * 8), He(15 + math.sin(CurTime() * 4) * 8), We(96), He(96))
		else
			surface.SetDrawColor(200, 25, 25, alpha)
			surface.SetMaterial(bcircleicon)
			surface.DrawTexturedRect(We(30 + math.cos(CurTime() * 4) * 8), He(10 + math.sin(CurTime() * 4) * 8), We(96), He(96))
		end

		draw.SimpleText(MuR.Language["policearecoming"], "MuR_Font3", We(140 + math.cos(CurTime() * 4) * 8), He(70 + math.sin(CurTime() * 4) * 8), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.FormattedTime(time, "%02i:%02i"), "MuR_Font2", We(140 + math.cos(CurTime() * 4) * 8), He(90 + math.sin(CurTime() * 4) * 8), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	elseif MuR.Data["PoliceState"] == 2 then
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(policeicon)
		surface.DrawTexturedRect(We(20 + math.cos(CurTime() * 4) * 4), He(20 + math.sin(CurTime() * 4) * 4), We(96), He(96))
		local red = math.cos(CurTime() * 6) > 0
		local alpha = math.cos(CurTime() * 10) * 200

		if alpha < 0 then
			alpha = alpha * -1
		end

		if red then
			surface.SetDrawColor(25, 25, 200, alpha)
			surface.SetMaterial(bcircleicon)
			surface.DrawTexturedRect(We(20 + math.cos(CurTime() * 4) * 4), He(15 + math.sin(CurTime() * 4) * 4), We(96), He(96))
		else
			surface.SetDrawColor(200, 25, 25, alpha)
			surface.SetMaterial(bcircleicon)
			surface.DrawTexturedRect(We(30 + math.cos(CurTime() * 4) * 4), He(10 + math.sin(CurTime() * 4) * 4), We(96), He(96))
		end

		draw.SimpleText(MuR.Language["policearehere"], "MuR_Font3", We(140 + math.cos(CurTime() * 4) * 4), He(70 + math.sin(CurTime() * 4) * 4), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	elseif MuR.Data["PoliceState"] == 3 then
		local time = MuR.Data["PoliceArriveTime"] - CurTime() + 0.5
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(swaticon)
		surface.DrawTexturedRect(We(20 + math.cos(CurTime() * 4) * 8), He(20 + math.sin(CurTime() * 4) * 8), We(96), He(96))
		local red = math.cos(CurTime() * 6) > 0
		local alpha = math.cos(CurTime() * 10) * 175

		if alpha < 0 then
			alpha = alpha * -1
		end

		if red then
			surface.SetDrawColor(25, 25, 200, alpha)
			surface.SetMaterial(bcircleicon)
			surface.DrawTexturedRect(We(20 + math.cos(CurTime() * 4) * 8), He(10 + math.sin(CurTime() * 4) * 8), We(96), He(96))
		else
			surface.SetDrawColor(200, 25, 25, alpha)
			surface.SetMaterial(bcircleicon)
			surface.DrawTexturedRect(We(30 + math.cos(CurTime() * 4) * 8), He(5 + math.sin(CurTime() * 4) * 8), We(96), He(96))
		end

		draw.SimpleText(MuR.Language["swatarecoming"], "MuR_Font3", We(140 + math.cos(CurTime() * 4) * 8), He(70 + math.sin(CurTime() * 4) * 8), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.FormattedTime(time, "%02i:%02i"), "MuR_Font2", We(140 + math.cos(CurTime() * 4) * 8), He(90 + math.sin(CurTime() * 4) * 8), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	elseif MuR.Data["PoliceState"] == 4 then
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(swaticon)
		surface.DrawTexturedRect(We(20 + math.cos(CurTime() * 4) * 4), He(20 + math.sin(CurTime() * 4) * 4), We(96), He(96))
		local red = math.cos(CurTime() * 6) > 0
		local alpha = math.cos(CurTime() * 10) * 175

		if alpha < 0 then
			alpha = alpha * -1
		end

		if red then
			surface.SetDrawColor(25, 25, 200, alpha)
			surface.SetMaterial(bcircleicon)
			surface.DrawTexturedRect(We(20 + math.cos(CurTime() * 4) * 4), He(10 + math.sin(CurTime() * 4) * 4), We(96), He(96))
		else
			surface.SetDrawColor(200, 25, 25, alpha)
			surface.SetMaterial(bcircleicon)
			surface.DrawTexturedRect(We(30 + math.cos(CurTime() * 4) * 4), He(5 + math.sin(CurTime() * 4) * 4), We(96), He(96))
		end

		draw.SimpleText(MuR.Language["swatarehere"], "MuR_Font3", We(140 + math.cos(CurTime() * 4) * 4), He(70 + math.sin(CurTime() * 4) * 4), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	elseif MuR.Data["PoliceState"] == 5 then
		local time = MuR.Data["PoliceArriveTime"] - CurTime() + 0.5
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(assaulticon)
		surface.DrawTexturedRect(We(20 + math.cos(CurTime() * 4) * 8), He(20 + math.sin(CurTime() * 4) * 8), We(96), He(96))
		draw.SimpleText(MuR.Language["policeassault1"], "MuR_Font3", We(140 + math.cos(CurTime() * 4) * 8), He(70 + math.sin(CurTime() * 4) * 8), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.FormattedTime(time, "%02i:%02i"), "MuR_Font2", We(140 + math.cos(CurTime() * 4) * 8), He(90 + math.sin(CurTime() * 4) * 8), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		if time < 27 then
			MuR:PlayMusic("murdered/theme/police_theme.mp3")
		end
	elseif MuR.Data["PoliceState"] == 6 then
		local alpha = math.abs(math.sin(CurTime() * 2) * 255)
		local text = " / "..MuR.Language["policeassault"].." / "

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(assaulticon)
		surface.DrawTexturedRect(We(20 + math.cos(CurTime() * 4) * 4), He(20 + math.sin(CurTime() * 4) * 4), We(96), He(96))
		draw.SimpleText(MuR.Language["policeassault2"], "MuR_Font3", We(140 + math.cos(CurTime() * 4) * 4), He(70 + math.sin(CurTime() * 4) * 4), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		draw.WordBox(4, ScrW()/2, He(40), text, "MuR_Font3", Color(160, 140, 0, 150), Color(220, 200, 0, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		MuR:PlayMusic("murdered/theme/police_theme.mp3")
	elseif MuR.Data["PoliceState"] == 7 then
		local time = MuR.Data["PoliceArriveTime"] - CurTime() + 0.5
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(helipadicon)
		surface.DrawTexturedRect(We(20 + math.cos(CurTime() * 4) * 8), He(20 + math.sin(CurTime() * 4) * 8), We(96), He(96))
		draw.SimpleText(MuR.Language["evac1"], "MuR_Font3", We(140 + math.cos(CurTime() * 4) * 8), He(70 + math.sin(CurTime() * 4) * 8), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.FormattedTime(time, "%02i:%02i"), "MuR_Font2", We(140 + math.cos(CurTime() * 4) * 8), He(90 + math.sin(CurTime() * 4) * 8), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
		if time < 50 then
			MuR:PlayMusic("murdered/theme/evac_theme.mp3")
		else
			MuR:PlayMusic("murdered/theme/zombie_theme.mp3")
		end
	elseif MuR.Data["PoliceState"] == 8 then
		local time = MuR.Data["PoliceArriveTime"] - CurTime() + 0.5
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(helipadicon)
		surface.DrawTexturedRect(We(20 + math.cos(CurTime() * 4) * 8), He(20 + math.sin(CurTime() * 4) * 8), We(96), He(96))
		draw.SimpleText(MuR.Language["evac2"], "MuR_Font3", We(140 + math.cos(CurTime() * 4) * 8), He(70 + math.sin(CurTime() * 4) * 8), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(string.FormattedTime(time, "%02i:%02i"), "MuR_Font2", We(140 + math.cos(CurTime() * 4) * 8), He(90 + math.sin(CurTime() * 4) * 8), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	else
		if not MuR.ShowDeathLog then
			MuR:PlayMusic("")
		end
	end

	if ply:GetObserverMode() > 0 then
		if IsValid(ply:GetObserverTarget()) then
			draw.SimpleText(MuR.Language["spectating:"], "MuR_Font1", ScrW() / 2, ScrH() / 2 + He(170), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(ply:GetObserverTarget():Nick(), "MuR_Font4", ScrW() / 2, ScrH() / 2 + He(200), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local parsed = markup.Parse("<font=MuR_Font2><colour=255,255,255>"..MuR.Language["spectate_1"])
		parsed:Draw(ScrW() / 2, ScrH() - He(200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		local parsed = markup.Parse("<font=MuR_Font1><colour=255,255,255>Space<colour=200,200,0>"..MuR.Language["spectate_2"])
		parsed:Draw(ScrW() / 2, ScrH() - He(170), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		local parsed = markup.Parse("<font=MuR_Font1><colour=255,255,255>LMB<colour=200,200,0>"..MuR.Language["spectate_3"])
		parsed:Draw(ScrW() / 2, ScrH() - He(150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		local parsed = markup.Parse("<font=MuR_Font1><colour=255,255,255>RMB<colour=200,200,0>"..MuR.Language["spectate_4"])
		parsed:Draw(ScrW() / 2, ScrH() - He(130), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	if ply:IsSpeaking() then
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(voiceicon)
		surface.DrawTexturedRect(We(20), ScrH() - He(250), We(72), He(72))
	end

	if player.GetCount() == 1 then
		draw.SimpleText(MuR.Language["waitingplayers"], "MuR_Font6", ScrW() / 2, ScrH() - He(100), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	---AXON BODY---

	if ply:IsRolePolice() and ply:Alive() then	
		local DateTime = os.date("%d/%m/%Y | %H : %M : %S", os.time())

		draw.RoundedBox(10, ScrW() - We(354), He(4), We(350), He(100), Color(35,35,35,220))

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(axonmat)
		surface.DrawTexturedRect(ScrW() - We(43), He(8), We(32), He(32))

		draw.SimpleText("REC", "MuR_Font2", ScrW() - We(325), He(25), Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		local alpha = (math.sin(RealTime() * math.pi / 0.40) + 1) * 250.5
		draw.RoundedBox(100, ScrW() - We(306), He(16.5), We(16), He(16), Color(255,0,0,alpha))
		
		draw.SimpleText("Axon BodyCam™", "MuR_Font2", ScrW() - We(120), He(25), Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(DateTime, "MuR_Font1", ScrW() - We(340), He(85), Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		surface.SetFont("MuR_Font2")
		surface.SetTextColor(255, 255, 255)
		surface.SetTextPos(ScrW() - We(340), He(50)) 
		surface.DrawText("OFFICER \t|\t" ..  ply:Nick())
	end

	---------------
end)

hook.Add("RenderScreenspaceEffects", "MuR_ColorHP", function()
	local ply = LocalPlayer()

	if ply:Alive() then
		local tab = {
			["$pp_colour_contrast"] = math.Clamp(ply:Health() / 40, 0.1, 1),
			["$pp_colour_colour"] = (ply:Health() / ply:GetMaxHealth()) / 1.25 + 0.2,
		}

		if ply:GetNWBool("GeroinUsed") then
			tab["$pp_colour_colour"] = 5
		end

		DrawColorModify(tab)
	else	--if not alive then it removes the effect, havent found the screen shake tho
	end
end)

local musicname = ""
local currentchannel = nil
function MuR:PlayMusic(music1)
	local music = "sound/"..music1
	if music1 ~= "" then
		local disable = true 
		if IsValid(currentchannel) and (currentchannel:GetState() == 2 or currentchannel:GetState() == 0) then
			disable = false
		end
		if musicname == music1 and disable then 
			return
		else
			if IsValid(currentchannel) then
				currentchannel:Stop()
				currentchannel = nil
			end
			timer.Simple(1, function()
				sound.PlayFile(music, "noblock", function(station, s1, s2)
					if IsValid(station) then
						station:Play()
						station:SetVolume(GetConVar("snd_musicvolume"):GetFloat())
						currentchannel = station
					end
				end)
			end)
		end

		musicname = music1
	else
		musicname = ""
		if IsValid(currentchannel) then
			currentchannel:Stop()
			currentchannel = nil
		end
	end
end
hook.Add("Think", "MuR.MusicVolume", function()
	if IsValid(currentchannel) then
		currentchannel:SetVolume(GetConVar("snd_musicvolume"):GetFloat())
	end
end)

local function ShowAnnounce(type, ent)
	local pos = -100
	local start = true
	local text = ""
	local font = "MuR_Font4"

	if type == "you_killer" then
		text = MuR.Language["announce_traitor"]
	elseif type == "you_defender" then
		text = MuR.Language["announce_defender"]
	elseif type == "you_zombie" then
		text = MuR.Language["announce_zombie"]
	elseif type == "innocent_kill" then
		text = MuR.Language["announce_innokill"]
		font = "MuR_Font2"
		surface.PlaySound("npc/attack_helicopter/aheli_damaged_alarm1.wav")
	elseif type == "innocent_att_kill" then
		text = MuR.Language["announce_attkill"]
		font = "MuR_Font2"
	elseif type == "money_cancel" then
		text = MuR.Language["announce_moneycancel"]
		font = "MuR_Font2"
	elseif type == "spawn_damage" then
		text = MuR.Language["announce_spawndamage"]
		font = "MuR_Font2"
		surface.PlaySound("ambient/alarms/warningbell1.wav")
	elseif type == "officer_spawn" then
		text = MuR.Language["announce_officerspawn"]
		font = "MuR_Font2"
	elseif type == "arrested" then
		text = MuR.Language["announce_arrested"]
		font = "MuR_Font2"
	elseif type == "officer_killer" then
		text = MuR.Language["announce_officerguilt"]
		font = "MuR_Font2"
	end

	timer.Simple(6, function()
		start = false
	end)

	hook.Add("HUDPaint", "ShowAnnounceMuR", function()
		if start then
			pos = math.Clamp(pos + FrameTime() / 0.001, -100, 300)
		else
			pos = math.Clamp(pos - FrameTime() / 0.001, -100, 300)

			if pos == -100 then
				hook.Remove("HUDPaint", "ShowAnnounceMuR")
			end
		end

		draw.SimpleText(text, font, ScrW() / 2, He(pos), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
end

net.Receive("MuR.Announce", function()
	local str = net.ReadString()
	ShowAnnounce(str)
end)

local messageTypes = {
	["corpse_alive"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end,
	["bandage_use"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end,
	["medkit_use"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end,
	["adrenaline_use"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end,
	["geroin_use"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end,
	["ducttape_use"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end,
	["bandage_use_target"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end,
	["medkit_use_target"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end,
	["adrenaline_use_target"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end,
	["geroin_use_target"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end,
	["cyanide_use_target"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end,
	["poison_use"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end,
	["weapon_break"] = function()
		return MuR.Language["message_ragalive"], "MuR_Font2"
	end
}

local function ShowMessage(type, ent)
	local alpha = 0
	local start = true
	local text = ""
	local font = "MuR_Font1"

	if type == "corpse_alive" then
		text = MuR.Language["message_ragalive"]
		font = "MuR_Font2"
	elseif type == "corpse_dead" then
		text = MuR.Language["message_ragdead"]
		font = "MuR_Font2"
	elseif type == "bandage_use" then
		text = MuR.Language["message_bandageuse"]
		font = "MuR_Font2"
	elseif type == "medkit_use" then
		text = MuR.Language["message_medkituse"]
		font = "MuR_Font2"
	elseif type == "adrenaline_use" then
		text = MuR.Language["message_adrenalineuse"]
		font = "MuR_Font2"
	elseif type == "geroin_use" then
		text = MuR.Language["message_heroinuse"]
		font = "MuR_Font2"
	elseif type == "ducttape_use" then
		text = MuR.Language["message_tapeuse"]
		font = "MuR_Font2"
	elseif type == "bandage_use_target" then
		text = MuR.Language["message_targetbandageuse"]
		font = "MuR_Font2"
	elseif type == "medkit_use_target" then
		text = MuR.Language["message_targetmedkituse"]
		font = "MuR_Font2"
	elseif type == "adrenaline_use_target" then
		text = MuR.Language["message_targetadrenalineuse"]
		font = "MuR_Font2"
	elseif type == "geroin_use_target" then
		text = MuR.Language["message_targetheroinuse"]
		font = "MuR_Font2"
	elseif type == "cyanide_use_target" then
		text = MuR.Language["message_targetcyanideuse"]
		font = "MuR_Font2"
	elseif type == "poison_use" then
		text = MuR.Language["message_poisonuse"]
		font = "MuR_Font2"
	elseif type == "weapon_break" then
		text = MuR.Language["message_weaponbreak"]
		font = "MuR_Font3"
	end

	timer.Simple(5, function()
		start = false
	end)

	hook.Add("HUDPaint", "ShowMessageMuR", function()
		if start then
			alpha = math.Clamp(alpha + FrameTime() / 0.002, 0, 255)
		else
			alpha = math.Clamp(alpha - FrameTime() / 0.002, 0, 255)

			if alpha == 0 then
				hook.Remove("HUDPaint", "ShowMessageMuR")
			end
		end

		draw.SimpleText(text, font, ScrW() / 2, ScrH() / 2 + He(200), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
end

net.Receive("MuR.Message", function()
	local str = net.ReadString()
	ShowMessage(str)
end)

local function ShowMessage2(type, ent)
	local alpha = 0
	local start = true
	local text = ""
	local font = "MuR_Font1"

	if type == "neck_hit" then
		text = MuR.Language["neck_hit"]
		font = "MuR_Font2"
	elseif type == "lung_hit" then
		text = MuR.Language["lung_hit"]
		font = "MuR_Font2"
	elseif type == "heart_hit" then
		text = MuR.Language["heart_hit"]
		font = "MuR_Font2"
	elseif type == "leg_hit" then
		text = MuR.Language["leg_hit"]
		font = "MuR_Font2"
	elseif type == "arm_hit" then
		text = MuR.Language["arm_hit"]
		font = "MuR_Font2"
	elseif type == "down_hit" then
		text = MuR.Language["down_hit"]
		font = "MuR_Font2"
	end

	timer.Simple(5, function()
		start = false
	end)

	hook.Add("HUDPaint", "ShowMessageMuR", function()
		if start then
			alpha = math.Clamp(alpha + FrameTime() / 0.002, 0, 255)
		else
			alpha = math.Clamp(alpha - FrameTime() / 0.002, 0, 255)

			if alpha == 0 then
				hook.Remove("HUDPaint", "ShowMessageMuR")
			end
		end

		surface.SetFont(font)
		local w, h = surface.GetTextSize(text)
		surface.SetDrawColor(0, 0, 0, alpha - 50)
		surface.DrawRect(0, ScrH() / 2 - He(20), We(20) + w, He(40))
		draw.SimpleText(text, font, 10, ScrH() / 2, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end)
end

net.Receive("MuR.Message2", function()
	local str = net.ReadString()
	ShowMessage2(str)
end)

local function Countdown(num, type)
	local alpha = 255

	for i = 0, num - 1 do
		timer.Simple(i, function()
			alpha = 255
			surface.PlaySound("buttons/lightswitch2.wav")

			hook.Add("HUDPaint", "MuRHUDTimer", function()
				alpha = math.max(alpha - FrameTime() / 0.004, 0)

				if alpha == 0 then
					hook.Remove("HUDPaint", "MuRHUDTimer")
				end

				draw.SimpleTextOutlined(num - i, "MuR_Font6", ScrW() / 2, He(250), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, alpha))
			end)
		end)
	end
end

net.Receive("MuR.Countdown", function()
	local f = net.ReadFloat()
	Countdown(f)
end)

hook.Add("AdjustMouseSensitivity", "Murdered", function(speed)
	if LocalPlayer():IsSprinting() and not LocalPlayer():GetNWEntity("RD_Ent") then return 0.3 end
end)

local viewbob_speed = 10
local viewbob_amount = 0.01
local viewbob_offset = 0
local last_velocity = 0

hook.Add("CalcView", "ViewBob", function(ply, pos, angles, fov)
	local wep = ply:GetActiveWeapon()
	local allow = true
	if IsValid(wep) or IsValid(ply:GetNWEntity("RD_EntCam")) or ply:GetSVAnimation() ~= "" then allow = false end

	if ply:Alive() and not ply:ShouldDrawLocalPlayer() and allow then
		local velocity = ply:GetVelocity():Length()
		local head_z = 0
		local eyes = ply:GetAttachment(ply:LookupAttachment("eyes"))

		head_z = math.Clamp(eyes.Ang.z / 5, -45, 45)

		if velocity > 0 and last_velocity == 0 then
			viewbob_offset = 0
		end

		last_velocity = velocity

		viewbob_offset = viewbob_offset + (viewbob_speed * RealFrameTime())
		local bob_x = math.sin(viewbob_offset) * viewbob_amount * last_velocity
		local bob_y = math.cos(viewbob_offset) * viewbob_amount * last_velocity
		angles.roll = angles.roll + bob_y / 2
		angles.x = angles.x + bob_x / 4
		angles.z = head_z
		local view = {}
		view.origin = pos
		view.angles = angles
		view.fov = fov

		return view
	end
end)

hook.Add("HUDPaint", "MuR_ShowcaseTeammates", function()
	if MuR.DrawHUD then
		for _, ply in ipairs(player.GetAll()) do
			if ply ~= LocalPlayer() and (ply:Team() == 1 and LocalPlayer():Team() == 1 or (LocalPlayer():GetNWString("Class") == "War_UKR" and ply:GetNWString("Class") == "War_UKR" or LocalPlayer():GetNWString("Class") == "Riot" and ply:GetNWString("Class") == "Riot" or LocalPlayer():GetNWString("Class") == "ArmoredOfficer" and ply:GetNWString("Class") == "ArmoredOfficer" or LocalPlayer():GetNWString("Class") == "Officer" and ply:GetNWString("Class") == "Officer" or LocalPlayer():GetNWString("Class") == "SWAT" and ply:GetNWString("Class") == "SWAT" or LocalPlayer():GetNWString("Class") == "Terrorist2" and ply:GetNWString("Class") == "Terrorist2" or LocalPlayer():GetNWString("Class") == "K_Faction" and ply:GetNWString("Class") == "K_Faction" or LocalPlayer():GetNWString("Class") == "M_Faction" and ply:GetNWString("Class") == "M_Faction")) and ply:Alive() then
				local pos = ply:EyePos():ToScreen()
				draw.SimpleText(ply:Nick(), "Default", pos.x, pos.y + 8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText(MuR.Language["teammate"], "Default", pos.x, pos.y + 16, Color(0, 150, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end

			if LocalPlayer():GetObserverMode() > 0 and ply:Alive() and LocalPlayer():GetObserverTarget() ~= ply then
				local pos = ply:EyePos():ToScreen()
				draw.SimpleTextOutlined(ply:Nick(), "Default", pos.x, pos.y, Color(225, 225, 225), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
			end
		end
	end
end)

hook.Add("PreDrawHalos", "DrawLootHalo", function()
	local ply = LocalPlayer()
	local pos = ply:GetPos()
	local entsInRange = ents.FindInSphere(pos, 128)
	local lootEnts, wepsEnts = {}, {}

	for i = 1, #entsInRange do
		local ent = entsInRange[i]

		if string.match(ent:GetClass(), "mur_") and not IsValid(ent:GetOwner()) and not ent:GetNoDraw() then
			if ent.Melee or ent:IsWeapon() and ent:GetMaxClip1() > 0 then
				table.insert(wepsEnts, ent)
			else
				table.insert(lootEnts, ent)
			end
		end
	end

	halo.Add(lootEnts, Color(200, 200, 0), 2, 2, 1, true, false)
	halo.Add(wepsEnts, Color(255, 0, 0), 2, 2, 1, true, false)
end)

hook.Add("PostDrawOpaqueRenderables", "MuR.WantedIcon", function()
	if not LocalPlayer():IsRolePolice() then return end
	for _, ply in pairs(player.GetAll()) do
		if ply:Alive() and ply:GetNWFloat("ArrestState") > 0 and ply ~= LocalPlayer() then
			local offset = Vector(0, 0, 16)
			local ang = LocalPlayer():EyeAngles()
			local bpos = MuR:BoneData(ply, "ValveBiped.Bip01_Head1")
			local pos = bpos + offset

			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), 90)

			local icon = arresticon
			if ply:GetNWFloat("ArrestState") == 2 then
				icon = pistolicon
			end
			cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(icon)
				surface.DrawTexturedRect(-64, -64, 128, 128)
			cam.End3D2D()
		end
	end
end)

------------------------------------------------------------------------------------------------------

function MuR:ShowStartScreen(gamemode, class)
	MuR.DrawHUD = false
	surface.PlaySound("murdered/theme/theme_gamemode" .. gamemode .. ".mp3")
	MuR.GamemodeCount = gamemode
	local ply = LocalPlayer()
	local alpha, alphago = 300, false
	local lerppos = -We(400)
	local needlerppos = 0
	if not class then
		class = ply:GetNWString("Class")
	end

	timer.Simple(7, function()
		alphago = true
		needlerppos = We(250)
	end)

	hook.Add("HUDPaint", "MurderedStartScreen", function()
		if alphago then
			alpha = math.min(alpha + FrameTime() / 0.005, 255)
			lerppos = Lerp(FrameTime()/4, lerppos, needlerppos)
		else
			alpha = math.max(alpha - FrameTime() / 0.015, 0)
			lerppos = Lerp(FrameTime(), lerppos, needlerppos)
		end

		local classname = MuR.Language["civilian"]
		local otherdesc = ""
		local desc = MuR.Language["civilian_desc"]
		local color = Color(100, 150, 200)
		local gamename = MuR.Language["gamename1"]
		local gamedesc = MuR.Language["gamedesc1"]
		
		if gamemode == 2 then
			gamename = MuR.Language["gamename2"]
			gamedesc = MuR.Language["gamedesc2"]
		elseif gamemode == 3 then
			gamename = MuR.Language["gamename3"]
			gamedesc = MuR.Language["gamedesc3"]
		elseif gamemode == 4 then
			gamename = MuR.Language["gamename4"]
			gamedesc = MuR.Language["gamedesc4"]
		elseif gamemode == 5 then
			gamename = MuR.Language["gamename5"]
			gamedesc = MuR.Language["gamedesc5"]
		elseif gamemode == 6 then
			gamename = MuR.Language["gamename6"]
			gamedesc = MuR.Language["gamedesc6"]
		elseif gamemode == 7 then
			gamename = MuR.Language["gamename7"]
			gamedesc = MuR.Language["gamedesc7"]
		elseif gamemode == 8 then
			gamename = MuR.Language["gamename8"]
			gamedesc = MuR.Language["gamedesc8"]
		elseif gamemode == 9 then
			gamename = MuR.Language["gamename9"]
			gamedesc = MuR.Language["gamedesc9"]
		elseif gamemode == 10 then
			gamename = MuR.Language["gamename10"]
			gamedesc = MuR.Language["gamedesc10"]
		elseif gamemode == 11 then
			gamename = MuR.Language["gamename11"]
			gamedesc = MuR.Language["gamedesc11"]
		elseif gamemode == 12 then
			gamename = MuR.Language["gamename12"]
			gamedesc = MuR.Language["gamedesc12"]
		elseif gamemode == 13 then
			gamename = MuR.Language["gamename13"]
			gamedesc = MuR.Language["gamedesc13"]
		elseif gamemode == 14 then
			gamename = MuR.Language["gamename14"]
			gamedesc = MuR.Language["gamedesc14"]
		end		

		if class == "Killer" then
			classname = MuR.Language["murderer"]
			color = Color(150, 10, 10)
			desc = MuR.Language["murderer_desc"]
		elseif class == "Attacker" then
			classname = MuR.Language["rioter"]
			desc = MuR.Language["rioter_desc"]
			color = Color(180, 80, 80)
		elseif class == "Traitor" then
			classname = MuR.Language["traitor"]
			color = Color(150, 10, 10)
			desc = MuR.Language["traitor_desc"]
		elseif class == "Zombie" then
			classname = MuR.Language["zombie"]
			color = Color(80, 0, 0)
			desc = MuR.Language["zombie_desc"]
		elseif class == "Maniac" then
			classname = MuR.Language["maniac"]
			color = Color(150, 10, 10)
			desc = MuR.Language["maniac_desc"]
		elseif class == "Shooter" then
			classname = MuR.Language["shooter"]
			color = Color(150, 10, 10)
			desc = MuR.Language["shooter_desc"]
		elseif class == "Terrorist" then
			classname = MuR.Language["terrorist"]
			color = Color(160, 20, 20)
			desc = MuR.Language["terrorist_desc"]
		elseif class == "Terrorist2" then
			classname = MuR.Language["terrorist"]
			color = Color(160, 20, 20)
			desc = MuR.Language["terrorist_desc2"]
		elseif class == "Hunter" then
			classname = MuR.Language["civilian"]
			color = Color(50, 75, 175)
			desc = MuR.Language["defender_desc"]
			otherdesc = MuR.Language["defender_var_heavy"]
		elseif class == "Officer" then
			classname = MuR.Language["officer"]
			color = Color(25, 25, 255)
			desc = MuR.Language["officer_desc"]
		elseif class == "FBI" then
			classname = MuR.Language["fbiagent"]
			color = Color(25, 25, 255)
			desc = MuR.Language["fbiagent_desc"]
		elseif class == "Riot" then
			classname = MuR.Language["riotpolice"]
			color = Color(25, 25, 255)
			desc = MuR.Language["riotpolice_desc"]
		elseif class == "SWAT" then
			classname = MuR.Language["swat"]
			color = Color(25, 25, 255)
			desc = MuR.Language["swat_desc"]
		elseif class == "Defender" then
			classname = MuR.Language["civilian"]
			otherdesc = MuR.Language["defender_var_light"]
			color = Color(50, 75, 175)
			desc = MuR.Language["defender_desc"]
		elseif class == "Medic" then
			classname = MuR.Language["medic"]
			desc = MuR.Language["medic_desc"]
			color = Color(50, 120, 50)
		elseif class == "Builder" then
			classname = MuR.Language["builder"]
			desc = MuR.Language["builder_desc"]
			color = Color(50, 120, 50)
		elseif class == "Soldier" then
			classname = MuR.Language["soldier"]
			desc = MuR.Language["soldier_desc"]
			color = Color(250, 150, 0)
		elseif class == "K_Faction" then
			classname = MuR.Language["k_faction"]
			desc = MuR.Language["k_faction_desc"]
			color = Color(160, 20, 20)
		elseif class == "M_Faction" then
			classname = MuR.Language["m_faction"]
			desc = MuR.Language["m_faction_desc"]
			color = Color(25, 25, 255)	
		elseif class == "War_RUS" then
			classname = MuR.Language["war_rus"] 
			desc = MuR.Language["war_rus_desc"] 
			color = Color(250, 150, 0)
		elseif class == "War_UKR" then
			classname = MuR.Language["war_ukr"] 
			desc = MuR.Language["war_ukr_desc"] 
			color = Color(250, 150, 0)
		end

		surface.SetDrawColor(0, 0, 0, 250)
		surface.DrawRect(0, 0, ScrW(), ScrH())
		surface.SetDrawColor(math.abs(math.cos(CurTime()*2)*color.r/2)+color.r/2, math.abs(math.cos(CurTime()*2)*color.g/2)+color.g/2, math.abs(math.cos(CurTime()*2)*color.b/2)+color.b/2, 5)
		surface.SetMaterial(vinmat)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		draw.SimpleText(gamename, "MuR_Font8", ScrW() / 2 + lerppos, ScrH() / 2 - He(450), Color(200, 175, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(gamedesc, "MuR_Font4", ScrW() / 2 + lerppos, ScrH() / 2 - He(400), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--draw.SimpleText(MuR.Language["startscreen_role"], "MuR_Font5", ScrW() / 2 + lerppos, ScrH() / 2 - He(50), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(classname, "MuR_Font7", ScrW() / 2 + lerppos, ScrH() / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(otherdesc, "MuR_Font3", ScrW() / 2 + lerppos, ScrH() / 2 + He(35), Color(150, 150, 250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--draw.SimpleText(desc, "MuR_Font3", ScrW() / 2 + lerppos, ScrH() / 2 + He(350), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(0, 0, 0, alpha)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end)

	timer.Simple(9, function()
		if IsValid(ply) then
			ply:ScreenFade(SCREENFADE.IN, color_black, 1, 0)
		end

		MuR.DrawHUD = true
		hook.Remove("HUDPaint", "MurderedStartScreen")
	end)
end

net.Receive("MuR.StartScreen", function()
	local float = net.ReadFloat()
	local str = net.ReadString()
	MuR:ShowStartScreen(float, str)
end)

function GM:HUDDrawTargetID()
end

function GM:HUDDrawPickupHistory()
end

---------------------------------------------------------------------------------------------------------------------

local function CreateFonts()
	surface.CreateFont("MuR_Font0", {
		font = "share_tech_gmod",
		extended = true,
		size = He(12),
		antialias = true
	})

	surface.CreateFont("MuR_Font1", {
		font = "share_tech_gmod",
		extended = true,
		size = He(16),
		antialias = true
	})

	surface.CreateFont("MuR_Font2", {
		font = "share_tech_gmod",
		extended = true,
		size = He(24),
		antialias = true
	})

	surface.CreateFont("MuR_Font3", {
		font = "share_tech_gmod",
		extended = true,
		size = He(32),
		antialias = true
	})

	surface.CreateFont("MuR_Font4", {
		font = "share_tech_gmod",
		extended = true,
		size = He(40),
		antialias = true
	})

	surface.CreateFont("MuR_Font5", {
		font = "share_tech_gmod",
		extended = true,
		size = He(48),
		antialias = true
	})

	surface.CreateFont("MuR_Font6", {
		font = "share_tech_gmod",
		extended = true,
		size = He(56),
		antialias = true
	})

	surface.CreateFont("MuR_Font7", {
		font = "share_tech_gmod",
		extended = true,
		size = He(64),
		antialias = true
	})
	
	surface.CreateFont("MuR_Font8", {
		font = "share_tech_gmod",
		extended = true,
		size = He(72),
		antialias = true
	})
end
CreateFonts()
hook.Add("OnScreenSizeChanged", "MuR.Fonts", function()
	CreateFonts()
end)



local lastFlashToggleTime = 0
local flashlightToggleCooldown = 0.2  -- Prevent rapid toggling

hook.Add("PlayerButtonDown", "SpectatorFlashlight", function(ply, button)
    if ply:GetObserverMode() > 0 and button == KEY_F then
        local currentTime = CurTime()
        
        if currentTime - lastFlashToggleTime > flashlightToggleCooldown then
            local currentState = ply:GetNWBool("SpectatorFlashlightActive", false)
            ply:SetNWBool("SpectatorFlashlightActive", not currentState)
            lastFlashToggleTime = currentTime
        end
    end
end)

hook.Add("Think", "UpdateSpectatorFlashlight", function()
    local ply = LocalPlayer()
    if ply:GetObserverMode() > 0 and ply:GetNWBool("SpectatorFlashlightActive", false) then
        local light = DynamicLight(ply:EntIndex())
        if light then
            light.pos = ply:EyePos()
            light.r = 255
            light.g = 255
            light.b = 255
            light.brightness = 1
            light.Size = 100000
            light.Dir = ply:EyeAngles():Forward()
            light.InnerAngle = 35
            light.OuterAngle = 45
            light.Decay = 0
            light.DieTime = CurTime() + 0.1
        end
    end
end)

