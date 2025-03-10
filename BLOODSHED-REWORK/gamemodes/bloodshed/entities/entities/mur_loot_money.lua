AddCSLuaFile()

ENT.Base = "base_anim"
ENT.PrintName = "Flashlight" 
ENT.Category = "BloodShed"
ENT.Spawnable = true
ENT.IsLoot = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props/cs_assault/Money.mdl")
        self:SetUseType(SIMPLE_USE)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetCollisionGroup(1)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end
    end
    
    function ENT:Use(ply)
        if ply:IsBot() then
            self:Remove()
        end
        
        ply:EmitSound("physics/cardboard/cardboard_box_impact_soft"..math.random(1,7)..".wav")
        ply:AddMoney(100)
        self:Remove()
    end
end