local LANG = {
	_LANG_NAME = "English",
	_LANG_OWNNAME = "English",

	["plylist"] = "Player List",
	["blackmarket"] = "Black Market",
	["milequipment"] = "Military Equipment",
	["shop"] = "Shop",
	["buy"] = "BUY",
	["open"] = "OPEN",
	["select"] = "Select",
	["innocentswin"] = "The murderer is no longer a threat.",
	["traitorwin"] = "The civilians were caught up in a terrible catastrophe.",
	["yousurvived"] = "You've survived this difficult day. We can only hope for the future...",
	["youjailed"] = "Surrendering and going to jail is better than getting shot in the head.",
	["youdied"] = "Unfortunately, the day turned tragic for you...",
	["roundended"] = "Round is over!",
	["peoplelist"] = "People List:",
	["holdalt"] = "Press ALT to turn on the mouse",
	["help"] = "Help",
	["gamesettings"] = "Game Settings",
	["guilt:"] = "Guilt: ",
	["guiltwarning"] = "Your guilt has reached a high point. Further violations will result in a ban.",
	["ruarmedforcesintelligence"] = "RAF Intelligence | ",
	["ukarmedforcesintelligence"] = "UAF Intelligence | ",
	["enemythere"] = "The enemy may be positioned here.",
	["fullmag+"] = "Full magazine + 1",
	["fullmag"] = "Full magazine",
	["almostfullmag"] = "Almost full",
	["halfmag"] = "About half",
	["almostemptymag"] = "Almost empty",
	["emptymag"] = "Empty",
	["use"] = "Use",
	["durability"] = "Durability",
	["hungersmall"] = "You are hungry",
	["hungermedium"] = "You feel very hungry",
	["hungermax"] = "You are exhausted from hunger",
	["smallbleed"] = "You're bleeding weakly",
	["mediumbleed"] = "Moderate bleeding",
	["highbleed"] = "Heavy bleeding",
	["criticalbleed"] = "Critical bleeding",
	["legbroken"] = "Fracture",
	["policearecoming"] = "Police on the move",
	["policearehere"] = "Police have arrived",
	["swatarecoming"] = "SWAT on the move",
	["swatarehere"] = "SWAT has arrived",
	["policeassault"] = "POLICE ASSAULT IN PROGRESS",
	["policeassault1"] = "Police reinforcment on the move",
	["policeassault2"] = "Police is starting an assault",
	["evac1"] = "Exfil on the move",
	["evac2"] = "Exfil end after:",
	["evac_zone"] = "You are in an evacuation zone, do not move away to escape.",
	["spectating:"] = "Spectating:",
	["controls"] = "Controls",
	["waitingplayers"] = "Waiting for players",
	["announce_traitor"] = "You have become a traitor, kill everyone as soon as possible.",
	["announce_defender"] = "You have become a defender, eliminate the traitor as soon as possible.",
	["announce_zombie"] = "You've become a zombie, now infect all humans.",
	["announce_innokill"] = "You have killed an innocent person, such actions result in character debuffs and a ban if you have killed many people.",
	["announce_attkill"] = "You killed an innocent person, but because they attacked people, there will be no guilt.",
	["announce_moneycancel"] = "Because of the high guilt, you cant buy items.",
	["announce_spawndamage"] = "You deal damage to players even though not even a minute has passed since the start of the round.",
	["announce_officerspawn"] = "You have become a police officer, locate and arrest a suspect.",
	["announce_arrested"] = "You have been arrested, you can no longer resist and play, but your guilt has been reduced.",
	["announce_officerguilt"] = "Your guilt has been increased for killing a player instead of attempting to arrest him.",
	["message_ragalive"] = "This person is still alive.",
	["message_ragdead"] = "This man died of his injuries.",
	["message_bandageuse"] = "You wrapped the wounds in bandages.",
	["message_medkituse"] = "You used a first aid kit on your injuries.",
	["message_adrenalineuse"] = "You injected adrenaline and feel a surge of energy.",
	["message_heroinuse"] = "You injected heroin and are feeling the effects of the drug.",
	["message_tapeuse"] = "You taped up your wounds, better than nothing.",
	["message_targetbandageuse"] = "You wrapped a bandage around the person across the hall.",
	["message_targetmedkituse"] = "You used a first aid kit on the injuries of the man across the hall.",
	["message_targetadrenalineuse"] = "You injected adrenaline into the person across the hall.",
	["message_targetheroinuse"] = "You injected heroin into the person across the hall.",
	["message_targetcyanideuse"] = "You injected cyanide into the person opposite, the poison will take effect soon.",
	["message_poisonuse"] = "You have poisoned an object, if someone picks it up, the poison will take effect.",
	["message_weaponbreak"] = "Your weapon has broken.",
	["neck_hit"] = "You have been hit in the neck and are bleeding heavily.",
	["lung_hit"] = "You have been hit in the lungs, they are starting to fill with blood.",
	["heart_hit"] = "You have been hit in the heart and are bleeding heavily.",
	["leg_hit"] = "You were hit in the leg and suffered a fracture.",
	["arm_hit"] = "You were hit in the hand, the weapon dropped spontaneously.",
	["down_hit"] = "You have been hit in the abdomen and are bleeding heavily.",
	["teammate"] = "Teammate",

	["use_1"] = "Surrender to the police",
	["use_2"] = "Fall to ragdoll",
	["use_3"] = "Say",
	["use_4"] = "Commit suicide",
	["use_5"] = "Drop weapon",
	["use_6"] = "Unload weapon",

	["gamename1"] = "Default Scenario",
	["gamedesc1"] = "Come and fight off the killer in your party.",
	["gamename2"] = "Active Shooter",
	["gamedesc2"] = "There has been an active shooter on your property, please keep your distance and wait for special forces.",
	["gamename3"] = "Serial Killer",
	["gamedesc3"] = "The maniac is on the hunt. Fight back and expect the police.",
	["gamename4"] = "State of Emergency",
	["gamedesc4"] = "Come and fight back the traitor in your party.",
	["gamename5"] = "Deathmatch",
	["gamedesc5"] = "Shoot all living objects, repeat shoot all living objects.",
	["gamename6"] = "Infection",
	["gamedesc6"] = "Shoot all the zombies and don't let yourself and your comrades get infected.",
	["gamename7"] = "Wild West",
	["gamedesc7"] = "Every citizen carries a gun. Fight back the killer.",
	["gamename8"] = "Active Resistance",
	["gamedesc8"] = "The traitors are uniting, there are two of them to be on the lookout for now!",
	["gamename9"] = "Unknown Attack",
	["gamedesc9"] = "We don't know who the killer is and who will keep track of it. We need time...",
	["gamename10"] = "Terrorist Attack",
	["gamedesc10"] = "A terrorist has been spotted in the area. Expect special forces or fight back.",
	["gamename11"] = "Riot",
	["gamedesc11"] = "Extremists are breaking everything they can, the police urgently need to take action.",
	["gamename12"] = "Special Forces vs Terrorists",
	["gamedesc12"] = "Shoot all enemy objects, do not touch your comrades.",
	["gamename13"] = "Medieval",
	["gamedesc13"] = "A fight between two Factions, who will rise and be the winner?",
	["gamename14"] = "Special Military Operation",
	["gamedesc14"] = "Eliminate the enemy group.",

	["civilian"] = "Civilian",
	["murderer"] = "Killer",
	["traitor"] = "Traitor",
	["maniac"] = "Maniac",
	["rioter"] = "Extremist",
	["riotpolice"] = "Riot Police",
	["terrorist"] = "Terrorist",
	["shooter"] = "Shooter",
	["zombie"] = "Infected",
	["defender"] = "Defender",
	["medic"] = "Paramedic",
	["builder"] = "Builder",
	["soldier"] = "Soldier",
	["officer"] = "Police Officer",
	["fbiagent"] = "FBI Agent",
	["swat"] = "Special Forces",
	["m_faction"] = "Good Forces",
	["k_faction"] = "Evil Forces",
	["war_rus"] = "Unit |-15-| of The Russian Federation",
	["war_ukr"] = "Unit |-58-| of Ukrain",
	["war_rus2"] = "Russian Soldier",
	["war_ukr2"] = "Ukrainian Soldier",
    
	["murderer_desc"] = "You are a murderer, kill all the people in the locations and don't get caught by the police.",
	["rioter_desc"] = "You are an extremist, you stand up to the authorities, do not let them surround you.",
	["traitor_desc"] = "You are a traitor, you have good equipment, kill all the people in the locations and not get caught by the police.",
	["zombie_desc"] = "You are an infected, you have more health and fast running, infect everyone in the locations.",
	["maniac_desc"] = "You are a maniac, kill all the people in the locations and don't get caught by the police.",
	["shooter_desc"] = "You are a shooter, kill all the people in the locations and fight back the police.",
	["terrorist_desc"] = "You are a terrorist, kill all the people in the locations and destroy everything you can.",
	["terrorist_desc2"] = "You are a a terrorist, have excellent weapons to destroy enemy targets.",
	["civilian_desc"] = "You are a citizen, be aware of the killer in your group.",
	["officer_desc"] = "You are a police officer, you have a taser with which you can arrest a person, be careful.",
	["fbiagent_desc"] = "You are an FBI agent, you don't have a uniform, so go undercover, you have a disguise and handcuffs.",
	["riotpolice_desc"] = "You are a riot police, you have excellent weapons for suppressing riots.",
	["swat_desc"] = "You are special forces, you have excellent weapons to destroy enemy targets.",
	["defender_desc"] = "You are a citizen, you have a firearm, eliminate the killer and do not threaten to use ordinary people.",
	["defender_var_light"] = "with a pistol",
	["defender_var_heavy"] = "with a heavy weapon",
	["medic_desc"] = "You are a paramedic, you are given a first aid kit, treat wounded people.",
	["builder_desc"] = "You are a builder, you have been given the tools to build barricades.",
	["soldier_desc"] = "You are a soldier, you have been given excellent weapons to withstand a huge crowd.",
	["m_faction_desc"] = "Fight for your people's honor and lead them to victory!",
	["k_faction_desc"] = "Destroy your Enemy and make them regret coming!",
	["war_rus_desc"] = "You are a soldier of the Armed Forces of the Russian Federation, you are given excellent weapons to repel enemy attacks.",
	["war_ukr_desc"] = "You are a soldier of the Armed Forces of Ukrain, you are given excellent weapons to repel enemy attacks.",

	["startscreen_gamemode"] = "",
	["startscreen_role"] = "Your role: ",

	["spectate_1"] = "Controls",
	["spectate_2"] = " - Free/attached camera",
	["spectate_3"] = " - Change of players",
	["spectate_4"] = " - Third/first person",

	["second"] = "sec.",
	["strength"] = "Strength: ",
	["stability"] = "Sanity: ",
	["stability_message"] = "If you don't kill people, you will go crazy.",
	["kill_them"] = "Kill Them",

	["ragdoll_heavy"] = "You are too seriously injured to stand up.",
	["ragdoll_getup"] = "You can get up after ",
	["ragdoll_getup2"] = " to get up",
	["ragdoll_cant"] = "Something is stopping you from getting up",
	["ragdoll_pull"] = " to pull hands",
	["ragdoll_grab"] = " to grab with your hands",
	["ragdoll_jump"] = " to jump",
	["ragdoll_stand"] = " to stand",
	["ragdoll_hold"] = "Hold ",
	["ragdoll_press"] = "Press ",
	["ragdoll_use"] = " - Interaction",
	["ragdoll_wep1"] = " to shoot",
	["ragdoll_wep2"] = " to reload",
	["ragdoll_wep3"] = " to use",

	["loot_medic_left"] = "LMB - Use on self",
	["loot_medic_right"] = "RMB - Use on the person in front of you",
	["loot_hammer_1"] = "LMB - Pin the prop [You must look at the edge of the object]",
	["loot_hammer_2"] = "Nails left: ",
	["loot_tape_1"] = "LMB - Wrap with tape [You must look at the edge of the object]",
	["loot_tape_2"] = "RMB - Tape wounds",
	["loot_tape_3"] = "Uses left: ",
	["loot_grenade_1"] = "LMB - Throw a grenade",
	["loot_grenade_2"] = "RMB - Place a trap",
	["loot_ied_1"] = "LMB - Place explosive",
	["loot_ied_2"] = "RMB - Activate detonator",
	["loot_ied_3"] = "R - Attach explosives [Must look at object]",
	["loot_cyanide"] = "LMB - Inject a syringe with poison",
	["loot_poison"] = "LMB - Poison an object [You must look at the object]",
	["loot_disguise_1"] = "Click on the LMB and look at the corpse to change appearance.",
	["loot_disguise_2"] = "(You cannot disguise yourself as a different gender)",
	["loot_dis"] = "Click on the LMB and look at a phone or firearm to break it and make it explode when used.",

	["dialogue_menu"] = "Character voicelines",
	["dialogue_menu1"] = "Ask a question",
	["dialogue_menu2"] = "Answer question",
	["dialogue_menu3"] = "Call for help",
	["dialogue_menu4"] = "Get hellout",
	["dialogue_menu5"] = "Panic",
	["dialogue_menu6"] = "Cops",
	["dialogue_menu7"] = "We trusted you",
	["dialogue_menu8"] = "Sorry",
	["dialogue_menu9"] = "Joy",
	["dialogue_menu10"] = "Turn around",
	["dialogue_menu11"] = "Oops",
	["dialogue_menu12"] = "Let's go",
	["dialogue_menu13"] = "I'm injured",
	["dialogue_menu14"] = "Hello",

	["log_vote"] = "Click the button to vote for the obituary to be shown",
	["log_vote_info"] = "Voted for the show: ",
	["log_vote_button"] = "Vote",
	["log_start_text"] = "The shadows of the past do not let us go. Time has passed since that terrible incident, but its echo can still be heard. Every rustle, every whisper in the night reminds of that terrible night. The police conducted an exhaustive investigation, every stone was turned over, every piece of evidence has been examined. Forensic experts, working day and night, have uncovered the grim details of that night. They have reconstructed a picture of events that makes the blood run cold. Now that we know the names of the victims and the circumstances of their deaths, it is time to face the horror .Get ready to see what has been hidden until now... Something that has left a deep mark on the history of our city. These are not just names on a list, these are lives that were cruelly interrupted. Their stories, their dreams, their hopes and fears... All it was destroyed on that terrible night. But we will not forget. We will not let this be forgotten. We will remember every sacrifice, every life lost. And we will remember so that this never happens again.",
	["log_dead_players"] = "List of dead persons at the crime scene",
	["log_dead_cops_players"] = "List of dead officers who gave their lives to save citizens",
	["log_hdead_players"] = "List of deaths in the intensive care unit",
	["log_injured_players"] = "List of people admitted to the hospital",
	["log_end_text"] = "Now that we have remembered together those we have lost, our hearts are filled with sorrow, but also with hope. We mourn the losses, the lives that were so cruelly taken away. But at the same time we find hope - hope that awareness of this tragedy will help us prevent similar things in the future. Let this memory be a reminder to us of the value of life and how important it is to appreciate every moment. Remember: it is not how our life ends that matters, but how how we live it.",
	["log_reason_unknown"] = "Unknown injury",
	["log_reason_explosion"] = "Explosion",
	["log_reason_bullet"] = "Bullet wound",
	["log_reason_slash"] = "Stab wound",
	["log_reason_club"] = "Bruised wound",
	["log_reason_toxic"] = "Poisoning",
	["log_reason_fall"] = "Multiple fractures",
	["log_data_name"] = "Name: ",
	["log_data_reason_d"] = "Cause of death: ",
	["log_data_reason_p"] = "Reason of injury: ",
	["log_data_unknow"] = "Innocent",
	["log_data_know"] = "Suspect",
}

return LANG