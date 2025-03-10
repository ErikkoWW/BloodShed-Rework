local TOOL = TOOL
local allDirections = {
  [1] = "+x",
  [2] = "+y",
  [3] = "+z",
  [4] = "-x",
  [5] = "-y",
  [6] = "-z"
}

TOOL.Base = "base_brush"
if CLIENT then
  TOOL.Description = language.GetPhrase("mappatcher.tools.x3m4k_push.description")
end
--------------------------------------------------------------------------------
TOOL.TextureColor = Color(242, 202, 0, 200)
TOOL.TextureText = "#mappatcher.tools.x3m4k_push.title"
--------------------------------------------------------------------------------
function TOOL:EntSetup(ent)
  local flags = FSOLID_CUSTOMBOXTEST

  -- if self.data.clip_bullets then
  --   flags = flags + FSOLID_CUSTOMRAYTEST
  -- end

  ent:SetSolidFlags(flags)

  if SERVER then
    ent:SetTrigger(true)
  end
end

function TOOL:ObjectCreated()
  TOOL:GetBase().ObjectCreated(self)

  local data = {}

  data.push_force = 200
  data.push_directions = {true, true, true, true, false, false}
  data.push_prop = true
  data.push_player = true
  data.push_vehicle = true
  data.push_weapon = true
  data.push_ragdoll = true
  data.push_npc_and_nextbot = true
  data.push_sent = true
  data.push_other_entity = true
  data.divide_force_per_coordinate = true
  -- data.clip_bullets = true
  data.force_player_drop = true
  data.drop_time = 1

  self.data = data
end

function TOOL:ToolSwitchFrom(old_object)
end

function TOOL:ToolSwitchTo(new_object)
end

function TOOL:WriteToBuffer(buffer)
  TOOL:GetBase().WriteToBuffer(self, buffer)

  buffer:WriteString(util.TableToJSON(self.data))
end

function TOOL:ReadFromBuffer(buffer, len)
  TOOL:GetBase().ReadFromBuffer(self, buffer)

  self.data = util.JSONToTable(buffer:ReadString())
end

function TOOL:SetupObjectPanel(panel)
  local offsetY = 0
  -- local DBtnManage = vgui.Create("DButton", panel)
  -- DBtnManage:SetText(
  -- language.GetPhrase("#mappatcher.menu.db_manage"))
  -- DBtnManage:SetPos(10, 10)
  -- DBtnManage:SetSize(450, 30)

  local DBtnHelp = vgui.Create("DButton", panel)
  DBtnHelp:SetText(
    language.GetPhrase("#mappatcher.tools.x3m4k_push.settings.push") ..
      " " .. language.GetPhrase("#mappatcher.press_for_help")
  )
  DBtnHelp:SetPos(10, 10 + offsetY)
  DBtnHelp:SetSize(450, 20)

  function DBtnHelp:DoClick()
    MapPatcher.Message(
      "#mappatcher.tools.x3m4k_push.help.push",
      nil,
      language.GetPhrase("#mappatcher.tools.x3m4k_push.settings.push")
    )
  end

  local cbxPushPlayers = vgui.Create("DCheckBoxLabel", panel)
  cbxPushPlayers:SetPos(10, 32 + offsetY)
  cbxPushPlayers:SetText("#mappatcher.players")
  cbxPushPlayers:SetValue(self.data.push_player)
  cbxPushPlayers:SizeToContents()
  cbxPushPlayers.OnChange = function(panel, val)
    self.data.push_player = val
  end

  local cbxPushProps = vgui.Create("DCheckBoxLabel", panel)
  cbxPushProps:SetPos(100, 32 + offsetY)
  cbxPushProps:SetText("#mappatcher.props")
  cbxPushProps:SetValue(self.data.push_prop)
  cbxPushProps:SizeToContents()
  cbxPushProps.OnChange = function(panel, val)
    self.data.push_prop = val
  end

  local cbxPushVehicles = vgui.Create("DCheckBoxLabel", panel)
  cbxPushVehicles:SetPos(190, 32 + offsetY)
  cbxPushVehicles:SetText("#mappatcher.vehicles")
  cbxPushVehicles:SetValue(self.data.push_vehicle)
  cbxPushVehicles:SizeToContents()
  cbxPushVehicles.OnChange = function(panel, val)
    self.data.push_vehicle = val
  end

  local cbxPushRagdolls = vgui.Create("DCheckBoxLabel", panel)
  cbxPushRagdolls:SetPos(10, 52 + offsetY)
  cbxPushRagdolls:SetText("#mappatcher.ragdolls")
  cbxPushRagdolls:SetValue(self.data.push_ragdoll)
  cbxPushRagdolls:SizeToContents()
  cbxPushRagdolls.OnChange = function(panel, val)
    self.data.push_ragdoll = val
  end

  local cbxPushWeapons = vgui.Create("DCheckBoxLabel", panel)
  cbxPushWeapons:SetPos(100, 52 + offsetY)
  cbxPushWeapons:SetText("#mappatcher.weapons")
  cbxPushWeapons:SetValue(self.data.push_weapon)
  cbxPushWeapons:SizeToContents()
  cbxPushWeapons.OnChange = function(panel, val)
    self.data.push_weapon = val
  end

  local cbxPushNPCAndNextBot = vgui.Create("DCheckBoxLabel", panel)
  cbxPushNPCAndNextBot:SetPos(190, 52 + offsetY)
  cbxPushNPCAndNextBot:SetText("#mappatcher.npcs_and_nextbots")
  cbxPushNPCAndNextBot:SetValue(self.data.push_npc_and_nextbot)
  cbxPushNPCAndNextBot:SizeToContents()
  cbxPushNPCAndNextBot.OnChange = function(panel, val)
    self.data.push_npc_and_nextbot = val
  end

  local cbxPushSENTs = vgui.Create("DCheckBoxLabel", panel)
  cbxPushSENTs:SetPos(10, 72 + offsetY)
  cbxPushSENTs:SetText("#mappatcher.sents")
  cbxPushSENTs:SetValue(self.data.push_sent)
  cbxPushSENTs:SizeToContents()
  cbxPushSENTs.OnChange = function(panel, val)
    self.data.push_sent = val
  end

  local cbxPushOtherEntities = vgui.Create("DCheckBoxLabel", panel)
  cbxPushOtherEntities:SetPos(100, 72 + offsetY)
  cbxPushOtherEntities:SetText("#mappatcher.other_entities")
  cbxPushOtherEntities:SetValue(self.data.push_other_entity)
  cbxPushOtherEntities:SizeToContents()
  cbxPushOtherEntities.OnChange = function(panel, val)
    self.data.push_other_entity = val
  end

  -- local cbxClipBullets = vgui.Create("DCheckBoxLabel", panel)
  -- cbxClipBullets:SetPos(190, 72 + offsetY)
  -- cbxClipBullets:SetText("#mappatcher.bullets")
  -- cbxClipBullets:SetValue(self.data.clip_bullets)
  -- cbxClipBullets:SizeToContents()
  -- cbxClipBullets.OnChange = function(panel, val)
  --   self.data.clip_bullets = val
  -- end

  local cbxForcePlayerDrop = vgui.Create("DCheckBoxLabel", panel)
  cbxForcePlayerDrop:SetPos(10, 92 + offsetY)
  cbxForcePlayerDrop:SetText("#mappatcher.force_player_drop")
  cbxForcePlayerDrop:SetValue(self.data.force_player_drop)
  cbxForcePlayerDrop:SizeToContents()
  cbxForcePlayerDrop.OnChange = function(panel, val)
    self.data.force_player_drop = val
  end

  local numDropTime = vgui.Create("DNumSlider", panel)
  numDropTime:SetPos(10, 112 + offsetY)
  numDropTime:SetSize(230, 20)
  numDropTime:SetText("#mappatcher.force_drop_time")
  numDropTime:SetMinMax(-1, 100)
  numDropTime:SetDecimals(0)
  numDropTime:SetValue(self.data.drop_time)
  numDropTime:SetSkin("MapPatcher")
  function numDropTime.OnValueChanged(pnl, val)
    self.data.drop_time = math.Clamp(val, -1, 0x64)
    numDropTime:SetValue(self.data.drop_time)
  end

  local DBtnDirectionsHelp = vgui.Create("DButton", panel)
  DBtnDirectionsHelp:SetText(
    language.GetPhrase("#mappatcher.tools.x3m4k_push.settings.directions") ..
      " " .. language.GetPhrase("#mappatcher.press_for_help")
  )
  DBtnDirectionsHelp:SetPos(10, 134 + offsetY)
  DBtnDirectionsHelp:SetSize(450, 20)

  function DBtnDirectionsHelp:DoClick()
    MapPatcher.Message(
      "#mappatcher.tools.x3m4k_push.help.directions",
      nil,
      language.GetPhrase("#mappatcher.tools.x3m4k_push.settings.directions")
    )
  end

  local function onSelectDirection(directionKey, value)
    self.data.push_directions[directionKey] = value
  end

  local i, cbxX, cbxY
  i = 0

  for directionKey, directionName in pairs(allDirections) do
    local cbxDir = vgui.Create("DCheckBoxLabel", panel)

    cbxX = 10 + (50 * (i % 3))
    cbxY = 157 + 25 * (math.floor(i / 3))

    cbxDir:SetPos(cbxX, cbxY + offsetY)
    cbxDir:SetText(directionName)
    cbxDir:SetValue(self.data.push_directions[directionKey])
    cbxDir:SizeToContents()
    cbxDir.OnChange = function(panel, val)
      onSelectDirection(directionKey, val)
    end
    i = i + 1
  end

  local numPushForce = vgui.Create("DNumSlider", panel)
  numPushForce:SetPos(10, cbxY + 20 + offsetY)
  numPushForce:SetSize(230, 20)
  numPushForce:SetText("#mappatcher.tools.x3m4k_push.settings.push_force")
  numPushForce:SetMinMax(0, 2000)
  numPushForce:SetDecimals(0)
  numPushForce:SetValue(self.data.push_force)
  numPushForce:SetSkin("MapPatcher")
  function numPushForce.OnValueChanged(pnl, val)
    self.data.push_force = math.Clamp(val, 0, 0xFFFF)
    numPushForce:SetValue(self.data.push_force)
  end

  local cbxDivideForcePerCoordinate = vgui.Create("DCheckBoxLabel", panel)
  cbxDivideForcePerCoordinate:SetPos(10, cbxY + 42 + offsetY)
  cbxDivideForcePerCoordinate:SetText("#mappatcher.tools.x3m4k_push.settings.divide_force")
  cbxDivideForcePerCoordinate:SetValue(self.data.divide_force_per_coordinate)
  cbxDivideForcePerCoordinate:SizeToContents()
  cbxDivideForcePerCoordinate.OnChange = function(panel, val)
    self.data.divide_force_per_coordinate = val
  end
end

local function fif(condition, if_true, if_false)
  if condition then
    return if_true
  else
    return if_false
  end
end

function TOOL:EntTouch(ent)
  if not IsValid(ent) or ent.MapPatcherObject then
    return
  end

  if self.data.force_player_drop then
    -- we don't check ent:IsPlayerHolding() because it is broken with multiple players.
    -- see https://github.com/Facepunch/garrysmod-issues/issues/2046
    ent:ForcePlayerDrop()
    MapPatcher.DisallowPlayersPickup(self.data.drop_time, ent)
  end

  if self.data.push_prop == false and ent:GetClass() == "prop_physics" then
    return
  end
  if self.data.push_player == false and ent:IsPlayer() then
    return
  end
  if self.data.push_ragdoll == false and ent:IsRagdoll() then
    return
  end
  if self.data.push_weapon == false and ent:IsWeapon() then
    return
  end
  if self.data.push_vehicle == false and ent:IsVehicle() then
    return
  end
  if self.data.push_npc_and_nextbot == false and (ent:IsNPC() or ent:IsNextBot()) then
    return
  end

  local physEntity = ent

  if not ent:IsPlayer() and not ent:IsNPC() and not ent:IsNextBot() then
    physEntity = fif(IsValid(ent:GetPhysicsObject()), ent:GetPhysicsObject(), ent)
  end

  local f = self.data.push_force
  local dir = self.data.push_directions

  local pushX, pushY, pushZ = 0, 0, 0

  local entPos = physEntity:GetPos()
  local selfPos = self.entity:GetPos()
  local resultVec = entPos - selfPos

  -- x axis
  if self.data.push_directions[1] == true or self.data.push_directions[4] == true then
    if resultVec[1] < 0 and self.data.push_directions[4] == true then
      pushX = -f
    elseif self.data.push_directions[1] == true then
      pushX = f
    end
  end
  --

  -- y axis
  if self.data.push_directions[2] == true or self.data.push_directions[5] == true then
    if resultVec[2] < 0 and self.data.push_directions[5] == true then
      pushY = -f
    elseif self.data.push_directions[2] == true then
      pushY = f
    end
  end
  --

  -- z axis
  if self.data.push_directions[3] == true or self.data.push_directions[6] == true then
    if resultVec[3] < 0 and self.data.push_directions[6] == true then
      pushZ = -f
    elseif self.data.push_directions[3] == true then
      pushZ = f
    end
  end
  --

  local divider = 0
  if self.data.divide_force_per_coordinate == true then
    if pushX ~= 0 then
      divider = divider + 1
    end
    if pushY ~= 0 then
      divider = divider + 1
    end
    if pushZ ~= 0 then
      divider = divider + 1
    end

    if divider == 0 then
      divider = 1
    end
  else
    divider = 1
  end

  if ent:IsNPC() or ent:IsNextBot() then
    physEntity:SetLocalVelocity(Vector(pushX / divider, pushY / divider, pushZ / divider))
  end

  physEntity:SetVelocity(Vector(pushX / divider, pushY / divider, pushZ / divider))
  return
end

function TOOL:EntShouldCollide(ent)
  if
    ent:IsRagdoll() or ent:IsPlayer() or ent:IsVehicle() or ent:IsNPC() or ent:IsNextBot() or
      ent:GetClass() == "prop_physics"
   then
    return false
  end

  if self.data.push_weapon == true and ent:IsWeapon() then
    return true
  end
  if self.data.push_sent == true and ent:IsScripted() then
    return true
  end

  return self.data.push_other_entity
end
--------------------------------------------------------------------------------
