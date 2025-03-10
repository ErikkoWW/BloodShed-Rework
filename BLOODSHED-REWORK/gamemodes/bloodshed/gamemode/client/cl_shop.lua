local shop_select_panel = nil

hook.Add("Think", "MuR_Shop", function()
	if input.IsKeyDown(KEY_F2) and not IsValid(shop_select_panel) then
		RunConsoleCommand("mur_shop")
	end
end)

-------------------------------------------
-------------------------------------------

concommand.Add("mur_shop", function()
    OpenShop()
end)

function OpenShop()
    local shopmenu = vgui.Create("DFrame")
    local frameW, frameH, animTime, animDelay, animEase = We(700), He(350), 1.8, 0, 0.1
    local animating = true
    shopmenu:SetSize(0, 0)
    shopmenu:MakePopup()
    shopmenu:SetTitle("")
    shopmenu:SizeTo(frameW, frameH, animTime, animDelay, animEase, function()
        animating = false
    end)
	shop_select_panel = shopmenu
    
    shopmenu.Think = function(self)
        if animating then
            shopmenu:Center()
        end
    end
    
    shopmenu.Paint = function(self, w, h)
    
        draw.RoundedBox(2, 0, 0, w, h, Color(20, 20, 20, 190))
    
        draw.RoundedBox(2, 5, 5, w-10, h-10, Color(100, 100, 100, 150))

        draw.SimpleTextOutlined("Shop", "MuR_Font3", We(15), He(25), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
    
    end
    
    local selectCivilian = vgui.Create("DButton", shopmenu)
    selectCivilian:Dock(TOP)
	selectCivilian:DockMargin(0,12,0,0)
    selectCivilian:SetSize(We(100), He(100))
    selectCivilian:SetText("")
    
    selectCivilian.Paint = function(self, w, h)
        
        draw.RoundedBox(4, 0, 0, w, h, Color(20, 20, 20, 150))
        
        draw.RoundedBox(4, 5, 5, w-10, h-10, Color(100, 100, 100, 150))

        draw.SimpleTextOutlined(MuR.Language["shop"], "MuR_Font3", We(50), h/2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
        
    end

    selectCivilian.DoClick = function(self)
        shopmenu:Close()
		surface.PlaySound("murdered/vgui/ui_click.wav")
        OpenCivShop()
    end
    
    local selectKiller = vgui.Create("DButton", shopmenu)
    selectKiller:Dock(TOP)
    selectKiller:SetSize(We(100), He(100))
    selectKiller:SetText("")
    
    selectKiller.Paint = function(self, w, h)
        
        draw.RoundedBox(4, 0, 0, w, h, Color(20, 20, 20, 150))
        
        draw.RoundedBox(4, 5, 5, w-10, h-10, Color(100, 100, 100, 150))

        draw.SimpleTextOutlined(MuR.Language["blackmarket"], "MuR_Font3", We(50), h/2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
        
    end

    selectKiller.DoClick = function(self)
        shopmenu:Close()
		surface.PlaySound("murdered/vgui/ui_click.wav")
        OpenKillerShop()
    end
    
    local selectSoldier = vgui.Create("DButton", shopmenu)
    selectSoldier:Dock(TOP)
    selectSoldier:SetSize(We(100), He(100))
    selectSoldier:SetText("")
    
    selectSoldier.Paint = function(self, w, h)
        
        draw.RoundedBox(4, 0, 0, w, h, Color(20, 20, 20, 150))
        
        draw.RoundedBox(4, 5, 5, w-10, h-10, Color(100, 100, 100, 150))

        draw.SimpleTextOutlined(MuR.Language["milequipment"], "MuR_Font3", We(50), h/2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
        
    end

    selectSoldier.DoClick = function(self)
        shopmenu:Close()
		surface.PlaySound("murdered/vgui/ui_click.wav")
        OpenSoldierShop()
    end
end

function OpenCivShop()
    local shopmenu = vgui.Create("DFrame")
    local frameW, frameH, animTime, animDelay, animEase = We(1400), He(800), 1.8, 0, 0.1
    local animating = true
    shopmenu:SetSize(0, 0)
    shopmenu:MakePopup()
    shopmenu:SetTitle("")
    shopmenu:SizeTo(frameW, frameH, animTime, animDelay, animEase, function()
        animating = false
    end)
	shop_select_panel = shopmenu

	local scr = vgui.Create("DScrollPanel", shopmenu)
	scr:Dock(FILL)
    
    shopmenu.Think = function(self)
        if animating then
            shopmenu:Center()
        end
    end
    
    shopmenu.Paint = function(self, w, h)
    
        draw.RoundedBox(2, 0, 0, w, h, Color(20, 20, 20, 190))
    
        draw.RoundedBox(2, 5, 5, w-20, h-10, Color(100, 100, 100, 150))

        draw.SimpleTextOutlined(MuR.Language["shop"], "MuR_Font3", We(15), He(18), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
    
    end

    for k, v in pairs(MuR.Shop["Civilian"]) do
        local item = scr:Add("DPanel")
        item:Dock(TOP)
        item:DockMargin(0, 0, 10, 5)
        item:SetSize(We(200), He(150))
    
        item.Paint = function(self, w, h)
    
            draw.RoundedBox(4, 0, 0, w, h, Color(20, 20, 20, 150))
    
            draw.RoundedBox(4, 5, 5, w-10, h-10, Color(100, 100, 100, 150))
    
            draw.SimpleTextOutlined(v.name, "MuR_Font4", We(150), h/3.25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
            draw.SimpleTextOutlined("$".." "..v.price, "MuR_Font3", We(150), h/1.25, Color(50, 83, 52), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
    
            local itemmaterial = Material(v.icon)
            surface.SetMaterial(itemmaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRect(We(50), h/2.5, We(50), He(50))
    
        end

        local buy = vgui.Create("DButton", item)
        buy:SetSize(We(100), He(100))
        buy:SetPos(We(1250), He(25))
        buy:SetText("")

        buy.Paint = function(self, w, h)
            
            draw.RoundedBox(4, 0, 0, w, h, Color(20, 20, 20, 150))
            
            draw.RoundedBox(4, 5, 5, w-10, h-10, Color(39, 120, 62, 150))
    
            draw.SimpleTextOutlined("Buy", "MuR_Font3", We(30), h/2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
            
        end
    
        buy.DoClick = function(self)
			local m = LocalPlayer():GetNWFloat('Money')

			if m >= v.price then
				surface.PlaySound("murdered/vgui/buy.wav")
				net.Start("MuR.UseShop")
				net.WriteString("Civilian")
				net.WriteFloat(k)
				net.SendToServer()
			else
				surface.PlaySound("murdered/vgui/ui_return.wav")
			end
        end

    end
end

function OpenKillerShop()
	if not LocalPlayer():IsKiller() then return end

    local shopmenu = vgui.Create("DFrame")
    local frameW, frameH, animTime, animDelay, animEase = We(1400), He(800), 1.8, 0, 0.1
    local animating = true
    shopmenu:SetSize(0, 0)
    shopmenu:MakePopup()
    shopmenu:SetTitle("")
    shopmenu:SizeTo(frameW, frameH, animTime, animDelay, animEase, function()
        animating = false
    end)
	shop_select_panel = shopmenu

	local scr = vgui.Create("DScrollPanel", shopmenu)
	scr:Dock(FILL)
    
    shopmenu.Think = function(self)
        if animating then
            shopmenu:Center()
        end
    end
    
    shopmenu.Paint = function(self, w, h)
    
        draw.RoundedBox(2, 0, 0, w, h, Color(20, 20, 20, 190))
    
        draw.RoundedBox(2, 5, 5, w-20, h-10, Color(100, 100, 100, 150))

        draw.SimpleTextOutlined(MuR.Language["blackmarket"], "MuR_Font3", We(15), He(18), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
    
    end

    for k, v in pairs(MuR.Shop["Killer"]) do
        local item = scr:Add("DPanel")
        item:Dock(TOP)
        item:DockMargin(0, 0, 10, 5)
        item:SetSize(We(200), He(150))
    
        item.Paint = function(self, w, h)
    
            draw.RoundedBox(4, 0, 0, w, h, Color(20, 20, 20, 150))
    
            draw.RoundedBox(4, 5, 5, w-10, h-10, Color(100, 100, 100, 150))
    
            draw.SimpleTextOutlined(v.name, "MuR_Font4", We(150), h/3.25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
            draw.SimpleTextOutlined("$".." "..v.price, "MuR_Font3", We(150), h/1.25, Color(50, 83, 52), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
    
            local itemmaterial = Material(v.icon)
            surface.SetMaterial(itemmaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRect(We(50), h/2.5, We(50), He(50))
    
        end

        local buy = vgui.Create("DButton", item)
        buy:SetSize(We(100), He(100))
        buy:SetPos(We(1250), He(25))
        buy:SetText("")

        buy.Paint = function(self, w, h)
            
            draw.RoundedBox(4, 0, 0, w, h, Color(20, 20, 20, 150))
            
            draw.RoundedBox(4, 5, 5, w-10, h-10, Color(39, 120, 62, 150))
    
            draw.SimpleTextOutlined("Buy", "MuR_Font3", We(30), h/2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
            
        end
    
        buy.DoClick = function(self)
			local m = LocalPlayer():GetNWFloat('Money')

			if m >= v.price then
				surface.PlaySound("murdered/vgui/buy.wav")
				net.Start("MuR.UseShop")
				net.WriteString("Killer")
				net.WriteFloat(k)
				net.SendToServer()
			else
				surface.PlaySound("murdered/vgui/ui_return.wav")
			end
        end
    end
end

function OpenSoldierShop()
	if not MuR.Data["War"] and LocalPlayer():GetNWString('Class') != "Soldier" then return end

    local shopmenu = vgui.Create("DFrame")
    local frameW, frameH, animTime, animDelay, animEase = We(1400), He(800), 1.8, 0, 0.1
    local animating = true
    shopmenu:SetSize(0, 0)
    shopmenu:MakePopup()
    shopmenu:SetTitle("")
    shopmenu:SizeTo(frameW, frameH, animTime, animDelay, animEase, function()
        animating = false
    end)
	shop_select_panel = shopmenu

	local scr = vgui.Create("DScrollPanel", shopmenu)
	scr:Dock(FILL)
    
    shopmenu.Think = function(self)
        if animating then
            shopmenu:Center()
        end
    end
    
    shopmenu.Paint = function(self, w, h)
    
        draw.RoundedBox(2, 0, 0, w, h, Color(20, 20, 20, 190))
    
        draw.RoundedBox(2, 5, 5, w-20, h-10, Color(100, 100, 100, 150))

        draw.SimpleTextOutlined(MuR.Language["milequipment"], "MuR_Font3", We(15), He(18), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
    
    end

    for k, v in pairs(MuR.Shop["Soldier"]) do
        local item = scr:Add("DPanel")
        item:Dock(TOP)
        item:DockMargin(0, 0, 10, 5)
        item:SetSize(We(200), He(150))
    
        item.Paint = function(self, w, h)
    
            draw.RoundedBox(4, 0, 0, w, h, Color(20, 20, 20, 150))
    
            draw.RoundedBox(4, 5, 5, w-10, h-10, Color(100, 100, 100, 150))
    
            draw.SimpleTextOutlined(v.name, "MuR_Font4", We(150), h/3.25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
            draw.SimpleTextOutlined("$".." "..v.price, "MuR_Font3", We(150), h/1.25, Color(50, 83, 52), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
    
            local itemmaterial = Material(v.icon)
            surface.SetMaterial(itemmaterial)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRect(We(50), h/2.5, We(50), He(50))
    
        end

        local buy = vgui.Create("DButton", item)
        buy:SetSize(We(100), He(100))
        buy:SetPos(We(1250), He(25))
        buy:SetText("")

        buy.Paint = function(self, w, h)
            
            draw.RoundedBox(4, 0, 0, w, h, Color(20, 20, 20, 150))
            
            draw.RoundedBox(4, 5, 5, w-10, h-10, Color(39, 120, 62, 150))
    
            draw.SimpleTextOutlined("Buy", "MuR_Font3", We(30), h/2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
            
        end
    
        buy.DoClick = function(self)
			local m = LocalPlayer():GetNWFloat('Money')

			if m >= v.price then
				surface.PlaySound("murdered/vgui/buy.wav")
				net.Start("MuR.UseShop")
				net.WriteString("Soldier")
				net.WriteFloat(k)
				net.SendToServer()
			else
				surface.PlaySound("murdered/vgui/ui_return.wav")
			end
        end
    end
end