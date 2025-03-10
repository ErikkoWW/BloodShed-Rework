AddCSLuaFile()
SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Duct Tape"
SWEP.Slot = 0
SWEP.WorldModel = "models/murdered/props_tape/duct_tape.mdl"
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModelPosition = Vector(4, -3, 3)
SWEP.WorldModelAngle = Angle(180, 10, 0)
SWEP.ViewModelPos = Vector(3, 0, 2.96)
SWEP.ViewModelAng = Angle(0, 0, 20)
SWEP.ViewModelFOV = 70
SWEP.HoldType = "slam"

SWEP.MatBlock = {MAT_SAND, MAT_SLOSH, MAT_SNOW,}

SWEP.ViewModelBoneMods = {
    ["Detonator"] = {
        scale = Vector(0.009, 0.009, 0.009),
        pos = Vector(0, 0, 0),
        angle = Angle(0, 0, 0)
    },
    ["ValveBiped.Bip01_L_Clavicle"] = {
        scale = Vector(1, 1, 1),
        pos = Vector(-18, 0, 0),
        angle = Angle(0, 0, 0)
    },
    ["Slam_base"] = {
        scale = Vector(0.009, 0.009, 0.009),
        pos = Vector(0, 0, 0),
        angle = Angle(0, 0, 0)
    }
}

SWEP.VElements = {
    ["ducttape"] = {
        type = "Model",
        model = "models/murdered/props_tape/duct_tape.mdl",
        bone = "Slam_base",
        rel = "",
        pos = Vector(-2.187, -61.993, 21.827),
        angle = Angle(59.319, 0, 42.2),
        size = Vector(0.707, 0.707, 0.707),
        color = Color(255, 255, 255, 255),
        surpresslightning = false,
        material = "",
        skin = 0,
        bodygroup = {}
    }
}

function SWEP:Deploy(wep)
    self:SetHoldType(self.HoldType)
end

function SWEP:FindObjects()
    local pos, vec = self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector()
    local gotOne, tries = false, 0
    local trOne, trTwo = nil, nil

    while not gotOne and tries < 100 do
        local tr = util.QuickTrace(pos, vec * 64 + VectorRand() * 2, {self:GetOwner()})

        if tr.Hit and not tr.HitSky and not table.HasValue(self.MatBlock, tr.MatType) then
            gotOne = true
            trOne = tr
        end

        tries = tries + 1
    end

    if gotOne then
        gotOne = false
        tries = 0

        while not gotOne and tries < 100 do
            local tr = util.QuickTrace(pos, vec * 64 + VectorRand() * 2, {self:GetOwner()})

            if tr.Hit and not tr.HitSky and not table.HasValue(self.MatBlock, tr.MatType) and not (tr.Entity == trOne.Entity) then
                gotOne = true
                trTwo = tr
            end

            tries = tries + 1
        end
    end

    if trOne and trTwo then
        return true, trOne, trTwo
    else
        return false, nil, nil
    end
end

function SWEP:SprayDecals()
    local Tr1 = util.QuickTrace(self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector() * 70, {self:GetOwner()})

    util.Decal("mur_ducttape", Tr1.HitPos + Tr1.HitNormal, Tr1.HitPos - Tr1.HitNormal)

    local Tr2 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(0, 0, .15)) * 70, {self:GetOwner()})

    util.Decal("mur_ducttape", Tr2.HitPos + Tr2.HitNormal, Tr2.HitPos - Tr2.HitNormal)

    local Tr3 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(0, 0, -.15)) * 70, {self:GetOwner()})

    util.Decal("mur_ducttape", Tr3.HitPos + Tr3.HitNormal, Tr3.HitPos - Tr3.HitNormal)

    local Tr4 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(0, .15, 0)) * 70, {self:GetOwner()})

    util.Decal("mur_ducttape", Tr4.HitPos + Tr4.HitNormal, Tr4.HitPos - Tr4.HitNormal)

    local Tr5 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(0, -.15, 0)) * 70, {self:GetOwner()})

    util.Decal("mur_ducttape", Tr5.HitPos + Tr5.HitNormal, Tr5.HitPos - Tr5.HitNormal)

    local Tr6 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(.15, 0, 0)) * 70, {self:GetOwner()})

    util.Decal("mur_ducttape", Tr6.HitPos + Tr6.HitNormal, Tr6.HitPos - Tr6.HitNormal)

    local Tr7 = util.QuickTrace(self:GetOwner():GetShootPos(), (self:GetOwner():GetAimVector() + Vector(-.15, 0, 0)) * 70, {self:GetOwner()})

    util.Decal("mur_ducttape", Tr7.HitPos + Tr7.HitNormal, Tr7.HitPos - Tr7.HitNormal)
end

if SERVER then
    function SWEP:CustomPrimaryAttack()
        local ply = self:GetOwner()
        local possible, tr1, tr2 = self:FindObjects()

        if possible then
            self:SetNextPrimaryFire(CurTime() + 1)
            local ent1, ent2 = tr1.Entity, tr2.Entity

            if ent1:IsPlayer() or ent2:IsPlayer() then return end

            if string.match(ent1:GetClass(), "_door") then
                ply:ViewPunch(Angle(5, 0, 0))
                ply:EmitSound("murdered/other/ducttape.mp3")
                ent1:Fire("Lock")
                self:SprayDecals()
                self:RemoveMe()
                self:MakeHealth(ent1)
            end

            if string.match(ent2:GetClass(), "_door") then
                ply:ViewPunch(Angle(5, 0, 0))
                ply:EmitSound("murdered/other/ducttape.mp3")
                ent2:Fire("Lock")
                self:SprayDecals()
                self:RemoveMe()
                self:MakeHealth(ent2)
            end

            if string.match(ent1:GetClass(), "prop_physics") or ent2:GetClass() == "func_physbox" then
                constraint.Weld(ent1, ent2, 0, 0)
                ply:ViewPunch(Angle(5, 0, 0))
                ply:EmitSound("murdered/other/ducttape.mp3")
                self:MakeHealth(ent1)
                self:SprayDecals()
                self:RemoveMe()
            end

            if string.match(ent2:GetClass(), "prop_physics") or ent2:GetClass() == "func_physbox" then
                constraint.Weld(ent2, ent1, 0, 0)
                ply:ViewPunch(Angle(5, 0, 0))
                ply:EmitSound("murdered/other/ducttape.mp3")
                self:MakeHealth(ent2)
                self:SprayDecals()
                self:RemoveMe()
            end
        end
    end

    function SWEP:MakeHealth(ent)
        local health = math.min(math.Clamp(math.floor(ent:OBBMaxs():Length() * 10), 10, 2500), 1000) --makes it so when it clamps it maxes out at 1000
        local maxHealth = health + 500

        if not ent:GetNWBool("BreakableThing") then
            ent:SetNWBool("BreakableThing", true)
            ent:SetMaxHealth(health)
            ent:SetHealth(health)
        else
            ent:SetHealth(math.min(ent:Health() + 15, maxHealth)) --gets health and adds a number (currently 10.), makes it so it everytime its added, it then maxes out at whatever value is maxHealth is set to
        end
    end

    function SWEP:RemoveMe()
        local fl = self:GetNWFloat("Uses")

        if fl > 1 then
            self:SetNWFloat("Uses", fl - 1)
        else
            self:Remove()
        end
    end
end

function SWEP:DrawHUD()
    local ply = self:GetOwner()
    draw.SimpleText(MuR.Language["loot_tape_1"], "MuR_Font1", ScrW() / 2, ScrH() - He(100), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(MuR.Language["loot_tape_2"], "MuR_Font1", ScrW() / 2, ScrH() - He(85), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(MuR.Language["loot_tape_3"] .. self:GetNWFloat("Uses"), "MuR_Font2", ScrW() / 2, ScrH() - He(120), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SWEP:CustomInit()
    self:SetNWFloat("Uses", math.random(1, 3))
end

function SWEP:CustomSecondaryAttack()
    local ow = self:GetOwner()
    if ow:GetNWFloat("BleedLevel") <= 0 and ow:Health() >= 100 then return end
    ow:EmitSound("murdered/other/ducttape.mp3")

    if SERVER then
        MuR:GiveMessage("ducttape_use", ow)
        ow:DamagePlayerSystem("blood", true)
        ow:SetHealth(math.Clamp(ow:Health() + 10, 1, 100))
        self:Remove()
    end
end
