MuR.Data["VoteLog"] = 0

local dead_mat = Material("murdered/dead.png")

local function add_to_panel(pnl, el, y)
	local size_y = select(2, el:GetSize())
	pnl.offset = pnl.offset + size_y + He(y)
	table.insert(pnl.Elements, el)
	pnl:SetSize(ScrW(), pnl.offset)
	el:SetPos(el:GetX(), pnl.offset-size_y-ScrH())
end

local function show_result_screen(maintab, time)
	local lang = MuR.Language

	MuR.ShowDeathLog = true
	MuR:PlayMusic("murdered/theme/log_theme.mp3")

	local panel = vgui.Create("DPanel")
	panel:SetPos(0, 0)
	panel:SetAlpha(0)
	panel:AlphaTo(255, 2)
	panel.Paint = function(self, w, h)
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0, 0, w, h)
	end
	panel.offset = ScrH()
	panel.Elements = {}

	local t = vgui.Create("DLabel", panel)
	t:SetText(lang["log_start_text"])
	t:SetFont("MuR_Font2")
	t:SetWrap(true)
	t:SetSize(We(1600), He(200))
	t:SetPos(ScrW()/2-t:GetSize()/2, 0)
	add_to_panel(panel, t, ScrH())

	--dead players--

	if #maintab.dead > 0 then

		local t = vgui.Create("DLabel", panel)
		t:SetText(lang["log_dead_players"])
		t:SetFont("MuR_Font2")
		t:SetWrap(true)
		t:SetSize(We(320), He(120))
		t:SetPos(ScrW()/2-t:GetSize()/2, 0)
		add_to_panel(panel, t, He(200))

		for _, ply in ipairs(maintab.dead) do
			local p = vgui.Create("DPanel", panel)
			p:SetSize(We(600), He(300))
			p:SetPos(ScrW()/2-p:GetSize()/2, 0)
			p.Paint = function(self, w, h)
				surface.SetDrawColor(0,0,0)
				surface.DrawRect(0, 0, w, h)

				if ply.isdanger then
					draw.SimpleText(lang["log_data_know"], "MuR_Font2", We(200), He(100), Color(200,50,50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText(lang["log_data_unknow"], "MuR_Font2", We(200), He(100), Color(200,200,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
				draw.SimpleText(lang["log_data_name"]..ply.name, "MuR_Font1", We(200), He(130), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(lang["log_data_reason_d"]..lang["log_reason_"..ply.reason], "MuR_Font1", We(200), He(150), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			add_to_panel(panel, p, He(5))

			local panel = vgui.Create("DPanel", p)
			panel:SetPos(We(50),He(50))
			panel:SetSize(We(100), He(200))
			panel.Paint = function(self, w, h)
				surface.SetDrawColor(25,25,25)
				surface.DrawRect(0, 0, w, h)
			end

			local icon = vgui.Create("DModelPanel", p)
			icon:SetPos(We(50),He(50))
			icon:SetSize(We(100), He(200))
			icon:SetModel(ply.model)
			function icon:LayoutEntity(ent) ent:SetSequence(0) return end
			if IsValid(icon.Entity) then
				local eyepos = icon.Entity:GetBonePosition(icon.Entity:LookupBone("ValveBiped.Bip01_Head1"))
				eyepos:Add(Vector(0, 0, 1))
				icon:SetLookAt(eyepos)
				icon:SetCamPos(eyepos-Vector(-11, 0, 0))
				icon.Entity:SetEyeTarget(eyepos-Vector(-11, 0, 0))
			end
			icon.PaintOver = function(self, w, h)
				surface.SetDrawColor(255,255,255)
				surface.DrawOutlinedRect(0, 0, w, h, 2)
			end
		end

	end

	------------
	
	--dead cops players--

	if #maintab.dead_cops > 0 then

		local t = vgui.Create("DLabel", panel)
		t:SetText(lang["log_dead_cops_players"])
		t:SetFont("MuR_Font2")
		t:SetWrap(true)
		t:SetSize(We(320), He(120))
		t:SetPos(ScrW()/2-t:GetSize()/2, 0)
		add_to_panel(panel, t, He(200))

		for _, ply in ipairs(maintab.dead_cops) do
			local p = vgui.Create("DPanel", panel)
			p:SetSize(We(600), He(300))
			p:SetPos(ScrW()/2-p:GetSize()/2, 0)
			p.Paint = function(self, w, h)
				surface.SetDrawColor(0,0,0)
				surface.DrawRect(0, 0, w, h)

				draw.SimpleText(lang['officer'], "MuR_Font2", We(200), He(100), Color(200,200,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(lang["log_data_name"]..ply.name, "MuR_Font1", We(200), He(130), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(lang["log_data_reason_d"]..lang["log_reason_"..ply.reason], "MuR_Font1", We(200), He(150), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			add_to_panel(panel, p, He(5))

			local panel = vgui.Create("DPanel", p)
			panel:SetPos(We(50),He(50))
			panel:SetSize(We(100), He(200))
			panel.Paint = function(self, w, h)
				surface.SetDrawColor(25,25,25)
				surface.DrawRect(0, 0, w, h)
			end

			local icon = vgui.Create("DModelPanel", p)
			icon:SetPos(We(50),He(50))
			icon:SetSize(We(100), He(200))
			icon:SetModel(table.Random(MuR.PlayerModels["Police"]))
			function icon:LayoutEntity(ent) ent:SetSequence(0) return end
			local eyepos = icon.Entity:GetBonePosition(icon.Entity:LookupBone("ValveBiped.Bip01_Head1"))
			eyepos:Add(Vector(0, 0, 2))
			icon:SetLookAt(eyepos)
			icon:SetCamPos(eyepos-Vector(-11, 0, 0))
			icon.Entity:SetEyeTarget(eyepos-Vector(-11, 0, 0))
			icon.PaintOver = function(self, w, h)
				surface.SetDrawColor(255,255,255)
				surface.DrawOutlinedRect(0, 0, w, h, 2)
			end
		end

	end

	------------

	--heavy injured players--

	if #maintab.heavy_injured > 0 then
		local t = vgui.Create("DLabel", panel)
		t:SetText(lang["log_hdead_players"])
		t:SetFont("MuR_Font2")
		t:SetWrap(true)
		t:SetSize(We(320), He(120))
		t:SetPos(ScrW()/2-t:GetSize()/2, 0)
		add_to_panel(panel, t, He(200))

		for _, ply in ipairs(maintab.heavy_injured) do
			local p = vgui.Create("DPanel", panel)
			p:SetSize(We(600), He(300))
			p:SetPos(ScrW()/2-p:GetSize()/2, 0)
			p.Paint = function(self, w, h)
				surface.SetDrawColor(0,0,0)
				surface.DrawRect(0, 0, w, h)

				if ply.isdanger then
					draw.SimpleText(lang["log_data_know"], "MuR_Font2", We(200), He(100), Color(200,50,50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText(lang["log_data_unknow"], "MuR_Font2", We(200), He(100), Color(200,200,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
				draw.SimpleText(lang["log_data_name"]..ply.name, "MuR_Font1", We(200), He(130), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(lang["log_data_reason_d"]..lang["log_reason_"..ply.reason], "MuR_Font1", We(200), He(150), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			add_to_panel(panel, p, He(5))

			local panel = vgui.Create("DPanel", p)
			panel:SetPos(We(50),He(50))
			panel:SetSize(We(100), He(200))
			panel.Paint = function(self, w, h)
				surface.SetDrawColor(25,25,25)
				surface.DrawRect(0, 0, w, h)
			end

			local icon = vgui.Create("DModelPanel", p)
			icon:SetPos(We(50),He(50))
			icon:SetSize(We(100), He(200))
			icon:SetModel(ply.model)
			function icon:LayoutEntity(ent) ent:SetSequence(0) return end
			local eyepos = icon.Entity:GetBonePosition(icon.Entity:LookupBone("ValveBiped.Bip01_Head1"))
			eyepos:Add(Vector(0, 0, 1))
			icon:SetLookAt(eyepos)
			icon:SetCamPos(eyepos-Vector(-11, 0, 0))
			icon.Entity:SetEyeTarget(eyepos-Vector(-11, 0, 0))
			icon.PaintOver = function(self, w, h)
				surface.SetDrawColor(255,255,255)
				surface.DrawOutlinedRect(0, 0, w, h, 2)
			end
		end
	end

	------------

	--injured players--

	if #maintab.injured > 0 then

		local t = vgui.Create("DLabel", panel)
		t:SetText(lang["log_injured_players"])
		t:SetFont("MuR_Font2")
		t:SetWrap(true)
		t:SetSize(We(320), He(120))
		t:SetPos(ScrW()/2-t:GetSize()/2, 0)
		add_to_panel(panel, t, He(200))

		for _, ply in ipairs(maintab.injured) do
			local p = vgui.Create("DPanel", panel)
			p:SetSize(We(600), He(300))
			p:SetPos(ScrW()/2-p:GetSize()/2, 0)
			p.Paint = function(self, w, h)
				surface.SetDrawColor(0,0,0)
				surface.DrawRect(0, 0, w, h)

				if ply.isdanger then
					draw.SimpleText(lang["log_data_know"], "MuR_Font2", We(200), He(100), Color(200,50,50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText(lang["log_data_unknow"], "MuR_Font2", We(200), He(100), Color(200,200,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
				draw.SimpleText(lang["log_data_name"]..ply.name, "MuR_Font1", We(200), He(130), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(lang["log_data_reason_p"]..lang["log_reason_"..ply.reason], "MuR_Font1", We(200), He(150), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			add_to_panel(panel, p, He(5))

			local panel = vgui.Create("DPanel", p)
			panel:SetPos(We(50),He(50))
			panel:SetSize(We(100), He(200))
			panel.Paint = function(self, w, h)
				surface.SetDrawColor(25,25,25)
				surface.DrawRect(0, 0, w, h)
			end

			local icon = vgui.Create("DModelPanel", p)
			icon:SetPos(We(50),He(50))
			icon:SetSize(We(100), He(200))
			icon:SetModel(ply.model)
			function icon:LayoutEntity(ent) ent:SetSequence(0) return end
			local eyepos = icon.Entity:GetBonePosition(icon.Entity:LookupBone("ValveBiped.Bip01_Head1"))
			eyepos:Add(Vector(0, 0, 2))
			icon:SetLookAt(eyepos)
			icon:SetCamPos(eyepos-Vector(-11, 0, 0))
			icon.Entity:SetEyeTarget(eyepos-Vector(-11, 0, 0))
			icon.PaintOver = function(self, w, h)
				surface.SetDrawColor(255,255,255)
				surface.DrawOutlinedRect(0, 0, w, h, 2)
			end
		end

	end

	------------

	local t = vgui.Create("DLabel", panel)
	t:SetText(lang["log_end_text"])
	t:SetFont("MuR_Font2")
	t:SetWrap(true)
	t:SetSize(We(1600), He(200))
	t:SetPos(ScrW()/2-t:GetSize()/2, 0)
	add_to_panel(panel, t, He(200))

	panel:MoveTo(0, ScrH()-select(2, panel:GetSize()), time, 0, -1, function() 
		panel:AlphaTo(0, 2, 0, function()
			panel:Remove()
			MuR.ShowDeathLog = false
		end)
	end)
end

net.Receive("MuR.ShowLogScreen", function()
	local tab = net.ReadTable()
	local time = net.ReadFloat()
	show_result_screen(tab, time)
end)