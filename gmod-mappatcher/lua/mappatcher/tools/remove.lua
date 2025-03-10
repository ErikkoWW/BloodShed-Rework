TOOL.Base = "base_brush"
if CLIENT then
  TOOL.Description = language.GetPhrase("mappatcher.tools.remove.description")
end
--------------------------------------------------------------------------------
TOOL.TextureColor = Color(255, 0, 0, 200)
TOOL.TextureText = "#mappatcher.tools.remove.title"
--------------------------------------------------------------------------------
function TOOL:EntSetup(ent)
  ent:SetSolidFlags(FSOLID_CUSTOMBOXTEST)
  if SERVER then
    ent:SetTrigger(true)
  end
end

function TOOL:EntStartTouch(ent)
  if ent.MapPatcherObject then
    return
  end

  if ent:IsPlayer() then
    ent:KillSilent()
  else
    ent:Remove()
  end
end

function TOOL:EntShouldCollide(ent)
  return false
end
--------------------------------------------------------------------------------
