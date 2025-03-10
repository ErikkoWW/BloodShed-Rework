local TOOL = TOOL

TOOL.Base = "base_brush"
if CLIENT then
  TOOL.Description = language.GetPhrase("mappatcher.tools.x3m4k_clip.description")
end

--------------------------------------------------------------------------------

TOOL.TextureColor = Color(100, 100, 100, 200)
TOOL.TextureText = "#mappatcher.tools.x3m4k_clip.title"
--------------------------------------------------------------------------------
function TOOL:EntSetup(ent)
  ent:SetSolidFlags(FSOLID_CUSTOMBOXTEST + FSOLID_CUSTOMRAYTEST)

  if CLIENT then
    local origin = self:GetOrigin()
    local min = Vector()
    local max = Vector()

    for k, point in pairs(self.points) do
      local lp = point - origin
      min.x = math.min(min.x, lp.x)
      min.y = math.min(min.y, lp.y)
      min.z = math.min(min.z, lp.z)
      max.x = math.max(max.x, lp.x)
      max.y = math.max(max.y, lp.y)
      max.z = math.max(max.z, lp.z)
    end

    ent:SetRenderBounds(min, max)

    if self.data.texture == "forcefield" then
      ent.snd_forcefield_loop = "mappatcher_forcefield_loop_" .. (ent:EntIndex())
      sound.Add({
        name = "mappatcher_forcefield_loop_" .. (ent:EntIndex()),
        channel = CHAN_AUTO,
        volume = 0.5,
        level = 55,
        pitch = 100,
        sound = "ambient/energy/force_field_loop1.wav",
      })
      ent:EmitSound(ent.snd_forcefield_loop)
    end
  end
end

function TOOL:EntStartTouch(ent)
  if self.data.force_player_drop == true then
    ent:ForcePlayerDrop()
    MapPatcher.DisallowPlayersPickup(1, ent)
  end
end

function TOOL:EntShouldCollide(ent)
  if ent:GetClass() == "prop_physics" then
    return self.data.clip_prop
  end
  if ent:IsPlayer() then
    if not self.data.clip_player then
      return false
    end

    if not self.data.group_invert then
      return MapPatcher.Groups.Check(self.data.group, ent)
    else
      return not MapPatcher.Groups.Check(self.data.group, ent)
    end
  end
  if ent:IsVehicle() then
    return self.data.clip_vehicle
  end
  if ent:IsWeapon() then
    return self.data.clip_weapon
  end
  if ent:IsRagdoll() then
    return self.data.clip_ragdoll
  end
  if ent:IsNPC() or ent:IsNextBot() then
    return self.data.clip_npc_and_nextbot
  end
  if ent:IsScripted() then
    return self.data.clip_sent
  end
  return self.data.clip_other_entity
end
--------------------------------------------------------------------------------
function TOOL:ObjectCreated()
  TOOL:GetBase().ObjectCreated(self)

  local data = {}

  data.clip_prop = true
  data.clip_player = true
  data.clip_vehicle = true
  data.clip_weapon = true
  data.clip_ragdoll = true
  data.clip_npc_and_nextbot = true
  data.clip_sent = true
  data.clip_other_entity = true
  data.group = "everyone"
  data.group_invert = false
  data.texture = ""
  data.color = Color(255, 255, 255)
  -- data.clip_bullets = true
  data.force_player_drop = true

  self.data = data
end

function TOOL:WriteToBuffer(buffer)
  TOOL:GetBase().WriteToBuffer(self, buffer)
  self.data.color = self.color
  buffer:WriteString(util.TableToJSON(self.data))
end

function TOOL:ReadFromBuffer(buffer, len)
  TOOL:GetBase().ReadFromBuffer(self, buffer)

  self.data = util.JSONToTable(buffer:ReadString())
  self.color = self.data.color
end

--------------------------------------------------------------------------------

function TOOL:SetupObjectPanel(panel)
  local lblClip = vgui.Create("DLabel", panel)
  lblClip:SetTextColor(Color(255, 255, 255, 255))
  lblClip:SetPos(10, 10)
  lblClip:SetText("#mappatcher.tools.x3m4k_clip.settings.clip")

  local cbxClipPlayers = vgui.Create("DCheckBoxLabel", panel)
  cbxClipPlayers:SetPos(10, 32)
  cbxClipPlayers:SetText("#mappatcher.players")
  cbxClipPlayers:SetValue(self.data.clip_player)
  cbxClipPlayers:SizeToContents()
  cbxClipPlayers.OnChange = function(panel, val)
    self.data.clip_player = val
  end

  local cbxClipProps = vgui.Create("DCheckBoxLabel", panel)
  cbxClipProps:SetPos(100, 32)
  cbxClipProps:SetText("#mappatcher.props")
  cbxClipProps:SetValue(self.data.clip_prop)
  cbxClipProps:SizeToContents()
  cbxClipProps.OnChange = function(panel, val)
    self.data.clip_prop = val
  end

  local cbxClipVehicles = vgui.Create("DCheckBoxLabel", panel)
  cbxClipVehicles:SetPos(190, 32)
  cbxClipVehicles:SetText("#mappatcher.vehicles")
  cbxClipVehicles:SetValue(self.data.clip_vehicle)
  cbxClipVehicles:SizeToContents()
  cbxClipVehicles.OnChange = function(panel, val)
    self.data.clip_vehicle = val
  end

  local cbxClipRagdolls = vgui.Create("DCheckBoxLabel", panel)
  cbxClipRagdolls:SetPos(10, 52)
  cbxClipRagdolls:SetText("#mappatcher.ragdolls")
  cbxClipRagdolls:SetValue(self.data.clip_ragdoll)
  cbxClipRagdolls:SizeToContents()
  cbxClipRagdolls.OnChange = function(panel, val)
    self.data.clip_ragdoll = val
  end

  local cbxClipWeapons = vgui.Create("DCheckBoxLabel", panel)
  cbxClipWeapons:SetPos(100, 52)
  cbxClipWeapons:SetText("#mappatcher.weapons")
  cbxClipWeapons:SetValue(self.data.clip_weapon)
  cbxClipWeapons:SizeToContents()
  cbxClipWeapons.OnChange = function(panel, val)
    self.data.clip_weapon = val
  end

  local cbxClipNPCAndNextBot = vgui.Create("DCheckBoxLabel", panel)
  cbxClipNPCAndNextBot:SetPos(190, 52)
  cbxClipNPCAndNextBot:SetText("#mappatcher.npcs_and_nextbots")
  cbxClipNPCAndNextBot:SetValue(self.data.clip_npc_and_nextbot)
  cbxClipNPCAndNextBot:SizeToContents()
  cbxClipNPCAndNextBot.OnChange = function(panel, val)
    self.data.clip_npc_and_nextbot = val
  end

  local cbxClipSENTs = vgui.Create("DCheckBoxLabel", panel)
  cbxClipSENTs:SetPos(10, 72)
  cbxClipSENTs:SetText("#mappatcher.sents")
  cbxClipSENTs:SetValue(self.data.clip_sent)
  cbxClipSENTs:SizeToContents()
  cbxClipSENTs.OnChange = function(panel, val)
    self.data.clip_sent = val
  end

  local cbxClipOtherEntities = vgui.Create("DCheckBoxLabel", panel)
  cbxClipOtherEntities:SetPos(100, 72)
  cbxClipOtherEntities:SetText("#mappatcher.other_entities")
  cbxClipOtherEntities:SetValue(self.data.clip_other_entity)
  cbxClipOtherEntities:SizeToContents()
  cbxClipOtherEntities.OnChange = function(panel, val)
    self.data.clip_other_entity = val
  end

  local offsetY = 60

  local lblGroup = vgui.Create("DLabel", panel)
  lblGroup:SetTextColor(Color(255, 255, 255, 255))
  lblGroup:SetPos(10, 35 + offsetY)
  lblGroup:SetText("#mappatcher.tools.x3m4k_clip.settings.block_players")
  lblGroup:SetSize(lblGroup:GetTextSize())

  local cmbGroup = vgui.Create("DComboBox", panel)
  cmbGroup:SetPos(10 + lblGroup:GetTextSize(), 35 + offsetY)
  cmbGroup:SetSize(110, 20)
  for key, group in pairs(MapPatcher.Groups.GetGroups()) do
    cmbGroup:AddChoice(MapPatcher.Groups.GetName(group), group, self.data.group == group)
  end
  cmbGroup.OnSelect = function(panel, index, value, data)
    self.data.group = data
  end

  local cbxGroupInvert = vgui.Create("DCheckBoxLabel", panel)
  cbxGroupInvert:SetPos(10 + lblGroup:GetTextSize() + 110 + 10, 37 + offsetY)
  cbxGroupInvert:SetText("#mappatcher.tools.custom.settings.invert")
  cbxGroupInvert:SetValue(self.data.group_invert)
  cbxGroupInvert:SizeToContents()

  cbxGroupInvert.OnChange = function(panel, val)
    self.data.group_invert = val
  end

  local lblTexture = vgui.Create("DLabel", panel)
  lblTexture:SetTextColor(Color(255, 255, 255, 255))
  lblTexture:SetPos(10, 60 + offsetY)
  lblTexture:SetText("#mappatcher.tools.custom.settings.texture")

  local cmbGroup = vgui.Create("DComboBox", panel)
  cmbGroup:SetPos(55, 60 + offsetY)
  cmbGroup:SetSize(110, 20)
  cmbGroup:AddChoice("#mappatcher.tools.custom.settings.invisible", "", self.data.texture == "")
  cmbGroup:AddChoice("#mappatcher.tools.custom.settings.forcefield", "forcefield", self.data.texture == "forcefield")
  cmbGroup:AddChoice("#mappatcher.tools.custom.settings.solid", "solid", self.data.texture == "solid")
  cmbGroup.OnSelect = function(panel, index, value, data)
    self.data.texture = data
  end

  local lblColor = vgui.Create("DLabel", panel)
  lblColor:SetTextColor(Color(255, 255, 255, 255))
  lblColor:SetPos(10, 85 + offsetY)
  lblColor:SetText("#mappatcher.tools.custom.settings.color")

  local colorPicker = vgui.Create("DColorMixer", panel)
  colorPicker:SetPos(55, 85 + offsetY)
  colorPicker:SetSize(300, 200)
  colorPicker:SetPalette(true)
  colorPicker:SetAlphaBar(true)
  colorPicker:SetWangs(true)
  colorPicker:SetColor(self.data.color)
  colorPicker.ValueChanged = function(panel, col)
    self.data.color = col
    self.color = col
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

local mat_forcefield = Material("effects/combineshield/comshieldwall2")
local mat_solid = Material("color")
function TOOL:EntDraw(ent)
  if self.data.texture == "forcefield" then
    self:BuildMesh()
    render.SetMaterial(mat_forcefield)

    for i = 1, 8 do
      self.render_mesh:Draw()
    end
  elseif self.data.texture == "solid" then
    self:BuildMesh()
    render.SetMaterial(mat_solid)
    self.render_mesh:Draw()
  end
end

local hit_sounds = {}
for i = 1, 4 do
  hit_sounds[#hit_sounds + 1] = Sound("ambient/energy/spark" .. i .. ".wav")
end

function TOOL:EntImpactTrace(ent, trace, dmgtype, customimpactname)
  if self.data.texture == "forcefield" then
    if IsFirstTimePredicted() then
      EmitSound(hit_sounds[math.random(1, #hit_sounds)], trace.HitPos, ent:EntIndex(), CHAN_AUTO, 1, 80, 0, 100)
    end

    local effectdata = EffectData()
    effectdata:SetOrigin(trace.HitPos)
    effectdata:SetNormal(trace.HitNormal)
    util.Effect("AR2Impact", effectdata)
    return true
  end
end
