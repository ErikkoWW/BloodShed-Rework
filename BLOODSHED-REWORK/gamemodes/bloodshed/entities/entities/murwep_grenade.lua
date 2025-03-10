AddCSLuaFile()

ENT.Base = "base_anim"
ENT.PrintName = "Grenade"

game.AddParticles("particles/ac_explosions.pcf")

if SERVER then
    function ENT:Initialize()
        if self.F1 then
            self:SetModel("models/murdered/weapons/insurgency/w_f1.mdl")
        else
            self:SetModel("models/murdered/weapons/insurgency/w_m67.mdl")
        end
        self:PhysicsInit(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
        end
        self.Activated = false
        self.IsZBaseGrenade = true

        if !IsValid(self.OwnerTrap) then
            timer.Simple(4, function()
                if !IsValid(self) then return end
                self:Explode()
            end)
        else
            if IsValid(phys) then
                phys:Sleep()
                phys:EnableMotion(false)
            end
            self:SetCollisionGroup(1)
        end
    end

    function ENT:Think()
        if IsValid(self.OwnerTrap) and not self.Activated then
            local tab = ents.FindInSphere(self:GetPos(), 32)
            for i=1,#tab do
                local ply = tab[i]
                if !IsValid(self.OwnerTrap) or (!ply:IsNPC() and !ply:IsPlayer()) or !ply:Visible(self) or ply == self.OwnerTrap or ply:Health() <= 0 or ply:IsKiller() and self.OwnerTrap:IsKiller() then continue end
                self:ActivateGrenade()
            end
        end
    end

    function ENT:PhysicsCollide(data, phys)
        if data.Speed > 50 then
            self:EmitSound(")murdered/weapons/grenade/m67_bounce_01.wav", 60, math.random(80,120))
            sound.EmitHint(SOUND_DANGER, self:GetPos(), 400, 1, self)
        end
    end

    function ENT:OnTakeDamage(dmg)
        if self.Activated then return end
        if dmg:GetDamage() > 5 then
            self:Explode()
        end
    end

    function ENT:ActivateGrenade()
        if self.Activated then return end
        self.Activated = true
        self:EmitSound(")murdered/weapons/grenade/f1_pinpull.wav", 60, math.random(80,120)) 
        timer.Simple(0.5, function()
            if !IsValid(self) then return end
            self:Explode()
        end)
    end
    
    function ENT:Explode()
        self.Activated = true
        local num = 1
        if self.SuperGrenade then
            num = math.random(10,100)
        end
        for i=1, num do
            timer.Simple(i/10, function()
                if !IsValid(self) then return end
                self:EmitSound(")murdered/weapons/grenade/m67_explode.wav", 120, math.random(80,120))
                util.ScreenShake(self:GetPos(), 25, 25, 3, 2000)
                ParticleEffect("AC_grenade_explosion", self:GetPos(), Angle(0,0,0))
                ParticleEffect("AC_grenade_explosion_air", self:GetPos(), Angle(0,0,0))
                util.Decal("Scorch", self:GetPos(), self:GetPos()-Vector(0,0,8), self)

                for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 128)) do
                    if string.match(ent:GetClass(), "_door") then
                        ent:TakeDamage(500)
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
                if i == num then
                    self:Remove()
                end
            end)
        end
    end
end