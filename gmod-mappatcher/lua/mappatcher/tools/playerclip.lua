TOOL.Base = "base_brush"
if CLIENT then
  TOOL.Description = language.GetPhrase("mappatcher.tools.playerclip.description")
end

--------------------------------------------------------------------------------

TOOL.TextureColor = Color(255, 200, 0, 200)
TOOL.TextureText = "#mappatcher.tools.playerclip.title"
--------------------------------------------------------------------------------
function TOOL:EntSetup(ent)
  ent:SetSolidFlags(FSOLID_CUSTOMBOXTEST)
end

function TOOL:EntStartTouch(ent)
end

function TOOL:EntShouldCollide(ent)
  return ent:IsPlayer()
end
--------------------------------------------------------------------------------
