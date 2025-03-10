AddCSLuaFile()

ENT.Base = "base_anim"
ENT.PrintName = "IED"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/murdered/weapons/insurgency/w_ied.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(true)
        end
        self:SetCollisionGroup(1)
        self.ExplosionDamageMult = 1
        self.IsZBaseGrenade = true
    end

    function ENT:PhysicsCollide(data, col)
        if self.Connected then return end
        self.Connected = true

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Sleep()
            phys:EnableMotion(false)
        end

        if game.GetWorld() != data.HitEntity then
            self:SetParent(data.HitEntity)
        end
        self:SetAngles(data.HitNormal:Angle()+Angle(0,270,0))
    end

    function ENT:OnTakeDamage(dmg)
        if self.Activated then return end
        if dmg:GetDamage() > 5 then
            self:Explode()
        end
    end

    function ENT:Think()
        local par = self:GetParent()
        if IsValid(par) and par:IsWeapon() and IsValid(par:GetOwner()) then
            self:Explode()
        end
    end
    
    function ENT:Explode()
        self.Activated = true
        self.Connected = true
        self:EmitSound(")murdered/weapons/grenade/m67_explode.wav", 120, math.random(70,85))
        util.ScreenShake(self:GetPos(), 50, 25, 4, 2500)

        ParticleEffect("AC_rpg_explosion", self:GetPos(), Angle(0,0,0))
        ParticleEffect("AC_rpg_explosion_air", self:GetPos(), Angle(0,0,0))

        for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 128)) do
            if string.match(ent:GetClass(), "_door") then
                ent:TakeDamage(5000)
            end
        end

        local att = self
        if IsValid(self.PlayerOwner) then
            att = self.PlayerOwner
        end
        if self.F1 then
            util.BlastDamage(att, att, self:GetPos(), 400, 200)
        else
            util.BlastDamage(att, att, self:GetPos(), 300, 250)
        end

        util.Decal("Scorch", self:GetPos(), self:GetPos()-Vector(0,0,8), self)
        util.BlastDamage(att, att, self:GetPos(), 250*(self.ExplosionDamageMult*2), 1000*self.ExplosionDamageMult)
        self:Remove()
    end
end