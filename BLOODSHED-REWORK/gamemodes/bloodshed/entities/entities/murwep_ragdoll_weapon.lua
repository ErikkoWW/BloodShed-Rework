AddCSLuaFile()

ENT.Base = "base_anim"
ENT.PrintName = "Weapon"
ENT.Category = "BloodShed"
ENT.Spawnable = true

local DataTable = {
    ["Glock"] = {
        model = "models/weapons/w_pist_p228.mdl",
        offsetpos = Vector(-1,3,-2),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["Seven"] = {
        model = "models/weapons/w_pist_fiveseven.mdl",
        offsetpos = Vector(-1,3,-2),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["Deagle"] = {
        model = "models/weapons/w_357.mdl",
        offsetpos = Vector(-1,3,2),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["P228"] = {
        model = "models/weapons/w_pist_p228.mdl",
        offsetpos = Vector(-1,3,-2),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["USP"] = {
        model = "models/weapons/w_pist_usp.mdl",
        offsetpos = Vector(-1,3,-2),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["Elite"] = {
        model = "models/weapons/w_pist_elite_single.mdl",
        offsetpos = Vector(-1,3,-2),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["USPs"] = {
        model = "models/weapons/w_pist_usp_silencer.mdl",
        offsetpos = Vector(-1,3,-2),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["MAC"] = {
        model = "models/weapons/w_smg_mac10.mdl",
        offsetpos = Vector(-1,3,-2),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },


    ["AK47"] = {
        model = "models/weapons/w_rif_ak47.mdl",
        offsetpos = Vector(-1,12,-3),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["M4A1"] = {
        model = "models/weapons/w_rif_m4a1.mdl",
        offsetpos = Vector(-1,12,-3),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["MP5"] = {
        model = "models/weapons/w_smg_mp5.mdl",
        offsetpos = Vector(-1,7,-3),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["M3"] = {
        model = "models/weapons/w_shot_m3super90.mdl",
        offsetpos = Vector(-1,12,-3),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
        extradelay = 0.7,
    },
    ["AWP"] = {
        model = "models/weapons/w_snip_awp.mdl",
        offsetpos = Vector(-1,12,-3),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
        extradelay = 1.4,
    },
    ["Scout"] = {
        model = "models/weapons/w_snip_scout.mdl",
        offsetpos = Vector(-1,12,-3),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },

    ------------------
--------PISTOLS---------
    ["tt33"] = {
        model = "models/weapons/tacint_shark/w_tt33.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["p210"] = {
        model = "models/weapons/tacint_shark/w_p210.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["makarov"] = {
        model = "models/weapons/tacint/w_makarov.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["ruger"] = {
        model = "models/weapons/tacint_extras/w_ruger.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["ab10"] = {
        model = "models/weapons/tacint_extras/w_ab10.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["fort12"] = {
        model = "models/weapons/tacint_extras/w_fort12.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["woodsman"] = {
        model = "models/weapons/tacint_extras/w_woodsman.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["browninghp"] = {
        model = "models/weapons/tacint_extras/w_browninghp.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["ppk"] = {
        model = "models/weapons/tacint_shark/w_ppk.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["megastar"] = {
        model = "models/weapons/tacint_shark/w_megastar.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["hushpup"] = {
        model = "models/weapons/tacint_shark/w_hushpup.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["p7"] = {
        model = "models/weapons/tacint_shark/w_hkp7.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["jericho"] = {
        model = "models/weapons/tacint_shark/w_jericho.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["p99"] = {
        model = "models/weapons/tacint_shark/w_p99.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["fiveseven"] = {
        model = "models/weapons/tacint_shark/w_57.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["hk45c"] = {
        model = "models/weapons/tacint_extras/w_hk45c.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["p2000"] = {
        model = "models/weapons/tacint/w_p2000.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["usp"] = {
        model = "models/weapons/tacint_extras/w_usp.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["gsr1911"] = {
        model = "models/weapons/tacint/w_gsr1911.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["p250"] = {
        model = "models/weapons/tacint/w_p250.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["vertec"] = {
        model = "models/weapons/tacint/w_vertec.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["m1911"] = {
        model = "models/weapons/tacint_extras/w_m1911.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["glock"] = {
        model = "models/weapons/tacint_extras/w_glock_new.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },


-----------REVOLVERS---------------
    ["mr96"] = {
        model = "models/weapons/tacint/w_mr96.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
   ["python"] = {
        model = "models/weapons/tacint/w_python.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["m500"] = {
        model = "models/weapons/tacint_shark/w_m500.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["m29"] = {
        model = "models/weapons/tacint_shark/w_m29.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["executioner"] = {
        model = "models/weapons/tacint_shark/w_executioner.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["sw686"] = {
        model = "models/weapons/tacint_extras/w_sw686.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["rhino60ds"] = {
        model = "models/weapons/tacint_extras/w_rhino60ds.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["1858"] = {
        model = "models/weapons/tacint_shark/w_1858.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },


------MAGNUMS-------
    ["automag3"] = {
        model = "models/weapons/tacint_extras/w_automag3.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["automag"] = {
        model = "models/weapons/tacint_extras/w_automag.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["degala"] = {
        model = "models/weapons/tacint_extras/w_deagle.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },

---------AKIMBOS--------
--[[
    ["dual_makarov"] = {
        model = "models/weapons/tacint_extras/w_dual_makarov.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["dualies"] = {
        model = "models/weapons/tacint_shark/w_dualies.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["dual_usp"] = {
        model = "models/weapons/tacint_shark/w_dual_usp.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["dual_ppk"] = {
        model = "models/weapons/tacint_shark/w_dual_ppk.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["dual_1911"] = {
        model = "models/weapons/tacint_shark/w_dual_1911.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["dual_satana"] = {
        model = "models/weapons/tacint_shark/w_m29_dual.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["dual_hardballers"] = {
        model = "models/weapons/tacint_shark/w_dual_hardballers.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
    ["dual_degala"] = {
        model = "models/weapons/tacint_shark/w_dual_eagles.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = false,
    },
]]

--------MACHINE PISTOLS-----------
    ["uzi_pro"] = {
        model = "models/weapons/tacint/w_uzi.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["mac10"] = {
        model = "models/weapons/tacint_extras/w_mac10.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["skorpion"] = {
        model = "models/weapons/tacint/w_skorpion.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["sphinx"] = {
        model = "models/weapons/tacint/w_sphinx.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["xd45"] = {
        model = "models/weapons/tacint/w_xd45.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["93r"] = {
        model = "models/weapons/tacint_shark/w_93r.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["ots33"] = {
        model = "models/weapons/tacint_extras/w_ots33.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["glock18"] = {
        model = "models/weapons/tacint_extras/w_glock18.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["mp5k"] = {
        model = "models/weapons/tacint_shark/w_mp5k.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["tec9"] = {
        model = "models/weapons/tacint_extras/w_tec9.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["cz75"] = {
        model = "models/weapons/tacint_extras/w_cz75.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["vp70"] = {
        model = "models/weapons/tacint_extras/w_vp70.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["m712"] = {
        model = "models/weapons/tacint_shark/w_m712.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },
    ["klin"] = {
        model = "models/weapons/tacint/w_klin.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = false,
        automatic = true,
    },

-----------SUBMACHINE GUNS----------
    ["mp9"] = {
        model = "models/weapons/tacint_extras/w_mp9.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["p90"] = {
        model = "models/weapons/tacint/w_p90.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["mp5"] = {
        model = "models/weapons/tacint/w_mp5.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["mp7"] = {
        model = "models/weapons/tacint/w_mp7.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["ump45"] = {
        model = "models/weapons/tacint_extras/w_ump45.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["pdw"] = {
        model = "models/weapons/tacint/w_pdw.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["superv"] = {
        model = "models/weapons/tacint/w_superv.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["scorpionevo"] = {
        model = "models/weapons/tacint_shark/w_evo3.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["mpx"] = {
        model = "models/weapons/tacint_shark/w_mpx.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["ak74u"] = {
        model = "models/weapons/tacint_shark/w_74u.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["mp5sd"] = {
        model = "models/weapons/tacint_shark/w_mp5sd.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["bizon"] = {
        model = "models/weapons/tacint_shark/w_bizon.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["mx4"] = {
        model = "models/weapons/tacint_shark/w_mx4.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["coltsmg"] = {
        model = "models/weapons/tacint_shark/w_coltsmg.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["uzi"] = {
        model = "models/weapons/tacint/w_uzi_b.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["luty"] = {
        model = "models/weapons/tacint_extras/w_luty.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["thompson"] = {
        model = "models/weapons/tacint_shark/w_thompson.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["madsen"] = {
        model = "models/weapons/tacint_extras/w_madsen.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["ppsh"] = {
        model = "models/weapons/tacint_shark/w_ppsh.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["mp40"] = {
        model = "models/weapons/tacint_shark/w_mp40.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    [""] = {
        model = "",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },

---------ASSAULT RIFLES--------
    ["amd65"] = {
        model = "models/weapons/tacint/w_amd65.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["m4a1"] = {
        model = "models/weapons/tacint_extras/w_m4a1.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["k1a"] = {
        model = "models/weapons/tacint/w_k1a.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["m4"] = {
        model = "models/weapons/tacint/w_m4.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["ak47"] = {
        model = "models/weapons/tacint/w_ak47.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["g36"] = {
        model = "models/weapons/tacint/w_g36k.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["sg551"] = {
        model = "models/weapons/tacint/w_sg551.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["aug"] = {
        model = "models/weapons/tacint/w_aug.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["ak74"] = {
        model = "models/weapons/tacint_extras/w_ak47.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["acc_hb"] = {
        model = "models/weapons/tacint_shark/w_aac_hb2.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["ak12"] = {
        model = "models/weapons/tacint_extras/w_ak12.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["an94"] = {
        model = "models/weapons/tacint_shark/w_an94.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["hk416"] = {
        model = "models/weapons/tacint_extras/w_hk416.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["vltor"] = {
        model = "models/weapons/tacint_extras/w_vltor.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["aek971"] = {
        model = "models/weapons/tacint_shark/w_aek.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["val"] = {
        model = "models/weapons/tacint_extras/w_val.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["m16a4"] = {
        model = "models/weapons/tacint_extras/w_m16a4.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["famas_g2"] = {
        model = "models/weapons/tacint_extras/w_famas_g2.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["scar"] = {
        model = "models/weapons/tacint_shark/w_scarl.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["g36c"] = {
        model = "models/weapons/tacint_extras/w_g36c.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["xm8car"] = {
        model = "models/weapons/tacint_shark/w_xm8car.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["masada"] = {
        model = "models/weapons/tacint_shark/w_masada.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["m16a2"] = {
        model = "models/weapons/tacint_extras/w_m16a2.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["m733"] = {
        model = "models/weapons/tacint_shark/w_m733.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["famas"] = {
        model = "models/weapons/tacint_shark/w_famas.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["groza"] = {
        model = "models/weapons/tacint_shark/w_groza.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["rk95"] = {
        model = "models/weapons/tacint_shark/w_rk95.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["auga1"] = {
        model = "models/weapons/tacint_shark/w_auga1.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["ar70"] = {
        model = "models/weapons/tacint_shark/w_ar70.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["f2000"] = {
        model = "models/weapons/tacint_shark/w_f2000.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["fnc"] = {
        model = "models/weapons/tacint_extras/w_fnc.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["lr300"] = {
        model = "models/weapons/tacint_extras/w_lr300.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["m16a1"] = {
        model = "models/weapons/tacint_extras/w_m16a1.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["l85"] = {
        model = "models/weapons/tacint_shark/w_l85.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["stg44"] = {
        model = "models/weapons/tacint_shark/w_stg44.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },

    [""] = {
        model = "",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },

---------BATTLE RIFLES--------
    ["dsa58"] = {
        model = "models/weapons/tacint/w_dsa58.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["hk417"] = {
        model = "models/weapons/tacint/w_hk417.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["mcx"] = {
        model = "models/weapons/tacint_shark/w_mcx.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["scarh"] = {
        model = "models/weapons/tacint_shark/w_scarh.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["g3"] = {
        model = "models/weapons/tacint_shark/w_g3.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["fal"] = {
        model = "models/weapons/tacint_shark/w_stg58.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["howa"] = {
        model = "models/weapons/tacint_shark/w_howa.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["sks"] = {
        model = "models/weapons/tacint_extras/w_sks.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["sg510"] = {
        model = "models/weapons/tacint_shark/w_sg510.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["svt40"] = {
        model = "models/weapons/tacint/w_svt40.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },

-------MACHINE GUNS--------
    ["mg4"] = {
        model = "models/weapons/tacint/w_mg4.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["hk23e"] = {
        model = "models/weapons/tacint_shark/w_hk23e_beta10.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["xm8lmg"] = {
        model = "models/weapons/tacint_extras/w_xm8lmg.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    }, 
    ["pkm"] = {
        model = "models/weapons/tacint_shark/w_pkm.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["fnmag"] = {
        model = "models/weapons/tacint/w_fnmag.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["mg42"] = {
        model = "models/weapons/tacint_shark/w_mg42.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["rpk"] = {
        model = "models/weapons/tacint_shark/w_rpk.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["galil_lmg"] = {
        model = "models/weapons/tacint_extras/w_galil_lmg.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["m60"] = {
        model = "models/weapons/tacint_shark/w_m60.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },
    ["lewis"] = {
        model = "models/weapons/tacint/w_lewis.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = true,
    },

------SHOTGUNS---------
    ["fp6"] = {
        model = "models/weapons/tacint/w_fp6.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["ks23"] = {
        model = "models/weapons/tacint/w_ks23.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["bekas"] = {
        model = "models/weapons/tacint/w_bekas.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["tgs12"] = {
        model = "models/weapons/tacint/w_tgs12.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["m4star10"] = {
        model = "models/weapons/tacint/w_m4star10.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["spas12"] = {
        model = "models/weapons/tacint_shark/w_spas12.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["hkcaws"] = {
        model = "models/weapons/tacint_shark/w_hkcaws.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["ksg12"] = {
        model = "models/weapons/tacint_shark/w_ksg12.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["m3"] = {
        model = "models/weapons/tacint_extras/w_m3.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["saiga"] = {
        model = "models/weapons/tacint_shark/w_saiga.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["spas15"] = {
        model = "models/weapons/tacint_shark/w_spas15.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["jackhammer"] = {
        model = "models/weapons/tacint_shark/w_jackhammer.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["870"] = {
        model = "models/weapons/tacint_shark/w_870.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["ithaca"] = {
        model = "models/weapons/tacint_shark/w_ithaca.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["shorty"] = {
        model = "models/weapons/tacint/w_shorty.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["db"] = {
        model = "models/weapons/tacint_shark/w_dbshotgun.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["toz34"] = {
        model = "models/weapons/tacint/w_toz34.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["superx3"] = {
        model = "models/weapons/tacint_shark/w_superx3.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["auto5"] = {
        model = "models/weapons/tacint/w_auto5.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["coachgun"] = {
        model = "models/weapons/tacint_extras/w_coachgun.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["toz106"] = {
        model = "models/weapons/tacint/w_toz106.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },


------SPORTERS---------
    ["p90c"] = {
        model = "models/weapons/tacint/w_p90.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["mp5c"] = {
        model = "models/weapons/tacint/w_mp5.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["m1"] = {
        model = "models/weapons/tacint/w_m1.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["acr"] = {
        model = "models/weapons/tacint_shark/w_masada.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["sg550r"] = {
        model = "models/weapons/tacint_shark/w_sg550_rifle.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["delisle"] = {
        model = "models/weapons/tacint_shark/w_delisle.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["gilboa"] = {
        model = "models/weapons/tacint_extras/w_gilboa.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["nitrorifle"] = {
        model = "models/weapons/tacint_shark/w_nitrorifle.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["sl8"] = {
        model = "models/weapons/tacint_extras/w_sl8.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["usc"] = {
        model = "models/weapons/tacint_extras/w_usc.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["star15"] = {
        model = "models/weapons/tacint_extras/w_star15.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["scout"] = {
        model = "models/weapons/tacint_extras/w_scout.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["cx4"] = {
        model = "models/weapons/tacint_shark/w_cx4.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["izzyfal"] = {
        model = "models/weapons/tacint_shark/w_izzyfal.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["vz58"] = {
        model = "models/weapons/tacint_shark/w_vz58.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["varmint"] = {
        model = "models/weapons/tacint_extras/w_k98_varmint.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["hipoint"] = {
        model = "models/weapons/tacint/w_hipoint.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["m1carbine"] = {
        model = "models/weapons/tacint_shark/w_m1carbine.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },

    ["1022"] = {
        model = "models/weapons/tacint_shark/w_1022.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },

    ["winchester"] = {
        model = "models/weapons/tacint_shark/w_winchester.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },

--------MARKSMAN RIFLES----------
    ["m14"] = {
        model = "models/weapons/tacint/w_m14.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },

    ["sr25"] = {
        model = "models/weapons/tacint_extras/w_sr25.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["sg550"] = {
        model = "models/weapons/tacint_shark/w_sg550_sniper.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["psg1"] = {
        model = "models/weapons/tacint_shark/w_psg1.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["m14"] = {
        model = "models/weapons/tacint_extras/w_m14.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["vss"] = {
        model = "models/weapons/tacint_extras/w_vss.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["galil_sniper"] = {
        model = "models/weapons/tacint_extras/w_galil_sniper.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["k98"] = {
        model = "models/weapons/tacint_extras/w_k98.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["smle"] = {
        model = "models/weapons/tacint_extras/w_smle.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["mosin"] = {
        model = "models/weapons/tacint_extras/w_mosin.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },

---------SNIPER RIFLES----------
["spr"] = {
    model = "models/weapons/tacint/w_spr.mdl",
    offsetpos = Vector(-1,3,1),
    offsetang = Angle(0,0,180),
    twohand = true,
    automatic = false,
},
["hecate"] = {
    model = "models/weapons/tacint_extras/w_hecate.mdl",
    offsetpos = Vector(-1,3,1),
    offsetang = Angle(0,0,180),
    twohand = true,
    automatic = false,
},
    ["uratio"] = {
        model = "models/weapons/tacint/w_uratio.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["as50"] = {
        model = "models/weapons/tacint/w_as50.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["awp"] = {
        model = "models/weapons/tacint_shark/w_awp.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["intervention"] = {
        model = "models/weapons/tacint_shark/w_intervention.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["wa2000"] = {
        model = "models/weapons/tacint_shark/w_wa2000.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["trg42"] = {
        model = "models/weapons/tacint_extras/w_trg42.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["vykhlop"] = {
        model = "models/weapons/tacint/w_vykhlop.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["svu"] = {
        model = "models/weapons/tacint_extras/w_svu.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },
    ["svd"] = {
        model = "models/weapons/tacint_extras/w_svd.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },

    ["sako85"] = {
        model = "models/weapons/tacint_extras/w_sako85.mdl",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },

    [""] = {
        model = "",
        offsetpos = Vector(-1,3,1),
        offsetang = Angle(0,0,180),
        twohand = true,
        automatic = false,
    },

---------

}

if SERVER then
    function ENT:ConnectHands(ent, wep)
        local eang = ent.Owner:EyeAngles()
        local bonerh1 = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_R_Hand")))
        local bonelh1 = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_L_Hand")))

        local angle = ent.Owner:GetAimVector():Angle() + Angle(0, 0, 0)
        bonelh1:SetAngles(angle)
        angle = ent.Owner:GetAimVector():Angle() + Angle(0, 0, 180)
        bonerh1:SetAngles(angle)

        ---------------------

        local boner = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_R_Hand")))
        local pos, ang = boner:GetPos(), boner:GetAngles()

        ang = ang+self.data.offsetang
        boner:SetPos(pos)
        ang:RotateAroundAxis(ang:Right(), self.data.offsetpos.x)
        ang:RotateAroundAxis(ang:Up(), self.data.offsetpos.y)
        ang:RotateAroundAxis(ang:Forward(), self.data.offsetpos.z)
        pos = pos + self.data.offsetpos.x * ang:Right()
        pos = pos + self.data.offsetpos.y * ang:Forward()
        pos = pos + self.data.offsetpos.z * ang:Up()
    
        self:SetPos(pos)
        self:SetAngles(ang)

        constraint.Weld(self, ent, 0, ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_R_Hand")), 0, true, false)
        if self.data.twohand then
            local vec1 = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone( "ValveBiped.Bip01_R_Hand" ))):GetPos()
            local vec22 = Vector(0,0,0)
            vec22:Set(Vector(10,-3,0))
            vec22:Rotate(ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone( "ValveBiped.Bip01_R_Hand" ))):GetAngles())
            ent:GetPhysicsObjectNum( ent:TranslateBoneToPhysBone(ent:LookupBone( "ValveBiped.Bip01_L_Hand" )) ):SetPos(vec1+vec22)
            ent:GetPhysicsObjectNum( ent:TranslateBoneToPhysBone(ent:LookupBone( "ValveBiped.Bip01_L_Hand" )) ):SetAngles(ent:GetPhysicsObjectNum( 7 ):GetAngles()-Angle(0,0,180))
            if !IsValid(ent.WepCons2) then
                local cons2 = constraint.Weld(self,ent,0,ent:TranslateBoneToPhysBone(ent:LookupBone( "ValveBiped.Bip01_L_Hand" )),0,true)
                if IsValid(cons2) then
                    ent.WepCons2 = cons2
                end
            end
        end
    end

    function ENT:Initialize()
        if not self.type then
            self.type = "Glock"
        end
        self.data = DataTable[self.type]
        self:SetModel(self.data.model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self.twohand = self.data.twohand
        self.clip = 0
        self.shooted = false
        self.shootedtime = CurTime()
        local phys = self:GetPhysicsObject()
        phys:SetMass(1)

        local ent, wep = self.Owner, self.Weapon
        if !IsValid(ent) or !IsValid(wep) or !istable(self.data) or false then
            self:Remove()
        else
            self:ConnectHands(ent, wep)

            ent:DeleteOnRemove(self)

            self.clip = wep:Clip1()
            self.shootsound = wep.ShootSound
        end
    end

    function ENT:Think()
        local ent, wep = self.Owner, self.Weapon
        if !IsValid(ent) or !IsValid(wep) or IsValid(ent.Owner) and !ent.Owner:HasWeapon(wep:GetClass()) then
            self:Remove()
        else
            if ent:GetManipulateBoneScale(ent:LookupBone("ValveBiped.Bip01_R_Hand")):Length() < 1 then
                ent.Weapon = nil 
                self:Remove()
                return
            else
                local bone1 = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_R_Hand")))
                if IsValid(self:GetPhysicsObject()) then
                    self:GetPhysicsObject():SetVelocity(bone1:GetVelocity())
                end
            end
        end
    end

    function ENT:Reload()
        local rag, wep = self.Owner, self.Weapon
        if IsValid(rag) and IsValid(wep) and wep:Clip1() < wep:GetMaxClip1() and rag.Owner:GetAmmoCount(wep:GetPrimaryAmmoType()) > 0 and self.shootedtime < CurTime() then
            local ent = rag.Owner

            local maxclip = wep:GetMaxClip1()
            local clip = wep:Clip1()
            local ammo = ent:GetAmmoCount(wep:GetPrimaryAmmoType())
            local needed = maxclip - clip
            local toload = math.min(ammo, needed)

            wep:SetClip1(clip + toload)
            ent:RemoveAmmo(toload, wep:GetPrimaryAmmoType())

            self.shootedtime = CurTime()+2
            local count = 0
            --[[local tab = wep.Animations["reload"]
            if istable(tab) and istable(tab.EventTable) then
                for k, v in pairs(tab.EventTable) do
                    count = count + 1
                    timer.Simple(v.t, function()
                        if !IsValid(ent) or !IsValid(self) then return end
                        rag:EmitSound(v.s, 60)
                        rag:FireHand(true)
                    end)
                    self.shootedtime = CurTime()+v.t+1
                end
            end]]--
            if count == 0 then
                local tab = {
                    {
                        t = 0.3,
                        s = "murdered/weapons/m9/handling/m9_magout.wav",
                    },
                    {
                        t = 1.3,
                        s = "murdered/weapons/m9/handling/m9_magin.wav",
                    },
                    {
                        t = 1.8,
                        s = "murdered/weapons/m9/handling/m9_maghit.wav",
                    },
                }
                for k, v in pairs(tab) do
                    timer.Simple(v.t, function()
                        if !IsValid(ent) or !IsValid(self) then return end
                        rag:EmitSound(v.s, 60)
                        rag:FireHand(true)
                    end)
                    self.shootedtime = CurTime()+v.t+1
                end
            end
        end
    end
    
    function ENT:Shoot(bool)
        local ent, wep = self.Owner, self.Weapon
        if bool then
            if wep:Clip1() > 0 then
                if self.shootedtime > CurTime() or !self.data.automatic and self.shooted or self:LookupAttachment('muzzle_flash') < 1 then return end
                
                local att = self:GetAttachment(self:LookupAttachment('muzzle_flash'))
                local spr = wep.Spread
                if wep.Num > 1 then
                    spr = spr/2
                end
                local data = {
                    Attacker = ent,
                    Damage = wep.Damage_Max*2,
                    Dir = att.Ang:Forward(),
                    Src = att.Pos-att.Ang:Forward()*4,
                    Force = 1,
                    Tracer = 1,
                    AmmoType = wep.Ammo,
                    Num = wep.Num,
                    Spread = Vector( 1*spr, 1*spr, 1*spr ),
                    IgnoreEntity = ent,
                }
                self:FireBullets(data)
                wep:SetClip1(wep:Clip1()-1)
                self.shooted = true
                self.shootedtime = CurTime()+(60/wep.RPM)+(self.data.extradelay or 0)
                ent:EmitSound(isstring(wep.Sound_Shoot) and wep.Sound_Shoot or istable(wep.Sound_Shoot) and table.Random(wep.Sound_Shoot), wep.Vol_Shoot, math.random(100-wep.ShootPitchVariance,100+wep.ShootPitchVariance), 1, CHAN_WEAPON)
                ent:FireHand()
                if wep:Clip1() == 0 then
                    self.shooted = false
                end

                local effectdata = EffectData()
                effectdata:SetOrigin(att.Pos)
                effectdata:SetAngles(att.Ang)
                effectdata:SetScale( 1 )
                util.Effect("MuzzleEffect", effectdata)
            else
                if self.shooted then return end

                self.shooted = true
                self.shootedtime = CurTime()+(60/wep.RPM)
                ent:EmitSound("weapons/pistol/pistol_empty.wav", 60)
            end
        else
            self.shooted = false
        end
    end
end