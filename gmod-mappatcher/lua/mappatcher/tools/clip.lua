TOOL.Base = "base_brush"
if CLIENT then
  TOOL.Description = language.GetPhrase("mappatcher.tools.clip.description")
end
--------------------------------------------------------------------------------
TOOL.TextureColor = Color(100, 100, 100, 200)
TOOL.TextureText = "#mappatcher.tools.clip.title"
--------------------------------------------------------------------------------
function TOOL:EntSetup(ent)
  ent:SetSolidFlags(FSOLID_CUSTOMBOXTEST + FSOLID_CUSTOMRAYTEST)
end

function TOOL:EntStartTouch(ent)
end

function TOOL:EntShouldCollide(ent)
  return true
end
--------------------------------------------------------------------------------
