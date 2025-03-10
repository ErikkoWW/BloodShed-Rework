--if engine.ActiveGamemode() != "bloodshed" then return end

hook.Add("InitLoadAnimations", "wOS.DynaBase.MuR", function()
	wOS.DynaBase:RegisterSource({
		Name = "Murdered Anims",
		Type = WOS_DYNABASE.EXTENSION,
		Male = "models/murdered/pm_anims.mdl",
		Female = "models/murdered/pm_anims.mdl",
		Zombie = "models/murdered/pm_anims.mdl",
	})

	hook.Add("PreLoadAnimations", "wOS.DynaBase.MuR", function(gender)
		if gender == WOS_DYNABASE.SHARED then
			IncludeModel("models/murdered/pm_anims.mdl")
		end
	end)
end)