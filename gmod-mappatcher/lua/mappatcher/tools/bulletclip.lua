TOOL.Base = "base_brush"
if CLIENT then
  TOOL.Description = language.GetPhrase("#mappatcher.tools.bulletclip.description")
end
--------------------------------------------------------------------------------
TOOL.TextureColor = Color(147, 112, 219, 200)
TOOL.TextureText = "#mappatcher.tools.bulletclip.title"
--------------------------------------------------------------------------------
function TOOL:EntSetup(ent)
  ent:SetSolidFlags(FSOLID_CUSTOMBOXTEST + FSOLID_CUSTOMRAYTEST)
  ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
end

function TOOL:EntStartTouch(ent) end

function TOOL:EntShouldCollide(ent)
  return true
end
--------------------------------------------------------------------------------
