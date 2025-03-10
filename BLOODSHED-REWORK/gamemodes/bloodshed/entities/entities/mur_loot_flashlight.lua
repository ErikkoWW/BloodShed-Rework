AddCSLuaFile()

ENT.Base = "base_anim"
ENT.PrintName = "Flashlight" 
ENT.Category = "BloodShed"
ENT.Spawnable = true
ENT.IsLoot = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/maxofs2d/lamp_flashlight.mdl")
        self:SetUseType(SIMPLE_USE)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetModelScale(0.5, 0)
        self:SetCollisionGroup(2)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end
    end
    
    function ENT:Use(ply)
        if ply:IsBot() then
            ply:EmitSound("physics/cardboard/cardboard_box_impact_soft"..math.random(1,7)..".wav")
            self:Remove()
        end

        if ply:CanUseFlashlight() then return end
        
        ply:EmitSound("physics/cardboard/cardboard_box_impact_soft"..math.random(1,7)..".wav")
        ply:AllowFlashlight(true)
        self:Remove()
    end
end