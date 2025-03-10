local NPC = FindZBaseTable(debug.getinfo(1,'S'))

NPC.Models = {"models/murdered/npc/swat.mdl"}
NPC.WeaponProficiency = WEAPON_PROFICIENCY_VERY_GOOD
NPC.StartHealth = 150

NPC.MeleeAttackAnimations = {"melee_gunhit"} -- Example: NPC.MeleeAttackAnimations = {ACT_MELEE_ATTACK1}
NPC.MeleeAttackAnimationSpeed = 1.2 -- Speed multiplier for the melee attack animation
NPC.MeleeDamage_Delay = 0.4 -- Time until the damage strikes, set to false to disable the timer (if you want to use animation events instead for example)