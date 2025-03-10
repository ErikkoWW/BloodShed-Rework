local function create_materials( mat_names )
	local mats = {}

	for _, v in ipairs(mat_names) do
		local imat = Material(v)
		table.insert(mats, imat)
	end

	return mats
end

local blood_materials = create_materials({
	"rlb/blood1",
	"rlb/blood2",
	"rlb/blood3",
	"rlb/blood4",
	"rlb/blood5",
	"rlb/blood6",
	"rlb/blood7",
	"rlb/blood8",
	"rlb/blood9",
	"rlb/blood10",
	"rlb/blood11",
	"rlb/blood12",
	"rlb/blood13",
	"rlb/blood14",
	"rlb/blood15",
	"rlb/blood16",
	"rlb/blood17",
	"rlb/blood18",
	"rlb/blood19",
	"rlb/blood20",
	"rlb/blood21",
})

local yblood_materials = create_materials({
	"decals/yblood1",
	"decals/yblood2",
	"decals/yblood3",
	"decals/yblood4",
	"decals/yblood5",
	"decals/yblood6",
})

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Init( data )
	self.Entity = data:GetEntity()
	self.NextBloodSplat = CurTime()
	self.NextGroundCheckTime = CurTime() + math.Rand(0.25, 0.5)
	self.EffectKillTime = CurTime() + 6
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	if self.EffectKillTime < CurTime() then return false end
	if !IsValid(self.Entity) then return false end

	local blood_color = self.Entity:GetNWInt("ZippyGoreMod3_BloodColor", -1)

	if ZGM3_CVARS["zippygore3_bleed_effect"] && self.NextBloodSplat < CurTime() then
		self.NextBloodSplat = CurTime() + ( ( ZGM3_INSANE_BLOOD_EFFECTS && math.Rand(0.05, 0.1) ) or math.Rand(0.1, 0.2) )
		local blood_particles = {
			[BLOOD_COLOR_RED] = ZGM3_INSANE_BLOOD_EFFECTS && "blood_stream_goop_large" or "blood_impact_red_01_goop",
			[BLOOD_COLOR_ANTLION] = "blood_impact_yellow_01",
			[BLOOD_COLOR_ANTLION_WORKER] = "blood_impact_yellow_01",
			[BLOOD_COLOR_GREEN] = "blood_impact_yellow_01",
			[BLOOD_COLOR_ZOMBIE] = "blood_impact_yellow_01",
			[BLOOD_COLOR_YELLOW] = "blood_impact_yellow_01",
			[BLOOD_COLOR_ZGM3SYNTH] = "blood_impact_synth_01",
		}
		local effect = blood_particles[blood_color]
		if effect then ParticleEffect( effect, self.Entity:WorldSpaceCenter(), AngleRand() ) end
	end

	if self.NextGroundCheckTime < CurTime() then
		self.NextGroundCheckTime = CurTime() + math.Rand(0.25, 0.5)

		if self.Entity:GetVelocity():LengthSqr() < 64 then
			local tr = util.TraceLine({
				start = self.Entity:WorldSpaceCenter(),
				endpos = self.Entity:WorldSpaceCenter() - Vector(0, 0, 50 ),
				mask = MASK_NPCWORLDSTATIC,
			})
			if tr.Hit then
				local bc = blood_color
				if ZGM3_INSANE_BLOOD_EFFECTS && bc == BLOOD_COLOR_RED then
					local effectdata = EffectData()
					effectdata:SetEntity(self.Entity)
					effectdata:SetStart(tr.HitPos)
					effectdata:SetNormal(-tr.HitNormal)
					effectdata:SetMagnitude(ZGM3_CVARS["realistic_blood_max_damage"]*0.5)
					effectdata:SetFlags( math.random(1, 2) )
					util.Effect("realisticblood_splatter", effectdata)
				elseif math.random(1, 2)==1 then
					local materials = ( bc==BLOOD_COLOR_RED && table.Copy(blood_materials) ) or
					( ( bc==BLOOD_COLOR_ANTLION or bc==BLOOD_COLOR_ANTLION_WORKER or bc==BLOOD_COLOR_GREEN or bc==BLOOD_COLOR_ZOMBIE or bc==BLOOD_COLOR_YELLOW ) && table.Copy(yblood_materials) )
					if materials then util.DecalEx( table.Random( materials ), tr.Entity, tr.HitPos, tr.HitNormal, Color(255, 255, 255), math.Rand(0.75, 1), math.Rand(0.75, 1)) end
				end
			end

			return false
		end
	end

	return true
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------