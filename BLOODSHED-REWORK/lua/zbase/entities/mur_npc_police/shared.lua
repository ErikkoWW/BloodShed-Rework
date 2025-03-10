local NPC = FindZBaseTable(debug.getinfo(1, 'S'))

-- The NPC class
-- Can be any existing NPC in the game
-- If you want to make a human that can use weapons, you should probably use "npc_combine_s" or "npc_citizen" for example
-- Use "npc_zbase_snpc" if you want to create a brand new SNPC
NPC.Class = "npc_combine_s"

NPC.Name = "Police Officer" -- Name of your NPC
NPC.Category = "Bloodshed" -- Category in the ZBase tab
NPC.Weapons = {"mur_npc_glock"} -- Example: {"weapon_rpg", "weapon_crowbar", "weapon_crossbow"}
NPC.Inherit = "npc_zbase" -- Inherit features from any existing zbase npc

local tab1 = {}
local tab2 = {}
local tab3 = {}

for i=1,4 do
	tab1[#tab1+1] = ")murdered/player/police/shotfired ("..i..").mp3"
end
for i=1,31 do
	tab2[#tab2+1] = ")murdered/player/police/surrender ("..i..").mp3"
end
for i=1,104 do
	tab3[#tab3+1] = ")murdered/player/deathmale/bullet/death_bullet"..i..".ogg"
end

ZBaseCreateVoiceSounds("Police_ShotFired", tab1)
ZBaseCreateVoiceSounds("Police_Surrender", tab2)
ZBaseCreateVoiceSounds("MuR_Male_Died", tab3)