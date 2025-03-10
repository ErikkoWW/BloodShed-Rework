local TOOL = TOOL

TOOL.Base = "base_brush"
if CLIENT then
  TOOL.Description = language.GetPhrase("mappatcher.tools.x3m4k_kill.description")
end
--------------------------------------------------------------------------------
TOOL.TextureColor = Color(242, 85, 0, 200)
TOOL.TextureText = "#mappatcher.tools.x3m4k_kill.title"
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

function TOOL:EntStartTouch(ent)
  if not IsValid(ent) then
    return
  end
  if ent.MapPatcherObject then
    return
  end

  if self.data.force_player_drop == true then
    ent:ForcePlayerDrop()
    MapPatcher.DisallowPlayersPickup(1, ent)
  end

  if self.data.kill_prop == false and ent:GetClass() == "prop_physics" then
    return
  end
  if self.data.kill_ragdoll == false and ent:IsRagdoll() then
    return
  end
  if self.data.kill_vehicle == false and ent:IsVehicle() then
    return
  end
  if self.data.kill_npc_and_nextbot == false and (ent:IsNPC() or ent:IsNextBot()) then
    return
  end

  if
    self.data.kill_other_entity == false
    and ent:GetClass() ~= "prop_physics"
    and not ent:IsPlayer()
    and not ent:IsRagdoll()
    and not ent:IsWeapon()
    and not ent:IsScripted()
    and not ent:IsVehicle()
    and not ent:IsNPC()
    and not ent:IsNextBot()
    then
    return
  end

  ent:Remove()
end

function TOOL:EntTouch(ent)
  if not IsValid(ent) then
    return
  end
  if ent.MapPatcherObject then
    return
  end

  if self.data.kill_prop == false and ent:GetClass() == "prop_physics" then
    return
  end
  if self.data.kill_player == false and ent:IsPlayer() then
    return
  end
  if self.data.kill_ragdoll == false and ent:IsRagdoll() then
    return
  end
  if self.data.kill_weapon == false and ent:IsWeapon() then
    return
  end
  if self.data.kill_sent == false and ent:IsScripted() then
    return
  end
  if self.data.kill_vehicle == false and ent:IsVehicle() then
    return
  end
  if self.data.kill_npc_and_nextbot == false and (ent:IsNPC() or ent:IsNextBot()) then
    return
  end

  if ent:IsPlayer() then
    if self.data.silent_kill then
      ent:KillSilent()
    else
      ent:Kill()
    end
    return
  end

  if
    self.data.kill_other_entity == false
    and ent:GetClass() ~= "prop_physics"
    and not ent:IsPlayer()
    and not ent:IsRagdoll()
    and not ent:IsWeapon()
    and not ent:IsScripted()
    and not ent:IsVehicle()
    and not ent:IsNPC()
    and not ent:IsNextBot()
    then
    return
  end

  ent:Remove()
end

function TOOL:EntShouldCollide(ent)
  if
    ent:IsRagdoll()
    or ent:IsPlayer()
    or ent:IsVehicle()
    or ent:IsNPC()
    or ent:IsNextBot()
    or ent:GetClass() == "prop_physics"
    then
    return false
  end

  if self.data.kill_weapon == false and ent:IsWeapon() then
    return false
  end
  if self.data.kill_sent == false and ent:IsScripted() then
    return false
  end

  return true
end

function TOOL:ObjectCreated()
  TOOL:GetBase().ObjectCreated(self)

  local data = {}

  data.silent_kill = false
  data.kill_prop = true
  data.kill_player = true
  data.kill_vehicle = true
  data.kill_weapon = true
  data.kill_ragdoll = true
  data.kill_npc_and_nextbot = true
  data.kill_sent = true
  data.kill_other_entity = true
  -- data.clip_bullets = true
  data.force_player_drop = true

  self.data = data
end

function TOOL:WriteToBuffer(buffer)
  TOOL:GetBase().WriteToBuffer(self, buffer)

  buffer:WriteString(util.TableToJSON(self.data))
end

function TOOL:ReadFromBuffer(buffer, len)
  TOOL:GetBase().ReadFromBuffer(self, buffer)

  self.data = util.JSONToTable(buffer:ReadString())
end

--------------------------------------------------------------------------------

function TOOL:SetupObjectPanel(panel)
  local lblClip = vgui.Create("DLabel", panel)
  lblClip:SetTextColor(Color(255, 255, 255, 255))
  lblClip:SetPos(10, 10)
  lblClip:SetText("#mappatcher.tools.x3m4k_kill.settings.kill")
  local lblClipW, _ = lblClip:GetTextSize()

  local cbxKillSilently = vgui.Create("DCheckBoxLabel", panel)
  cbxKillSilently:SetPos(10 + 6 + lblClipW, 12)
  cbxKillSilently:SetText("#mappatcher.tools.x3m4k_kill.settings.player_silent_kill")
  cbxKillSilently:SetValue(self.data.silent_kill)
  cbxKillSilently:SizeToContents()
  cbxKillSilently.OnChange = function(panel, val)
    self.data.silent_kill = val
  end

  local cbxKillSilently = vgui.Create("DCheckBoxLabel", panel)
  cbxKillSilently:SetPos(10, 32)
  cbxKillSilently:SetText("#mappatcher.players")
  cbxKillSilently:SetValue(self.data.kill_player)
  cbxKillSilently:SizeToContents()
  cbxKillSilently.OnChange = function(panel, val)
    self.data.kill_player = val
  end

  local cbxKillProps = vgui.Create("DCheckBoxLabel", panel)
  cbxKillProps:SetPos(100, 32)
  cbxKillProps:SetText("#mappatcher.props")
  cbxKillProps:SetValue(self.data.kill_prop)
  cbxKillProps:SizeToContents()
  cbxKillProps.OnChange = function(panel, val)
    self.data.kill_prop = val
  end

  local cbxKillVehicles = vgui.Create("DCheckBoxLabel", panel)
  cbxKillVehicles:SetPos(190, 32)
  cbxKillVehicles:SetText("#mappatcher.vehicles")
  cbxKillVehicles:SetValue(self.data.kill_vehicle)
  cbxKillVehicles:SizeToContents()
  cbxKillVehicles.OnChange = function(panel, val)
    self.data.kill_vehicle = val
  end

  local cbxKillRagdolls = vgui.Create("DCheckBoxLabel", panel)
  cbxKillRagdolls:SetPos(10, 52)
  cbxKillRagdolls:SetText("#mappatcher.ragdolls")
  cbxKillRagdolls:SetValue(self.data.kill_ragdoll)
  cbxKillRagdolls:SizeToContents()
  cbxKillRagdolls.OnChange = function(panel, val)
    self.data.kill_ragdoll = val
  end

  local cbxKillWeapons = vgui.Create("DCheckBoxLabel", panel)
  cbxKillWeapons:SetPos(100, 52)
  cbxKillWeapons:SetText("#mappatcher.weapons")
  cbxKillWeapons:SetValue(self.data.kill_weapon)
  cbxKillWeapons:SizeToContents()
  cbxKillWeapons.OnChange = function(panel, val)
    self.data.kill_weapon = val
  end

  local cbxKillNPCAndNextBot = vgui.Create("DCheckBoxLabel", panel)
  cbxKillNPCAndNextBot:SetPos(190, 52)
  cbxKillNPCAndNextBot:SetText("#mappatcher.npcs_and_nextbots")
  cbxKillNPCAndNextBot:SetValue(self.data.kill_npc_and_nextbot)
  cbxKillNPCAndNextBot:SizeToContents()
  cbxKillNPCAndNextBot.OnChange = function(panel, val)
    self.data.kill_npc_and_nextbot = val
  end

  local cbxKillSENTs = vgui.Create("DCheckBoxLabel", panel)
  cbxKillSENTs:SetPos(10, 72)
  cbxKillSENTs:SetText("#mappatcher.sents")
  cbxKillSENTs:SetValue(self.data.kill_sent)
  cbxKillSENTs:SizeToContents()
  cbxKillSENTs.OnChange = function(panel, val)
    self.data.kill_sent = val
  end

  local cbxKillOtherEntities = vgui.Create("DCheckBoxLabel", panel)
  cbxKillOtherEntities:SetPos(100, 72)
  cbxKillOtherEntities:SetText("#mappatcher.other_entities")
  cbxKillOtherEntities:SetValue(self.data.kill_other_entity)
  cbxKillOtherEntities:SizeToContents()
  cbxKillOtherEntities.OnChange = function(panel, val)
    self.data.kill_other_entity = val
  end

  -- local cbxClipBullets = vgui.Create("DCheckBoxLabel", panel)
  -- cbxClipBullets:SetPos(190, 72)
  -- cbxClipBullets:SetText("#mappatcher.bullets")
  -- cbxClipBullets:SetValue(self.data.clip_bullets)
  -- cbxClipBullets:SizeToContents()
  -- cbxClipBullets.OnChange = function(panel, val)
  --   self.data.clip_bullets = val
  -- end
end
