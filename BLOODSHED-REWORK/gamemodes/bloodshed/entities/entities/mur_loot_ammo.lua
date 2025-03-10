AddCSLuaFile()

ENT.Base = "base_anim"
ENT.PrintName = "Flashlight" 
ENT.Category = "BloodShed"
ENT.Spawnable = true
ENT.IsLoot = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/Items/BoxSRounds.mdl")
        self:SetUseType(SIMPLE_USE)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetCollisionGroup(2)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end
    end
    
    function ENT:Use(ply)
        local wep = ply:GetActiveWeapon()
        
        if IsValid(wep) and wep:GetMaxClip1() > 0 then
            ply:EmitSound("physics/cardboard/cardboard_box_impact_soft"..math.random(1,7)..".wav")
            ply:GiveAmmo(wep:GetMaxClip1(), wep:GetPrimaryAmmoType(), true)
            self:Remove()
        end

        if ply:IsBot() then
            ply:EmitSound("physics/cardboard/cardboard_box_impact_soft"..math.random(1,7)..".wav")
            self:Remove()
        end
    end
end