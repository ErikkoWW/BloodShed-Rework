local meta = FindMetaTable("Player")

function meta:MakeBloodEffect(bone, delay, times)
	if not bone then return end
	if not delay then delay = 0 end
	if not times then times = 1 end
	local tar = self
	if IsValid(self:GetRD()) then
		tar = self:GetRD()
	end
	local name = bone .. "Hit" .. self:EntIndex()
	timer.Create(name, delay, times, function()
		if !IsValid(tar) or tar:IsPlayer() and !tar:Alive() then
			timer.Remove(name)
			return
		end
		local pos = MuR:BoneData(tar, bone)
		local ef = EffectData()
		ef:SetEntity(tar)
		ef:SetOrigin(pos)
		ef:SetColor(0)
		util.Effect("BloodImpact", ef)
		if math.random(1,4) == 1 then
			local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(VectorRand(-1,1))
			effectdata:SetMagnitude(1)
			effectdata:SetRadius(math.random(8,32))
			effectdata:SetEntity(self)
			util.Effect("mur_blood_splatter_effect", effectdata, true, true )
		end
		if math.random(1,4) == 1 then
			MuR:CreateBloodPool(tar, tar:LookupBone(bone), 1)
			tar:EmitSound("murdered/player/drip_" .. math.random(1, 5) .. ".wav", 40, math.random(80, 120))
		end
	end)
end

hook.Add("EntityTakeDamage", "MuR_DamageSystem", function(ent, dmg)
	if ent.Owner then
		ent = ent.Owner
	end

	if ent:IsPlayer() then
		local bone1 = ent:GetNearestBoneFromPos(dmg:GetDamagePosition(), dmg:GetDamageForce())

		if IsValid(ent:GetRD()) then
			bone1 = ent:GetRD():GetNearestBoneFromPos(dmg:GetDamagePosition(), dmg:GetDamageForce())
		end

		local buldmg = dmg:IsBulletDamage()
		local dm = dmg:GetDamage()
		local kndmg = dmg:GetDamageType() == DMG_SLASH

		if (buldmg or kndmg) and bone1 == "ValveBiped.Bip01_Head1" and math.random(1,4) == 1 then
			MuR:GiveMessage2("neck_hit", ent)
			ent:DamagePlayerSystem("hard_blood")
			ent:MakeBloodEffect("ValveBiped.Bip01_Neck1", 0.2, 100)
		end

		if (buldmg or kndmg) and (bone1 == "ValveBiped.Bip01_Spine"or bone1 == "ValveBiped.Bip01_Spine2") and math.random(1, 5) == 1 then
			if math.random(1, 10) == 1 then
				MuR:GiveMessage2("heart_hit", ent)
				ent:DamagePlayerSystem("hard_blood")
				ent:MakeBloodEffect("ValveBiped.Bip01_Spine4", 0.4, 30)
			elseif math.random(1, 8) == 1 then
				MuR:GiveMessage2("lung_hit", ent)
				ent:DamagePlayerSystem("hard_blood")
				ent:MakeBloodEffect("ValveBiped.Bip01_Spine4", 0.4, 30)
			else
				MuR:GiveMessage2("down_hit", ent)
				ent:MakeBloodEffect("ValveBiped.Bip01_Spine2", 0.8, 15)
				for i = 1, math.random(2,3) do
					ent:DamagePlayerSystem("blood")
				end
			end
		end

		if (bone1 == "ValveBiped.Bip01_R_Forearm" or bone1 == "ValveBiped.Bip01_L_Forearm") and math.random(1, 2) == 1 and IsValid(ent:GetActiveWeapon()) and not ent:GetActiveWeapon().NeverDrop and dm > 10 then
			MuR:GiveMessage2("arm_hit", ent)
			ent:DropWeapon(ent:GetActiveWeapon())
		end

		if (bone1 == "ValveBiped.Bip01_L_Calf" or bone1 == "ValveBiped.Bip01_R_Calf") and math.random(1, 2) == 1 and dm > 10 then
			MuR:GiveMessage2("leg_hit", ent)
			ent:DamagePlayerSystem("bone")
		end
	end
end)