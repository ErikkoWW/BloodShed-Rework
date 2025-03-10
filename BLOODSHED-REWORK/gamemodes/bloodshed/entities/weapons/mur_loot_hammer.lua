AddCSLuaFile()
SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Hammer"
SWEP.Slot = 0
SWEP.WorldModel = "models/murdered/weapons/w_barricadeswep.mdl"
SWEP.ViewModel = "models/murdered/weapons/c_barricadeswep.mdl"
SWEP.WorldModelPosition = Vector(4, -3, 3)
SWEP.WorldModelAngle = Angle(180, 10, 0)
SWEP.ViewModelPos = Vector(0, -1, -1)
SWEP.ViewModelAng = Angle(0, 0, 0)
SWEP.ViewModelFOV = 70
SWEP.HoldType = "melee"

SWEP.MatBlock = {MAT_SAND, MAT_SLOSH, MAT_SNOW,}

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

function SWEP:MakeBolt(ent2)
    local tr = util.QuickTrace(self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector() * 70, {self:GetOwner()})

    local ent = ents.Create("prop_dynamic")
    ent:SetPos(tr.HitPos - self:GetOwner():EyeAngles():Forward() * 4)
    ent:SetModel("models/crossbow_bolt.mdl")
    ent:SetAngles(self:GetOwner():EyeAngles())
    ent:SetParent(ent2)
    ent:Spawn()
    ent2:DeleteOnRemove(ent)
end

if SERVER then
    function SWEP:CustomPrimaryAttack()
        local ply = self:GetOwner()
        local possible, tr1, tr2 = self:FindObjects()

        ply:SetAnimation(PLAYER_ATTACK1)
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

        if possible then
            self:SetNextPrimaryFire(CurTime() + 1)
            local ent1, ent2 = tr1.Entity, tr2.Entity

            if ent1:IsPlayer() or ent2:IsPlayer() then return end -- i wonder if enabling this allows you to nail players, would be funny to see

            if string.match(ent1:GetClass(), "_door") then
                ply:ViewPunch(Angle(5, 0, 0))
                ply:EmitSound("physics/metal/metal_computer_impact_hard" .. math.random(1, 3) .. ".wav")
                ent1:Fire("Lock")
                self:MakeBolt(ent1)
                self:MakeHealth(ent1)
                self:RemoveMe()

                if ent1:GetInternalVariable("m_bLocked") then
                    ent1:SetHealth(ent1:Health() + 50)
                end
            end

            if string.match(ent2:GetClass(), "_door") then
                ply:ViewPunch(Angle(5, 0, 0))
                ply:EmitSound("physics/metal/metal_computer_impact_hard" .. math.random(1, 3) .. ".wav")
                ent2:Fire("Lock")
                self:MakeHealth(ent2)
                self:MakeBolt(ent2)
                self:RemoveMe()

                if ent1:GetInternalVariable("m_bLocked") then
                    ent1:SetHealth(ent1:Health() + 50)
                end
            end

            if string.match(ent1:GetClass(), "prop_physics") or ent2:GetClass() == "func_physbox" then
                constraint.Weld(ent1, ent2, 0, 0)
                ply:ViewPunch(Angle(5, 0, 0))
                ply:EmitSound("physics/metal/metal_computer_impact_hard" .. math.random(1, 3) .. ".wav")
                self:MakeHealth(ent1)
                self:MakeBolt(ent1)
                self:RemoveMe()
            end

            if string.match(ent2:GetClass(), "prop_physics") or ent2:GetClass() == "func_physbox" then
                constraint.Weld(ent2, ent1, 0, 0)
                ply:ViewPunch(Angle(5, 0, 0))
                ply:EmitSound("physics/metal/metal_computer_impact_hard" .. math.random(1, 3) .. ".wav")
                self:MakeHealth(ent2)
                self:MakeBolt(ent2)
                self:RemoveMe()
            end
        end
    end

    --this is what makes the hammer add health to pretty much any props, doors, and moving brushes
    --add a maximum bolt quantity when i can

    function SWEP:MakeHealth(ent)
        local health = math.min(math.Clamp(math.floor(ent:OBBMaxs():Length() * 15), 10, 2500), 1000) --grabs object's length, multiplies it by 15 then clamps it between 10 and 1000. makes it so when it clamps it maxes out at 1000 
        local maxHealth = health + 650

        if not ent:GetNWBool("BreakableThing") then
            ent:SetMaxHealth(health) 
            ent:SetHealth(health)
        else
            ent:SetHealth(math.min(ent:Health() + 30, maxHealth)) --gets health and adds a number (currently 10.), makes it so it everytime its added, it then maxes out at whatever value is maxHealth is set to
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
    draw.SimpleText(MuR.Language["loot_hammer_1"], "MuR_Font1", ScrW() / 2, ScrH() - He(100), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(MuR.Language["loot_hammer_2"] .. self:GetNWFloat("Uses"), "MuR_Font2", ScrW() / 2, ScrH() - He(120), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SWEP:CustomInit()
    self:SetNWFloat("Uses", math.random(4, 6))
end

function SWEP:CustomSecondaryAttack()
end