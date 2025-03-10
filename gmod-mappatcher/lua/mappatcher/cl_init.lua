local BufferInterface = MapPatcher.Libs.BufferInterface

function MapPatcher.Message(msg, btn_msg, title, font)
  local window = vgui.Create("DFrame", MapPatcher.Editor.Screen)
  local font = font or "MapPatcherHelp"

  local title = title

  if title then
    title = title
  else
    title = language.GetPhrase("#mappatcher.menu.title") .. " " .. MAPPATCHER_VERSION
  end

  local btn_msg = btn_msg or "OK"
  local msg = msg or "<MESSAGE>"
  window:SetDraggable(false)
  window:ShowCloseButton(false)
  window:SetDrawOnTop(true)
  window:SetBackgroundBlur(true)

  function window:Paint(w, h)
    surface.SetDrawColor(Color(0, 0, 0, 255))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawOutlinedRect(0, 0, w, h, 3)
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawRect(0, 0, w, 25)

    surface.SetTextColor(Color(0, 0, 0, 255))
    surface.SetFont(font)

    local tW, tH = surface.GetTextSize(title)

    -- 6 is the outline
    surface.SetTextPos((w - 6 - tW) * 0.5, (25 - tH) * 0.5)
    surface.DrawText(title)
  end

  local contents = vgui.Create("DPanel", window)
  contents:SetSkin("MapPatcher")
  contents:SetPaintBackground(false)

  local text = vgui.Create("DLabel", contents)
  text:SetFont(font)
  text:SetText(msg)
  text:SizeToContents()
  text:SetContentAlignment(5)
  text:SetTextColor(Color(255, 255, 255, 255))

  local btnPanel = vgui.Create("DPanel", window)
  btnPanel:SetTall(30)
  btnPanel:SetPaintBackground(false)
  btnPanel:SetSkin("MapPatcher")

  local btn = vgui.Create("DButton", btnPanel)
  btn:SetText(btn_msg)
  btn:SetFont(font)
  btn:SizeToContents()
  btn:SetTall(20)
  btn:SetWide(btn:GetWide() + 50)
  btn:SetPos(5, 5)
  btn.DoClick = function()
    window:Close()
  end

  function btn:Paint(w, h)
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawRect(0, 0, w, h)
  end

  btnPanel:SetWide(btn:GetWide() + 10)

  local w, h = text:GetSize()

  window:SetSize(w + 50, h + 25 + 45 + 10)
  window:Center()

  contents:StretchToParent(5, 31, 5, 35)
  text:StretchToParent(5, 5, 5, 5)
  btnPanel:CenterHorizontal()
  btnPanel:AlignBottom(4)

  window:MakePopup()
  window:DoModal()

  return window
end

function MapPatcher.GetButtonPaint(style)
  local func = nil
  local style = style or "default"

  if style == "default" then
    return function(w, h)
      surface.SetDrawColor(0, 0, 0, 255)
    end
  else
    if style == "x.white" then
      return function(_, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(0, 0, w, h)
      end
    end
  end
end

function MapPatcher.SetButtonStyle(button, style)
  button.Paint = MapPatcher.GetButtonPaint(style)

  if style == "x.white" then
    button:SetColor(Color(0, 0, 0, 255))
  end
end

function MapPatcher.GetWindowPaint(title)
  function Func(pnl, w, h)
    surface.SetDrawColor(Color(0, 0, 0, 255))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawOutlinedRect(0, 0, w, h, 3)
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawRect(0, 0, w, 25)

    surface.SetTextColor(Color(0, 0, 0, 255))
    surface.SetFont(font)

    local tW, tH = surface.GetTextSize(title)

    -- 6 is the outline
    surface.SetTextPos((w - 6 - tW) * 0.5, (25 - tH) * 0.5)
    surface.DrawText(title)
  end
  return Func
end

MapPatcher.CVarDraw = CreateConVar("mappatcher_draw", "0")
cvars.AddChangeCallback(
  "mappatcher_draw",
  function(convar_name, value_old, value_new)
    if not MapPatcher.HasAccess(LocalPlayer()) then
      return
    end

    if tobool(value_new) then
      MapPatcher.Editor.LoadMapClipBrushes()
    end
  end,
  "mappatcher_draw"
)

net.Receive(
  "mappatcher_update",
  function(len)
    local n_objects = net.ReadUInt(16)
    for i = 1, n_objects do
      local object_id = net.ReadUInt(16)
      local object_class = net.ReadString()

      local oldObject = MapPatcher.Objects[object_id]
      if oldObject ~= nil then
        oldObject:Terminate()
      end

      local object = MapPatcher.NewToolObject(object_class)
      object.ID = object_id
      MapPatcher.Objects[object_id] = object

      local buffer = BufferInterface("net")
      object:ReadFromBuffer(buffer)
      object:SessionReadFromBuffer(buffer)

      local clientModel = MapPatcher.Editor.LadderEnts[object_id]
      if clientModel ~= nil and object_class == "null" then
        clientModel:Remove()
      end

      object:Initialize()

      MsgN("[MapPatcher] Object update: id(" .. object_id .. ") class(" .. object_class .. ")")
    end
    if MapPatcher.Editor.Enabled then
      MapPatcher.Editor.UpdateMenu()
    end
  end
)
