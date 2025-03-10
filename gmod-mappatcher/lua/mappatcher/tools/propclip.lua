TOOL.Base = "base_brush"
if CLIENT then
  TOOL.Description = language.GetPhrase("mappatcher.tools.propclip.description")
end
--------------------------------------------------------------------------------

TOOL.TextureColor = Color(139, 69, 19, 200)
TOOL.TextureText = "#mappatcher.tools.propclip.title"
--------------------------------------------------------------------------------
function TOOL:EntSetup(ent)
  ent:SetSolidFlags(FSOLID_CUSTOMBOXTEST)
end

function TOOL:EntStartTouch(ent)
end

function TOOL:EntShouldCollide(ent)
  return ent:GetMoveType() == MOVETYPE_VPHYSICS
end
--------------------------------------------------------------------------------
