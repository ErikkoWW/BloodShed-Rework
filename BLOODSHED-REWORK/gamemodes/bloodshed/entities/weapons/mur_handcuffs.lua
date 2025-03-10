AddCSLuaFile()

SWEP.Base = "mur_loot_base"
SWEP.PrintName = "Handcuffs"
SWEP.Slot = 0

SWEP.WorldModel = "models/murdered/handcuffs/handcuffs.mdl"
SWEP.ViewModel = "models/murdered/handcuffs/c_hand_cuffs.mdl"

SWEP.WorldModelPosition = Vector(4, -2, 0)
SWEP.WorldModelAngle =  Angle(0, 0, 90)

SWEP.ViewModelPos = Vector(0, -1, -2)
SWEP.ViewModelAng = Angle(0, 0, 5)
SWEP.ViewModelFOV = 80

SWEP.HoldType = "slam"

function SWEP:Deploy( wep )
    self:SendWeaponAnim(ACT_VM_DRAW)
    self:SetHoldType(self.HoldType)
end

function SWEP:CustomPrimaryAttack()
    local ow = self:GetOwner()

    if SERVER then
        local tr = util.TraceLine({
            start = ow:GetShootPos(),
            endpos = ow:GetShootPos() + ow:GetAimVector() * 64,
            filter = ow,
            mask = MASK_SHOT_HULL
        })

        local i = 0
        local tar = tr.Entity
        if IsValid(tar) and (tar:IsPlayer() and ow:IsAtBack(tar) or tar.isRDRag and IsValid(tar.Owner)) then
            local target = tar
            if tar.isRDRag then
                target = tar.Owner
            end
            target:StopRagdolling()
            target:SetPos(ow:GetPos())
            target:SetEyeAngles(ow:EyeAngles())
            local id = math.random(1,6)
            local anim = "sequence_ron_arrest_start_player_0" .. id
            local _, dur = ow:LookupSequence(anim)
            timer.Simple(0.001, function()
                if not IsValid(target) then return end
                target:Surrender(true, true, id, dur)
            end)
            ow:EmitSound("murdered/other/arrest_body.mp3", 60)
            ow:ViewPunch(Angle(5,0,0))
            ow:Freeze(true)
            ow:SetNotSolid(true)
            local vm = ow:GetViewModel()
            vm:SendViewModelMatchingSequence(vm:LookupSequence("deploy"))
            timer.Simple(2, function()
                if not IsValid(self) or not IsValid(self:GetOwner()) then return end
                vm:SendViewModelMatchingSequence(vm:LookupSequence("idle01"))
            end)

            ow:SetSVAnimation(anim, true)
            timer.Simple(dur, function()
                if not IsValid(ow) then return end
                ow:Freeze(false)
                ow:SetNotSolid(false)
            end)
        end

        self:SetNextPrimaryFire(CurTime() + 2)
    end
end

function SWEP:CustomSecondaryAttack()

end

function SWEP:CustomInit()

end