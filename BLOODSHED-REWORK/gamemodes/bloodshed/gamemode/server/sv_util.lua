local meta = FindMetaTable("Entity")
util.AddNetworkString("MuR.EntityPlayerColor")

function meta:MakePlayerColor(col)
	timer.Simple(0.1, function()
		if not IsValid(self) then return end
		net.Start("MuR.EntityPlayerColor")
		net.WriteEntity(self)
		net.WriteVector(col)
		net.Broadcast()
	end)
end

-------------------------------------------------------

function MuR:CreateBloodPool(rag, boneid, flags, needvel)
	if not IsValid(rag) then return end
	local boneid = boneid or 0
	local flags = flags or 0
	local color = BLOOD_COLOR_RED
	local needvel = needvel or 0
	local effectdata = EffectData()
	effectdata:SetEntity(rag)
	effectdata:SetAttachment(boneid)
	effectdata:SetFlags(flags)
	effectdata:SetRadius(needvel)
	util.Effect("bloodshed_blood_pool", effectdata, true, true)
end

-------------------------------------------------------
--[[
local DMGINFO = FindMetaTable("CTakeDamageInfo")
DamageInfoMetaCopy = DamageInfoMetaCopy or table.Copy(DMGINFO)
DamageInfoCopies = DamageInfoCopies or {}
IsDamageInfoCopy = IsDamageInfoCopy or {}

function DMGINFO:IsValid()
	return tostring(self)!="CTakeDamageInfo [NULL]"
end

for funcname, val in pairs(DamageInfoMetaCopy) do
	if string.StartsWith(funcname, "__") then continue end
	if isfunction(val) then
		DMGINFO[funcname] = function(self, ...)
			if !IsValid(self) or self.Health and self:Health() <= 0 then return end
			
			if !IsDamageInfoCopy[self] then
				DamageInfoCopies[self] = DamageInfoCopies[self] or DamageInfo()
				IsDamageInfoCopy[ DamageInfoCopies[self] ] = true
				if string.StartsWith(funcname, "Set") and funcname and self then
					DamageInfoCopies[self][funcname]( DamageInfoCopies[self], ... )
				end
			end

			if self:IsValid() then
				return val(self, ...)	  
			elseif DamageInfoCopies[self] && DamageInfoCopies[self]:IsValid() then
				return val(DamageInfoCopies[self], ...)
			end
		end
	end
end

timer.Create("FixDMGInfoSave", 5, 0, function()
	table.Empty(DamageInfoCopies)
	table.Empty(IsDamageInfoCopy)
end)	
]]--
-------------------------------------------------------

player_manager.AddValidModel("Jason", "models/murdered/pm/mkx_jason.mdl")
player_manager.AddValidHands("Jason", "models/murdered/pm/mkx_jason_hands.mdl", 0, "00000000")
player_manager.AddValidModel("British Police", "models/murdered/pm/british_cop_pm.mdl")
player_manager.AddValidHands("British Police", "models/weapons/c_arms_british_cop/c_arms_british_cop.mdl", 0, "00000000")
player_manager.AddValidModel("SWAT", "models/murdered/pm/swat_kl.mdl")
player_manager.AddValidHands("SWAT", "models/murdered/pm/swat_arms.mdl", 0, "00000000")