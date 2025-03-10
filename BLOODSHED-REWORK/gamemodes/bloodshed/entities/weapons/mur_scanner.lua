AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Scanner"
SWEP.Slot = 5

SWEP.WorldModel = "models/murdered/catsenya/props_pocox3nfc/catsenya_pocox3nfc.mdl"
SWEP.ViewModel = "models/weapons/c_bugbait.mdl"

SWEP.WorldModelPosition = Vector(4, -3, 3)
SWEP.WorldModelAngle =  Angle(180, 10, 0)

SWEP.ViewModelPos = Vector(0, -6, -7)
SWEP.ViewModelAng = Angle(0, -10, -45)
SWEP.ViewModelFOV = 70

SWEP.BobScale = 0
SWEP.SwayScale = 0

SWEP.HoldType = "slam"

SWEP.ViewModelBoneMods = {
	["ValveBiped.cube3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.VElements = {	  
	["card"] = { type = "Model", model = "models/murdered/catsenya/props_pocox3nfc/catsenya_pocox3nfc.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 3, 3), angle = Angle(180, 0, 12), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Deploy( wep )
	self:SetHoldType(self.HoldType)
end

function SWEP:CustomPrimaryAttack()

end

function SWEP:CustomSecondaryAttack() 

end

function SWEP:Think()
 
end

function SWEP:GetNearestPlayer()
	local ply, min = nil, math.huge
	for _, pl in ipairs(player.GetAll()) do
		local class = pl:GetNWString("Class", "")
		if pl ~= self.Owner and pl:GetPos():DistToSqr(self.Owner:GetPos()) < min and pl:Alive() and not (class == "Killer" or class == "Traitor" or class == "Maniac" or class == "Shooter" or class == "Terrorist") then
				
			ply = pl
			min = pl:GetPos():DistToSqr(self.Owner:GetPos())
		end
	end
	return ply, math.sqrt(min)
end

function SWEP:DrawHUD()
	if !istable(self.VElements) then return end
	local ent = self.VElements["card"].modelEnt
	if IsValid(ent) then
		local pos = select(1, ent:GetBonePosition(0)):ToScreen()
		local xx = 0
		local yy = -150
		local mm = "???"
		local ply, try = self:GetNearestPlayer()
		local arrow = "[]"
		if IsValid(ply) then
			mm = math.floor(try/25)
			local z = ply:GetPos().z-LocalPlayer():GetPos().z
			if z > 96 then
				arrow = "[↑]"
			elseif z < -96 then
				arrow = "[↓]"
			else
				arrow = "[-]"
			end		  
		end
		if isnumber(mm) and mm >= 200 then
			mm = "???"
		end
	
		draw.SimpleText("Human Detector", "Trebuchet18", pos.x+We(xx), pos.y+He(yy-20), Color(255,255,155), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(mm.." m "..arrow, "Trebuchet24", pos.x+We(xx), pos.y+He(yy), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if isnumber(mm) then
			draw.SimpleText("DETECTED", "DefaultFixed", pos.x+We(xx), pos.y+He(yy+30), Color(155,255,155), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("NOT DETECTED", "DefaultFixed", pos.x+We(xx), pos.y+He(yy+30), Color(255,155,155), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		draw.SimpleText("v1.0.5 [ON]", "Trebuchet18", pos.x+We(xx+12), pos.y+He(yy+200), Color(200,200,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if not self.BeepTime then
			self.BeepTime = CurTime()+1
		end

		if isnumber(mm) and self.BeepTime < CurTime() then
			surface.PlaySound("HL1/fvox/beep.wav")
			self.BeepTime = CurTime()+math.max(mm/40, 0.2)
		end
	end
end

function SWEP:CalcViewModelView(ViewModel, OldEyePos, OldEyeAng, EyePos, EyeAng)
	if IsValid(self:GetOwner()) then
		local iron, irona = self.ViewModelPos, self.ViewModelAng
		local pos = EyePos + (EyeAng:Forward() * -5 + EyeAng:Right() * -7 + EyeAng:Up() * -6)
		EyeAng.z = -45

		return pos, EyeAng
	end
end

function SWEP:OnDrop()
	if self.Called then
		self:Remove()
	end
end