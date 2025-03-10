local NPC = FindZBaseTable(debug.getinfo(1, 'S'))

-- The NPC class
-- Can be any existing NPC in the game
-- If you want to make a human that can use weapons, you should probably use "npc_combine_s" or "npc_citizen" for example
-- Use "npc_zbase_snpc" if you want to create a brand new SNPC
NPC.Class = "npc_combine_s"

NPC.Name = "SWAT" -- Name of your NPC
NPC.Category = "Bloodshed" -- Category in the ZBase tab
NPC.Weapons = {"mur_npc_m4a1"} -- Example: {"weapon_rpg", "weapon_crowbar", "weapon_crossbow"}
NPC.Inherit = "mur_npc_police" -- Inherit features from any existing zbase npc