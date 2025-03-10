AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_junk/flare.mdl")
	self:SetMoveType( MOVETYPE_NONE )
	self:SetUseType(SIMPLE_USE)
	self:SetAngles(self:GetAngles()+Angle(90,math.random(0,360),0))
	self:SetSolid(SOLID_VPHYSICS)
	timer.Simple(0.01, function()
		if !IsValid(self) then return end
		self:SetPos(self:GetPos()-Vector(0,0,5))
	end)
end

function ENT:Think()
	local part = EffectData()
	part:SetStart( self:GetPos() )
	part:SetOrigin( self:GetPos() )
	part:SetEntity( self )
	part:SetScale( 1 )
	util.Effect("mur_exfil_flare", part)

    self:NextThink(CurTime()+0.05)
    return true
end

function ENT:OnRemove()
	MuR:ExfilPlayers(self:GetPos(), 200)
end