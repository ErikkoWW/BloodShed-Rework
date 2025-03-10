AddCSLuaFile()

ENT.Base = "base_anim"
ENT.PrintName = "Weapon" 
ENT.Category = "BloodShed"
ENT.Spawnable = true

local DataTable = {
    ["Bandage"] = {
        model = "models/murdered/bandage/bandage.mdl",
        offsetpos = Vector(-4,0,0),
        offsetang = Angle(90,90,0),
        twohand = false,
        func = function(self, ent, ply)
            if !IsValid(ent) or !IsValid(ply) then return end
            if ply:GetNWFloat('BleedLevel') <= 0 and ply:Health() >= 100 then return end

            self.used = true
            ent:EmitSound("murdered/medicals/bandage.wav")
            MuR:GiveMessage("bandage_use", ply)
            ply:SetHealth(math.Clamp(ply:Health()+20, 1, 100))
            ply:StripWeapon("mur_loot_bandage")
            for i=1,2 do
                ply:DamagePlayerSystem("blood", true)
            end
            self:Remove()
        end
    },
    ["Medkit"] = {
        model = "models/murdered/medkit/items/healthkit.mdl",
        offsetpos = Vector(-1,3,-2),
        offsetang = Angle(0,0,180),
        twohand = false,
        func = function(self, ent, ply)
            if !IsValid(ent) or !IsValid(ply) then return end
            if ply:GetNWFloat('BleedLevel') <= 0 and not ply:GetNWBool('LegBroken') and ply:Health() >= 100 then return end

            self.used = true
            ent:EmitSound("murdered/medicals/medkit.wav")
            MuR:GiveMessage("medkit_use", ply)
            for i=1,3 do
                ply:DamagePlayerSystem("blood", true)
            end
            ply:SetHealth(math.Clamp(ply:Health()+40, 1, 100))
            ply:DamagePlayerSystem("bone", true)
            ply:StripWeapon("mur_loot_medkit")
            self:Remove()
        end
    },

    ["F1"] = {
        model = "models/murdered/weapons/insurgency/w_f1.mdl",
        offsetpos = Vector(-1,3,-2),
        offsetang = Angle(0,0,180),
        twohand = false,
        func = function(self, ent, ply)
            if !IsValid(ent) or !IsValid(ply) then return end

            self.used = true
            ent:EmitSound("murdered/weapons/grenade/f1_pinpull.wav", 60, math.random(90,110))
            ply:ViewPunch(Angle(-5,-5,0))
            timer.Simple(0.6, function()
                if not IsValid(self) or not IsValid(ent) then return end
                ent:EmitSound("murdered/weapons/universal/uni_ads_in_0" .. math.random(2, 6) .. ".wav", 60, math.random(90, 110))
            end)
            timer.Simple(1.1, function()
                if not IsValid(self) or not IsValid(ent) then return end
                local g = ents.Create("murwep_grenade")
                g:SetPos(self:GetPos() + ply:GetAimVector() * 4)
                g.PlayerOwner = ply
                g.F1 = true
                g:Spawn()
                g:GetPhysicsObject():SetVelocity(ply:GetAimVector() * (ply:KeyDown(IN_ATTACK2) and 1024 or 256))
                ply:ViewPunch(Angle(10, 0, 0))
                ply:StripWeapon("mur_f1")
                self:Remove()
            end)
        end
    },
    ["M67"] = {
        model = "models/murdered/weapons/insurgency/w_m67.mdl",
        offsetpos = Vector(-1,3,-2),
        offsetang = Angle(0,0,180),
        twohand = false,
        func = function(self, ent, ply)
            if !IsValid(ent) or !IsValid(ply) then return end

            self.used = true
            ent:EmitSound("murdered/weapons/grenade/f1_pinpull.wav", 60, math.random(90,110))
            ply:ViewPunch(Angle(-5,-5,0))
            timer.Simple(0.6, function()
                if not IsValid(self) or not IsValid(ent) then return end
                ent:EmitSound("murdered/weapons/universal/uni_ads_in_0" .. math.random(2, 6) .. ".wav", 60, math.random(90, 110))
            end)
            timer.Simple(1.1, function()
                if not IsValid(self) or not IsValid(ent) then return end
                local g = ents.Create("murwep_grenade")
                g:SetPos(self:GetPos() + ply:GetAimVector() * 4)
                g.PlayerOwner = ply
                g:Spawn()
                g:GetPhysicsObject():SetVelocity(ply:GetAimVector() * (ply:KeyDown(IN_ATTACK2) and 1024 or 256))
                ply:ViewPunch(Angle(10, 0, 0))
                ply:StripWeapon("mur_m67")
                self:Remove()
            end)
        end
    },
}

if SERVER then
    function ENT:ConnectHands(ent, wep)
        local eang = ent.Owner:EyeAngles()
        local bonerh1 = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_R_Hand")))
        local bonelh1 = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_L_Hand")))

        local angle = ent.Owner:GetAimVector():Angle() + Angle(0, 0, 0)
        bonelh1:SetAngles(angle)
        angle = ent.Owner:GetAimVector():Angle() + Angle(0, 0, 180)
        bonerh1:SetAngles(angle)

        ---------------------

        local boner = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_R_Hand")))
        local pos, ang = boner:GetPos(), boner:GetAngles()

        ang = ang+self.data.offsetang
        boner:SetPos(pos)
        ang:RotateAroundAxis(ang:Right(), self.data.offsetpos.x)
        ang:RotateAroundAxis(ang:Up(), self.data.offsetpos.y)
        ang:RotateAroundAxis(ang:Forward(), self.data.offsetpos.z)
        pos = pos + self.data.offsetpos.x * ang:Right()
        pos = pos + self.data.offsetpos.y * ang:Forward()
        pos = pos + self.data.offsetpos.z * ang:Up()
    
        self:SetPos(pos)
        self:SetAngles(ang)

        constraint.Weld(self, ent, 0, ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_R_Hand")), 0, true, false)
        if self.data.twohand then
            local vec1 = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone( "ValveBiped.Bip01_R_Hand" ))):GetPos()
            local vec22 = Vector(0,0,0)
            vec22:Set(Vector(10,-4,0))
            vec22:Rotate(ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone( "ValveBiped.Bip01_R_Hand" ))):GetAngles())
            ent:GetPhysicsObjectNum( ent:TranslateBoneToPhysBone(ent:LookupBone( "ValveBiped.Bip01_L_Hand" )) ):SetPos(vec1+vec22)
            ent:GetPhysicsObjectNum( ent:TranslateBoneToPhysBone(ent:LookupBone( "ValveBiped.Bip01_L_Hand" )) ):SetAngles(ent:GetPhysicsObjectNum( 7 ):GetAngles()-Angle(0,0,180))
            if !IsValid(ent.WepCons2) then
                local cons2 = constraint.Weld(self,ent,0,ent:TranslateBoneToPhysBone(ent:LookupBone( "ValveBiped.Bip01_L_Hand" )),0,true)
                if IsValid(cons2) then
                    ent.WepCons2 = cons2
                end
            end
        end
    end

    function ENT:Initialize()
        if not self.type then
            self.type = "Bandage"
        end
        self:SetNWBool('IsItem', true)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        self.data = DataTable[self.type]
        self:SetModel(self.data.model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self.twohand = self.data.twohand
        self.clip = 0
        self.used = false
        local phys = self:GetPhysicsObject()
        phys:SetMass(1)

        local ent, wep = self.Owner, self.Weapon
        if !IsValid(ent) or !IsValid(wep) or !istable(self.data) or false then
            self:Remove()
        else
            self:ConnectHands(ent, wep)
            ent:DeleteOnRemove(self)
        end
    end

    function ENT:Think()
        local ent, wep = self.Owner, self.Weapon
        if !IsValid(ent) or !IsValid(wep) or IsValid(ent.Owner) and !ent.Owner:HasWeapon(wep:GetClass()) then
            self:Remove()
        else
            if !IsValid(ent.Owner) then return end
            if ent:GetManipulateBoneScale(ent:LookupBone("ValveBiped.Bip01_R_Hand")):Length() < 1 then
                ent.Weapon = nil 
                self:Remove()
                return
            else
                local bone1 = ent:GetPhysicsObjectNum(ent:TranslateBoneToPhysBone(ent:LookupBone("ValveBiped.Bip01_R_Hand")))
                self:GetPhysicsObject():SetVelocity(bone1:GetVelocity())
            end
        end
    end

    function ENT:Shoot(bool)
        if not bool or self.used or !IsValid(self.Owner) or !IsValid(self.Owner.Owner) then return end
        self.data.func(self, self.Owner, self.Owner.Owner)
    end
    function ENT:Reload() end
else

end