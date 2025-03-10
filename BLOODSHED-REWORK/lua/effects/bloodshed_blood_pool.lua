local bloodpools = {}
for i=1,34 do
	bloodpools[i] = "decals/bloodpool/bloodpool"..i
end

local blooddrops = {}
for i=1,23 do
	blooddrops[i] = "decals/denseblood/blood"..i
end

local function IsSolid(pos)
	return bit.band(util.PointContents(pos), CONTENTS_SOLID) == CONTENTS_SOLID
end

local function GetMaximumPoolSize(pos, normal, limit)
	local limit = limit or 50

	local fraction = 1
	
	local dn_dist = 4

	for size=1,limit,fraction do
		local dir = size
		local spots = {
			pos + Vector(0, dir, 0),
			pos + Vector(dir, 0, 0),
			pos + Vector(dir, dir, 0),
			pos + Vector(dir, -dir, 0),
			pos + Vector(0, -dir, 0),
			pos + Vector(-dir, -dir, 0),
			pos + Vector(-dir, 0, 0),
			pos + Vector(-dir, dir, 0)
		}
	
		for i=1,#spots do
			local spos = spots[i] + Vector(0,0,1)
			local epos = spots[i] + Vector(0,0,-dn_dist)
			
			if not IsSolid(spos) then
				local tr = util.TraceLine({start=spos, endpos=epos, mask=MASK_DEADSOLID})
				
				if not tr.Hit then
					return (size-fraction)
				end
			end
		end
	end
	
	return limit
end

function EFFECT:Init(data)
	local ent = data:GetEntity()
	
	if not IsValid(ent) then return end

	local bone = data:GetAttachment() or 0
	local flags = data:GetFlags() or 0
	local color = data:GetColor()
	local rad = data:GetRadius() or 0
	if flags == 1 then --blood small
		self.MinSize = 6
		self.MaxSize = 8
		self.BloodType = blooddrops
		self.RndPos = VectorRand(-16,16)
		self.RndPos.z = 0
	elseif flags == 2 then --blood big
		self.MinSize = 44
		self.MaxSize = 36
		self.BloodType = bloodpools
		self.RndPos = Vector(0,0,0)
	elseif flags == 3 then --blood gib
		self.MinSize = 12
		self.MaxSize = 16
		self.BloodType = bloodpools
		self.RndPos = Vector(0,0,0)
	else
		self.MinSize = 24
		self.MaxSize = 28
		self.BloodType = bloodpools
		self.RndPos = Vector(0,0,0)
	end
	if rad == 0 then
		self.NoVelocity = true
		self.BloodTime = 0
	else
		self.BloodTime = CurTime()+3
	end
	
	self.LifeTime = CurTime() + 180
	self.Entity = ent
	self.BoneID = bone
	self.BloodColor = color
	self.LastPos = ent:GetPos()

	self.MaxBloodTime = CurTime() + 180
	
	self.Initialized = true
	self.Iteration = 1
end

function EFFECT:Think()
	if not self.Initialized then return true end

	if not IsValid(self.Entity) or (self.LifeTime and self.LifeTime < CurTime()) or (not self.Iteration or self.Iteration ~= 1) then
		if self.BloodPool then
			self.BloodPool:SetLifeTime(0)
			self.BloodPool:SetDieTime(0.05)
			self.BloodPool:SetStartSize(0)
			self.BloodPool:SetEndSize(0)
		end
		
		if self.ParticleEmitter and self.ParticleEmitter:IsValid() then
			self.ParticleEmitter:SetNoDraw(true)
			self.ParticleEmitter:Finish()
		end
		
		return false
	end

	local ent = self.Entity
	local pos = ent:GetBonePosition(self.BoneID)

	if not self.BloodPool then
		if not self.ParticleEmitter then
			self.ParticleEmitter = ParticleEmitter(pos, true)
		end

		if CurTime() >= self.BloodTime and CurTime() < self.MaxBloodTime then
			local tr = util.TraceLine({start=pos + Vector(0,0,32), endpos=pos + Vector(0,0,-128), mask=MASK_DEADSOLID})

			if tr.Hit and (self.NoVelocity or ent:GetVelocity():Length() < 0.05) then
				local pos = tr.HitPos + tr.HitNormal * 0.005
				
				local minsize = self.MinSize
				local maxsize = self.MaxSize
				
				if minsize > maxsize then
					minsize = maxsize
				end
				
				local size = GetMaximumPoolSize(pos, tr.HitNormal, math.random(minsize,maxsize))
				
				if size > 5 then
					self.StartBleedingTime = CurTime()
					self.EndSize = size

					local pos = tr.HitPos + self.RndPos
					local ang = tr.HitNormal:Angle()
					
					ang.roll = math.random(0,360)
					
					local maxtime = (self.EndSize/50) * 50
					
					local particle = self.ParticleEmitter:Add(table.Random(self.BloodType), tr.HitPos)
					particle:SetStartSize(0)
					particle:SetEndSize(self.EndSize * 1.2)
					particle:SetDieTime(maxtime * 1.2)
					particle:SetStartAlpha(225)
					particle:SetEndAlpha(225)
					particle:SetPos(pos)
					particle:SetAngles(ang)

					self.BloodPool = particle
				else
					self.BloodTime = CurTime() + 15.0
				end
			end
		end
	else
		if self.ParticleEmitter and IsValid(self.ParticleEmitter) then
			self.ParticleEmitter:Finish()
		end
		
		local maxtime = (self.EndSize/50) * 50
		local timer = maxtime - ((self.StartBleedingTime + maxtime) - CurTime())

		local particle = self.BloodPool
		particle:SetLifeTime(math.min(timer, maxtime))
	end

	return true
end

function EFFECT:Render()

end