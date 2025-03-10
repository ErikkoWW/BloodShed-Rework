AddCSLuaFile()

SWEP.Base					= "weapon_base"
SWEP.DisableSuicide = true
SWEP.DrawWeaponInfoBox = false

SWEP.PrintName				= "Molotov"	

SWEP.Spawnable				= true
SWEP.AdminOnly				= false

SWEP.Slot					= 4
SWEP.SlotPos				= 1
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.ViewModel 				= "models/murdered/weapons/c_molly.mdl"
SWEP.WorldModel 			= "models/murdered/weapons/w_molly.mdl"
SWEP.ViewModelFOV			= 50
SWEP.ViewModelFlip			= false
SWEP.UseHands 				= true
		
SWEP.DrawAmmo				= true

SWEP.HoldType				= "grenade"

SWEP.Primary.Delay			= 0.75
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ShowViewModel 			= true
SWEP.ShowWorldModel 		= true

SWEP.Throwing 				= false
SWEP.StartThrow 			= false
SWEP.ResetThrow 			= false
SWEP.ThrowVel 				= 1750
SWEP.TossVel				= 500
SWEP.NextThrow 				= CurTime()
SWEP.NextAnimation 			= CurTime()

local ClassName 			= SWEP.ClassName

if CLIENT then
	language.Add("molotov_ammo", "Molotovs")
end

game.AddAmmoType({
	name 		= "molotov",
	dmgtype 	= DMG_BURN,
	tracer 		= TRACER_NONE,
	plydmg 		= 20,
	npcdmg 		= 5,
	force 		= 0,
	minsplash 	= 10,
	maxsplash 	= 10,
	maxcarry 	= 8
})

game.AddParticles("particles/nmrih_gasoline_edit.pcf")

PrecacheParticleSystem("nmrih_molotov_rag_fire")
PrecacheParticleSystem("nmrih_molotov_explosion")
PrecacheParticleSystem("nmrih_molotov_explosion_nofire")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:Deploy()
end

function SWEP:Deploy()

	self.StartThrow = false
	self.Throwing = false
	self.ResetThrow = false

	if not self.Throwing then

		if IsValid(self.Weapon) and IsValid(self.Owner) and self.Owner:IsPlayer() then
			self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
			if IsValid(self.Owner:GetViewModel()) then
				self.Owner:GetViewModel():SetPlaybackRate(2.5)
				self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() / 2.5)
				self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() / 2.5)
			end
		end
		
	end

	if CLIENT and IsValid(self.Owner) and self.Owner:IsPlayer() and IsValid(self.Weapon) then

		if self.Owner:IsPlayer() and IsValid(self.Owner:GetViewModel()) and IsValid(GetViewEntity()) and (self.Owner == GetViewEntity()) then
			ParticleEffectAttach("nmrih_molotov_rag_fire", PATTACH_POINT_FOLLOW, self.Owner:GetViewModel(), self.Owner:GetViewModel():LookupAttachment("Wick"))
		else
			ParticleEffectAttach("nmrih_molotov_rag_fire", PATTACH_POINT_FOLLOW, self.Weapon, self.Weapon:LookupAttachment("Wick"))
		end

	end

	if game.SinglePlayer() then
		self:CallOnClient("Deploy")
	end

	return true	
	
end

function SWEP:Holster()

	self.StartThrow = false
	self.Throwing = false
	self.ResetThrow = false
	self.Tossed = false

	self.Weapon:StopParticles()

	if game.SinglePlayer() then
		self:CallOnClient("Holster")
	end

	return true

end

function SWEP:Think()

	if not IsValid(self.Owner) or not IsValid(self.Weapon) then return end
	
	if not self.Throwing and not self.StartThrow and self.Owner:KeyDown(IN_ATTACK) and self.NextThrow < CurTime() then
		self.StartThrow = true
		self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
		if IsValid(self.Owner:GetViewModel()) then
			self.NextThrow = CurTime() + self.Owner:GetViewModel():SequenceDuration()
			self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
			self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
		end
	end
	
	if self.StartThrow and not self.Owner:KeyDown(IN_ATTACK) and not self.Owner:KeyDown(IN_ATTACK2) and self.NextThrow < CurTime() then
	
		self.StartThrow = false
		self.Throwing = true
		
		if self.Tossed then
			self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		else
			self.Weapon:SendWeaponAnim(ACT_VM_THROW)
		end

		if SERVER then
			self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav",60,math.random(80,90))
		end
		
		self.Owner:SetAnimation(PLAYER_ATTACK1)


		if SERVER then

			local ent = ents.Create("rj_molotov")
			if not ent then return end
			ent.Owner = self.Owner
			ent.Inflictor = self.Weapon
			ent:SetOwner(self.Owner)
			local eyeang = self.Owner:GetAimVector():Angle()
			local right = eyeang:Right()
			local up = eyeang:Up()

			if self.Tossed then
				ent:SetPos(self.Owner:GetShootPos() + right * 6 + up * -6)
				ent:SetAngles(self.Owner:GetAngles() + Angle(0,-90,0))
				ent.Vel = self.TossVel / 2
			else
				ent:SetPos(self.Owner:GetShootPos() + right * 6 + up * -2)
				ent:SetAngles(self.Owner:GetAngles() + Angle(-90,0,0))
				ent.Vel = self.ThrowVel / 2
			end

			ent:SetPhysicsAttacker(self.Owner)
			ent:Spawn()

			local phys = ent:GetPhysicsObject()

			if IsValid(phys) then

				phys:SetVelocity(self.Owner:GetAimVector() * ((self.Tossed and self.TossVel) or self.ThrowVel) + (self.Owner:GetVelocity() * 0.5))

				local vel = phys:GetVelocity()
				local norm = vel:GetNormalized()

				phys:ApplyForceOffset(vel:GetNormalized() * math.random(5,10), ent:LocalToWorld(ent:OBBCenter()) + Vector(0,0,math.random(10,15)))

			end

			self.Owner:RemoveAmmo(1, self.Primary.Ammo)

		end

		self.NextAnimation = CurTime() + self.Primary.Delay
		self.ResetThrow = true
		self.Tossed = false
		
	end
	
	if self.Throwing and self.ResetThrow and self.NextAnimation < CurTime() then
		self.ResetThrow = false
		self.Throwing = false
		if SERVER then
			self:Remove()
		end
	end
	
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:PrimaryAttack()
	return false
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

local ENT = {}

ENT.PrintName = "Molotov"
ENT.Type = "anim"  
ENT.Base = "base_anim"

if CLIENT then
	function ENT:Draw()
		self:DrawModel()

		local dlight = DynamicLight(self:EntIndex())
		if dlight then
			dlight.Pos = self:GetAttachment(self:LookupAttachment("Wick")).Pos
			dlight.r = 255
			dlight.g = 100
			dlight.b = 50
			dlight.Brightness = 1
			dlight.Decay = 30
			dlight.Size = 100
			dlight.DieTime = CurTime() + 0.2
		end
	end
end

if SERVER then

	function ENT:Initialize()

		self:SetModel("models/murdered/weapons/w_molly.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

		local phys = self:GetPhysicsObject()  	
		if IsValid(phys) then 
			phys:Wake()
			phys:SetMass(1)
			phys:EnableDrag(true)
			phys:SetAngleDragCoefficient(20)
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			phys:SetBuoyancyRatio(1)
		end
		
		self.Life = 25
		self.Speed = self.Vel or self:GetVelocity():Length()

		self.OwnerReset = CurTime() + 1

		self.BurnSound = CreateSound(self, "ambient/fire/fire_small1.wav")
		self.BurnSound:Play()

		self.RagFire = ParticleEffectAttach("nmrih_molotov_rag_fire", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("Wick"))
		
		self:Fire("kill", 1, 30)

	end
	
	function ENT:Think()
	
		if self.Owner and self.OwnerReset and self.OwnerReset < CurTime() then -- I shouldn't even have to do this but Source is stupid
			self:SetOwner(NULL) -- Remove the Source-based "Owner" so the thrower can interact with their own Molotov
			self.OwnerReset = nil
		end

		if not self.Hit and not self:IsOnGround() and ((self.LastSpeedTick and self.LastSpeedTick < CurTime()) or not self.LastSpeedTick) then
			self.Speed = math.floor(self:GetVelocity():Length())
			self.LastSpeedTick = CurTime() + FrameTime()
		end
		
		if self:WaterLevel() > 0 then
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav",90,100)
			self:EmitSound("ambient/water/water_splash" .. math.random(1,3) .. ".wav",90,100)
			self:SetMoveType(MOVETYPE_NONE)
			self:SetNoDraw(true)
			self:StopParticles()
			self:Remove()
		end

		if self.Hit and self.HitData and not hull then

			self:SetMoveType(MOVETYPE_NONE)
			self:SetNoDraw(true)
			self:StopParticles()

			local pos = self.HitData.HitPos or self:GetPos()
			local normal = self.HitData.HitNormal or Vector(0,0,1)
			local vel = self.HitData.Velocity or vector_origin
		
			local hull = ents.Create("rj_molotov_hull")
			if not hull then return end
			hull:SetPos(pos + normal * (hull:OBBMaxs() / 2))
			hull:SetAngles(normal:Angle() + Angle(90,0,0))
			hull:SetOwner(self.Owner)
			hull.Owner = self.Owner
			hull.FirePos = pos
			hull.FireNormal = normal
			hull.Inflictor = self.Weapon or self.Owner:GetActiveWeapon() or self
			hull.DropToFloor = self.HitData.DropToFloor
			hull:Spawn()

			self:Remove()

		end
		
		self:NextThink(CurTime())
		
	end
	
	function ENT:OnRemove()

		self:StopParticles()

		if self.BurnSound then 
			self.BurnSound:Stop()
		end

	end
	
	function ENT:OnTakeDamage(dmg)
	
		local typ = dmg:GetDamageType()

		if typ and (typ == DMG_BULLET or typ == DMG_SLASH or typ == DMG_CLUB or typ == DMG_CRUSH or typ == DMG_BLAST) then
			dmg:ScaleDamage(10) -- Scale damage monumentally when it would realistically shatter the bottle instantly
		end
	
		self.Life = self.Life - dmg:GetDamage()

		if dmg:GetDamage() > self.Life or self.Life <= 0 and not self.Popped then

			self.Popped = true

			local att = dmg:GetAttacker()
			
			if IsValid(att) and att:IsPlayer() then
				self.Owner = att
			end

			self.HitData = {}
			self.Hit = true
			
		end
		
	end

	function ENT:Touch(ent) --NPCs and Zeta players are stupid and don't follow the laws of physics

		if IsValid(self) and IsValid(ent) and (ent:IsNPC() or ent:IsPlayer() or ent:IsNextBot()) and not self.Hit and self.Speed > 550 then
			self:DropToFloor()
			self.HitData = {}
			self.HitData.HitPos = ent:GetPos()
			self.HitData.HitNormal = Vector(0,0,1)
			self.HitData.Velocity = self:GetVelocity()
			self.Hit = true
		end

	end
	
	function ENT:PhysicsCollide(data, phys)	

		if IsValid(self) and not self.Hit and (IsValid(data.HitEntity) and not (string.find(data.HitEntity:GetClass(),"npc_") or data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) or not IsValid(data.HitEntity)) and self.Speed > 550 then

			self.HitData = {}
			self.HitData.HitPos = data.HitPos
			self.HitData.HitNormal = Vector(0,0,1)
			
			local trdata = {}
			trdata.start = data.HitPos
			trdata.endpos = data.HitPos + data.HitNormal
			local tr = util.TraceLine(trdata)

			if tr.Hit then
				self.HitData = tr
			end

			self.Hit = true
			
		end	
		
	end
	
end

local function MolotovResetKillCredit(ply,ent) --Anyone who picks up a Molotov gets kill credit if it pops
	if IsValid(ply) and ent:GetClass() == ClassName then
		ent.Owner = ply
	end
end
hook.Add("GravGunOnPickedUp","MolotovResetOnGravGun",MolotovResetKillCredit)
hook.Add("OnPhysgunPickup","MolotovResetOnPhysGun",MolotovResetKillCredit)
hook.Add("OnPlayerPhysicsPickup","MolotovResetOnPickup",MolotovResetKillCredit)

scripted_ents.Register(ENT, "rj_molotov", true)

local HULL = {}

HULL.PrintName = "Molotov Point Hurt"
HULL.Type = "anim"
HULL.Base = "base_anim"

if CLIENT then

	net.Receive("Molotov_vFireBall",function()
		local rad = net.ReadFloat()
		local pos = net.ReadVector()
		local vel = net.ReadVector()
		if vFireInstalled then
			molotov_vFireBall = CreateCSVFireBall(rad, pos, vel, 20, false)
		end
	end)

	function HULL:Draw()
		return false
	end

end

if SERVER then

	util.AddNetworkString("Molotov_vFireBall")

	function HULL:Initialize()
	
		self:SetModel("models/hunter/blocks/cube4x4x4.mdl")
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		self:SetSolidFlags(bit.bor(FSOLID_TRIGGER,FSOLID_USE_TRIGGER_BOUNDS))
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE) --god damn it valve
		self:SetNoDraw(true)
		self:SetTrigger(true)
		
		if IsValid(self.Owner) then
			self:SetOwner(self.Owner)
		end
	
		self.NextHurt = CurTime()

		self.BurnSound = CreateSound(self, "ambient/fire/fire_small_loop1.wav")
		self.BurnSound:PlayEx(1,98)
		self.BurnSound:SetSoundLevel(80)
		
		self:Fire("kill", 1, 20)

		if vFireInstalled and GetConVar("vfire_enable_damage"):GetBool() and self.FirePos then --vFire is installed and enabled, make a vFire
		
			local rad = self:BoundingRadius()
			local vel = self:GetUp() * 10

			for i=1,8 do
				self.vFire = CreateVFire(self, self:GetPos() + (self:GetForward() * VectorRand() * rad / 2) + (self:GetRight() * VectorRand() * rad / 2) - self:GetUp() * (self:OBBMaxs() / 2), self:GetUp(), 40)
				if IsValid(self.Owner) and IsValid(self.vFire) then
					self.vFire:SetOwner(self.Owner)
				end
			end
			
			self.vFireBall = CreateVFireBall(rad / 4, rad / 4, self.FirePos, vel, self:GetOwner() or self.Owner or self)

			if IsValid(self.Owner) then
				self.vFireBall:SetOwner(self.Owner)
			end
			
			net.Start("Molotov_vFireBall")
				local filter = RecipientFilter()
				filter:AddAllPlayers()
				net.WriteFloat(rad)
				net.WriteVector(self.FirePos)
				net.WriteVector(vel)
			net.Send(filter)

			if self.FirePos and self.FireNormal then
				ParticleEffectAttach("nmrih_molotov_explosion_nofire", PATTACH_ABSORIGIN_FOLLOW, self, 0)
			end
			
		elseif self.FirePos and self.FireNormal then -- emit the original particle effect if vFire is disabled/missing	
			ParticleEffectAttach("nmrih_molotov_explosion", PATTACH_ABSORIGIN_FOLLOW, self, 0)
		end
		
		self:EmitSound("murdered/weapons/molotov/ol_mollysplode" .. math.random(1,2) .. ".ogg",100,math.random(95,105))

		local attacker = self:GetOwner() or self.Owner or self
		local inflictor = self.Inflictor or self

		local dmg = DamageInfo()
		dmg:SetDamage(2)
		dmg:SetDamageType(DMG_GENERIC)
		dmg:SetDamageForce(Vector(0,0,0))

		if IsValid(attacker) then
			dmg:SetAttacker(attacker)
		end

		if IsValid(inflictor) then
			dmg:SetInflictor(inflictor)
		end

		local victims = ents.FindInBox(self:LocalToWorld(self:OBBMins()),self:LocalToWorld(self:OBBMaxs()))

		if victims and #victims > 0 then
			for i,victim in pairs(victims) do
				if IsValid(victim) and (string.find(victim:GetClass(),"npc_") or victim:IsNPC() or victim:IsPlayer()) then
					victim:TakeDamageInfo(dmg)
				end
			end
		end
		
	end
	
	function HULL:Touch(victim)

		if IsValid(victim) and self.NextHurt < CurTime() then
		
			local attacker = self:GetOwner() or self.Owner or self
			local inflictor = self.Inflictor or self

			local dmg = DamageInfo()
			dmg:SetDamage(2)
			dmg:SetDamageType(DMG_BURN)
			dmg:SetDamagePosition(self:GetPos())
			dmg:SetDamageForce(Vector(0,0,0))
			
			if IsValid(attacker) then
				dmg:SetAttacker(attacker)
			end
			
			if IsValid(inflictor) then
				dmg:SetInflictor(inflictor)
			end
			
			victim:TakeDamageInfo(dmg)
			victim:Ignite(6,8)
			
			self.NextHurt = CurTime() + 0.25
		
		end	
		
	end
	
	function HULL:Think()
		return false
	end
	
	function HULL:OnRemove()
		if self.BurnSound then 
			self.BurnSound:Stop() 
		end
	end

end

scripted_ents.Register(HULL, "rj_molotov_hull", true)