
local cache = {}
local _GetChildBonesRecursive
local mdl = ""

_GetChildBonesRecursive = function(ent, bone, src)
	local t = src or {}
	table.insert(t, bone)
	local cbones = ent:GetChildBones(bone)

	if cbones then
		for _, bone in next, cbones do
			_GetChildBonesRecursive(ent, bone, t)
		end
	end

	return t
end

local function GetChildBonesRecursive(ent, bone)
	local mdl = ent:GetModel()
	local mdlbones = cache[mdl]

	if not mdlbones then
		mdlbones = {}
		cache[mdl] = mdlbones
	end

	local ret = mdlbones[bone]
	if ret then return ret end
	ret = _GetChildBonesRecursive(ent, bone)
	mdlbones[bone] = ret

	return ret
end

local bones = {}
local bonesName = {}
local forwardDistance = 16
local queue = {}
local work = false
local lowerbody = false

MuR.EnableFPBody = true

local MarkToRemove = function(ent)
	if not IsValid(ent) then
		return
	end

	work = true
	ent:SetNoDraw(true)
	table.insert(queue, ent)
end

hook.Add("Think", "legs.MarkToRemove", function()
	if not work then
		return
	end

	for key, ent in pairs(queue) do
		if ent:IsValid() then
			ent:Remove()
		end

		queue[key] = nil
	end

	if not next(queue) then
		work = false
	end
end)

hook.Add("LocalPlayer_Validated", "mur_gmod_legs", function(ply)
	hook.Remove("LocalPlayer_Validated", "mur_gmod_legs")

	local pairs, ipairs = pairs, ipairs
	local playermodelbones = {"ValveBiped.Bip01_Head1","ValveBiped.Bip01_R_Trapezius","ValveBiped.Bip01_R_Bicep","ValveBiped.Bip01_R_Shoulder", "ValveBiped.Bip01_R_Elbow","ValveBiped.Bip01_R_Wrist","ValveBiped.Bip01_R_Ulna","ValveBiped.Bip01_L_Trapezius","ValveBiped.Bip01_L_Bicep","ValveBiped.Bip01_L_Shoulder", "ValveBiped.Bip01_L_Elbow","ValveBiped.Bip01_L_Wrist","ValveBiped.Bip01_L_Ulna", "ValveBiped.Bip01_Neck1","ValveBiped.Bip01_Hair1","ValveBiped.Bip01_Hair2","ValveBiped.Bip01_L_Clavicle","ValveBiped.Bip01_R_Clavicle","ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Hand", "ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Hand", "ValveBiped.Bip01_L_Wrist", "ValveBiped.Bip01_R_Wrist", "ValveBiped.Bip01_L_Finger4", "ValveBiped.Bip01_L_Finger41", "ValveBiped.Bip01_L_Finger42", "ValveBiped.Bip01_L_Finger3", "ValveBiped.Bip01_L_Finger31", "ValveBiped.Bip01_L_Finger32", "ValveBiped.Bip01_L_Finger2", "ValveBiped.Bip01_L_Finger21", "ValveBiped.Bip01_L_Finger22", "ValveBiped.Bip01_L_Finger1", "ValveBiped.Bip01_L_Finger11", "ValveBiped.Bip01_L_Finger12", "ValveBiped.Bip01_L_Finger0", "ValveBiped.Bip01_L_Finger01", "ValveBiped.Bip01_L_Finger02", "ValveBiped.Bip01_R_Finger4", "ValveBiped.Bip01_R_Finger41", "ValveBiped.Bip01_R_Finger42", "ValveBiped.Bip01_R_Finger3", "ValveBiped.Bip01_R_Finger31", "ValveBiped.Bip01_R_Finger32", "ValveBiped.Bip01_R_Finger2", "ValveBiped.Bip01_R_Finger21", "ValveBiped.Bip01_R_Finger22", "ValveBiped.Bip01_R_Finger1", "ValveBiped.Bip01_R_Finger11", "ValveBiped.Bip01_R_Finger12", "ValveBiped.Bip01_R_Finger0", "ValveBiped.Bip01_R_Finger01", "ValveBiped.Bip01_R_Finger02"}
	local a = {}

	for key, v in pairs(playermodelbones) do
		a[v] = true
	end

	local ply = ply or LocalPlayer()
	local vec9999 = Vector(9999, 9999, 9999)

	local ENTITY, PLAYER = FindMetaTable("Entity"), FindMetaTable("Player")

	local GetBoneName = ENTITY.GetBoneName
	local LookupBone = ENTITY.LookupBone

	local MATRIX = FindMetaTable("VMatrix")
	local Scale, Translate, SetTranslation, SetAngles = MATRIX.Scale, MATRIX.Translate, MATRIX.SetTranslation, MATRIX.SetAngles
	local GetTranslation, GetAngles = MATRIX.GetTranslation, MATRIX.GetAngles
	local SetBoneMatrix = ENTITY.SetBoneMatrix
	local cam_Start3D, render_EnableClipping, render_PushCustomClipPlane, render_PopCustomClipPlane, render_EnableClipping, cam_End3D =
		cam.Start3D, render.EnableClipping, render.PushCustomClipPlane, render.PopCustomClipPlane, render.EnableClipping, cam.End3D
	local SetupBones = ENTITY.SetupBones
	local _EyePos = ENTITY.EyePos

	MarkToRemove(ply.Body)
	MarkToRemove(ply.Body_NoDraw)

	local remap = math.Remap
	local eyeAngles = Angle()
	local suppress = false

	local isDucking = false
	local finalPos = Vector()
	local limit_check = 0
	local timeCache = 0.1
	local vector_origin = Vector(0, 0, 0)

	local find, insert = string.find, table.insert

	local SetPoseParameter, GetPoseParameter = ENTITY.SetPoseParameter, ENTITY.GetPoseParameter
	local SetPlaybackRate, GetPlaybackRate = ENTITY.SetPlaybackRate, ENTITY.GetPlaybackRate
	local GetBoneMatrix = ENTITY.GetBoneMatrix

	local a1, b1, c1 = 0, 0, 0
	local headPos = Vector(0,10000,0)
	local limitJump = 0

	local onGround = true
	local JUMPING_ = false

	hook.Add("SetupMove", "legs.SetupMove", function(ply, move)
		if not IsFirstTimePredicted() then
			return
		end
	
		if bit.band(move:GetButtons(), IN_JUMP) ~= 0
			and bit.band(move:GetOldButtons(), IN_JUMP) == 0
			and ply:OnGround() then
			JUMPING, onGround = true, false
	
			if IsFirstTimePredicted() then
				JUMPING_ = not JUMPING_
			end
		end
	end)

	hook.Add("FinishMove", "legs.FinishMove", function(ply, move)
		if not IsFirstTimePredicted() then
			return
		end
	
		JUMPING = nil
	
		local isOnGround = ply:OnGround()
	
		if onGround ~= isOnGround then
			onGround = isOnGround
	
			if onGround then
				limitJump = CurTime() + FrameTime()
			end
		end
	end)

	local validBones = {}

	local removeHead = function()
		local legs = ply.Body
		local h = LookupBone(legs, "ValveBiped.Bip01_Head1")

		if h then
			legs:ManipulateBonePosition(h, headPos)
		end
	end

	local GetPos, GetViewOffset = ENTITY.GetPos, PLAYER.GetViewOffset

	local removeGarbage = function(bonesSuccess, boneCount)
		local ent = ply.Body
		local goofyUhhPosition = GetPos(ply) + GetViewOffset(ply) - eyeAngles:Forward() * 32

		for i = 0, boneCount - 1 do
			local boneName = GetBoneName(ent, i)
			local mat = GetBoneMatrix(ent, i)

			if mat then
				if a[boneName] then
					SetTranslation(mat, goofyUhhPosition)

					bonesSuccess[i] = true

					local recursive = GetChildBonesRecursive(ent, i)

					for key = 1, #recursive do
						local bone = recursive[key]

						if not bonesSuccess[bone] then
							bonesSuccess[bone] = true

							local mat = GetBoneMatrix(ent, bone)

							if mat then
								SetTranslation(mat, goofyUhhPosition)

								SetBoneMatrix(ent, bone, mat)
							end
						end
					end
				elseif not bonesSuccess[i] then
					local bone = LookupBone(ply, boneName)

					if bone then
						local mat2 = GetBoneMatrix(ply, bone)

						if mat2 then
							SetTranslation(mat, GetTranslation(mat2))
							SetAngles(mat, GetAngles(mat2))
						end
					end
				end
	
				SetBoneMatrix(ent, i, mat)
			end
		end
	end

	local Legs_NoDraw_Angle = Angle(0, 0, 0)
	local potentionalBones, timeCacheBones = {}, 0

	local spineBones = {
		["ValveBiped.Bip01_Spine2"] = true,
		["ValveBiped.Bip01_Spine4"] = true
	}

	local GetNumPoseParameters, GetPoseParameterRange = ENTITY.GetNumPoseParameters, ENTITY.GetPoseParameterRange
	local GetPoseParameterName, GetSequence = ENTITY.GetPoseParameterName, ENTITY.GetSequence
	local GetRenderAngles, SetRenderAngles = PLAYER.GetRenderAngles, PLAYER.SetRenderAngles

	local buildBonePosition = function()
		ply.Body.Callback = ply.Body:AddCallback("BuildBonePositions", function(ent, boneCount)
			if not MuR.EnableFPBody then
				return ent:RemoveCallback("BuildBonePositions", ent.Callback)
			end

			if not ply.TimeToDuck
				or suppress then
				return
			end

			local ang = GetRenderAngles(ply)
			SetRenderAngles(ply, eyeAngles)

			a1, b1, c1 = GetPoseParameter(ply, "body_yaw", 0), GetPoseParameter(ply, "aim_yaw", 0), GetPoseParameter(ply, "aim_pitch", 0)

			SetPoseParameter(ply, "body_yaw", 0)
			SetPoseParameter(ply, "aim_yaw", 0)
			SetPoseParameter(ply, "aim_pitch", 0)

			SetupBones(ply)

			local seq = GetSequence(ply)

			if ent.Seq ~= seq then
				ent.Seq = seq

				ent:ResetSequence(seq)
			end

			local legsNoDraw = ply.Body_NoDraw

			for i = 0, GetNumPoseParameters(ply) - 1 do
				local flMin, flMax = GetPoseParameterRange(ply, i)
				local sPose = GetPoseParameterName(ply, i)
				local remap = remap(GetPoseParameter(ply, sPose), 0, 1, flMin, flMax)
				SetPoseParameter(legsNoDraw, sPose, remap)
				SetPoseParameter(ent, sPose, remap)
			end

			local bonesSuccess = {}
			removeGarbage(bonesSuccess, boneCount)

			SetPoseParameter(ply, "body_yaw", a1)
			SetPoseParameter(ply, "aim_yaw", b1)
			SetPoseParameter(ply, "aim_pitch", c1)

			removeHead()

			SetupBones(legsNoDraw)

			local this = (2 - (0.8 * ply.TimeToDuck))
			local cacheThis = this
			local CT = CurTime()

			if timeCacheBones < CT then
				timeCacheBones, potentionalBones = CT + timeCache, {}

				for i = 1, #validBones do
					local array = validBones[i]
					local bone, isPelvis = array[2], array[1]

					if bonesSuccess[bone] then
						continue
					end

					local recursive = GetChildBonesRecursive(ent, bone)

					for key = 1, #recursive do
						local i = recursive[key]

						if not bonesSuccess[i]
							and (isPelvis and i == bone or not isPelvis) then
							bonesSuccess[i] = true

							local boneName = GetBoneName(ent, i)
							local mat = GetBoneMatrix(ent, i)

							if mat then
								local b = LookupBone(legsNoDraw, boneName)

								if b then
									local mat2 = GetBoneMatrix(legsNoDraw, b)

									if mat2 then
										local matTR, mat2TR = GetTranslation(mat), GetTranslation(mat2)

										if boneName == "ValveBiped.Bip01_Pelvis" then
											Legs_NoDraw_Angle.y = (math.NormalizeAngle(ply:EyeAngles().y - GetAngles(mat).y) + 90) / 1.25
										elseif spineBones[boneName] then
											this = 20 - (16 * ply.TimeToDuck)
										end

										if not lowerbody then
											SetTranslation(mat, mat2TR - (mat2TR - matTR) / this)
											this = cacheThis
											SetAngles(mat, GetAngles(mat2))
											SetBoneMatrix(ent, i, mat)
										end

										potentionalBones[#potentionalBones + 1] = {
											[1] = i,
											[2] = boneName
										}
									end
								end
							end
						end
					end
				end
			else
				for key = 1, #potentionalBones do
					local array = potentionalBones[key]
					local i, boneName = array[1], array[2]
					local mat = GetBoneMatrix(ent, i)

					if mat then
						local b = LookupBone(legsNoDraw, boneName)

						if b then
							local mat2 = GetBoneMatrix(legsNoDraw, b)

							if mat2 then
								if boneName == "ValveBiped.Bip01_Pelvis" then
									Legs_NoDraw_Angle.y = (math.NormalizeAngle(ply:EyeAngles().y - GetAngles(mat).y) + 90) / 1.25
								elseif spineBones[boneName] then
									this = 20 - (16 * ply.TimeToDuck)
								end

								local matTR, mat2TR = GetTranslation(mat), GetTranslation(mat2)

								if not lowerbody then
									SetTranslation(mat, mat2TR - (mat2TR - matTR) / this)
									this = cacheThis
									SetAngles(mat, GetAngles(mat2))
									SetBoneMatrix(ent, i, mat)
								end
							end
						end
					end
				end
			end

			SetRenderAngles(ply, ang)
		end)

		ply.Body.FullyLoaded = true
	end

	local faggot = Vector()
	local SetParent, SetPos, SetAngles, SetCycle = ENTITY.SetParent, ENTITY.SetPos, ENTITY.SetAngles, ENTITY.SetCycle
	local GetCycle = ENTITY.GetCycle
	local lowerbodyseq = {
		["mur_dropkick"] = {0.2, 1},
		["mur_fall_idle"] = {0, 1},
		["mur_fall_down"] = {0.2, 1},
		["mur_fall_standup"] = {0, 0.4},
	}

	hook.Add("RenderScene", "firstperson.RenderScene", function(vec, ee)
		if not MuR.EnableFPBody then
			return
		end

		eyePos = vec
		eyeAngles = ply:EyeAngles()
		eyeAngles.p = 0

		local onGround = ply:OnGround()
		isDucking = bit.band(ply:GetFlags(), FL_ANIMDUCKING) > 0
			and onGround

		local FT = FrameTime()

		ply.TimeToDuck = math.Clamp((ply.TimeToDuck or 0) + FT * 3.5 * (isDucking and 1 or -1), 0, 1)

		local realEyeAngles = EyeAngles()
		local legs = ply.Body

		suppress = ply:ShouldDrawLocalPlayer()
			or not ply:Alive()
			or not IsValid(ply.Body)
			or not ply.Body.FullyLoaded
			or not IsValid(ply.Body_NoDraw)
			or ply:GetRagdollEntity():IsValid()
			or ply:InVehicle()
			or ply:GetObserverMode() ~= 0
			or realEyeAngles.p > 110
			or realEyeAngles.p < -110
			or ply:GetSVAnim() != ""
			or IsValid(ply:GetNWEntity('RD_Ent')) and ply:GetNWEntity('RD_Ent') != NULL

		local CT = SysTime()

		if limit_check < CT and IsValid(ply.Body) then
			limit_check = CT + timeCache

			if ply.Body.Callback then
				local getCallbacks = ply.Body:GetCallbacks("BuildBonePositions")

				if not getCallbacks[ply.Body.Callback] then
					buildBonePosition()
				end
			else
				buildBonePosition()
			end

			ply.Body:SetSkin(ply:GetSkin())
			ply.Body:SetMaterial(ply:GetMaterial())

			if not suppress then
				for k, v in ipairs(ply:GetBodyGroups()) do
					local bg = ply:GetBodygroup(v.id)

					ply.Body:SetBodygroup(v.id, bg)
					ply.Body_NoDraw:SetBodygroup(v.id, bg)
				end
			end

			validBones = {}

			for i = 0, ply.Body:GetBoneCount() - 1 do
				local boneName = GetBoneName(ply.Body, i)
				local isPelvis = find(boneName, "Pelvis", 1, true) or false

				if find(boneName, "Spine", 1, true)
					or isPelvis
					or find(boneName, "Jacket", 1, true) then
					validBones[#validBones + 1] = {
						[1] = isPelvis,
						[2] = i
					}
				end
			end
		end

		if suppress then
			return
		end

		local getPos = GetPos(ply)
		local getView = GetViewOffset(ply)
		local cycle = GetCycle(ply)

		SetParent(ply.Body, ply)
		SetPos(ply.Body, getPos)
		SetAngles(ply.Body, eyeAngles)
		SetPlaybackRate(ply.Body, GetPlaybackRate(ply))
		SetCycle(ply.Body, cycle)
	
		local currentView = ply:GetCurrentViewOffset()
		local forward = eyeAngles:Forward() * forwardDistance

		ply.TimeToFaggot = math.Clamp((ply.TimeToFaggot or 0) + FT * (ply:Crouching() and 4 or 10000) * (not onGround and 1 or -1), 0, 1)

		SetParent(ply.Body_NoDraw, ply)
		SetPos(ply.Body_NoDraw, getPos)
		SetAngles(ply.Body_NoDraw, eyeAngles - Legs_NoDraw_Angle)

		faggot = (not onGround or limitJump > CurTime()) and getView - currentView or vector_origin

		finalPos = getPos
			+ currentView
			+ forward
			+ (faggot * ply.TimeToFaggot)
	end)

	local vector_down = Vector(0, 0, -1)
	local vec1 = Vector(0, 0, 1)
	local erroredModels = {}

	hook.Add("PreDrawViewModels", "firstperson.PreDrawViewModel", function(depth, skybox, isDraw3DSkybox)
		if not MuR.EnableFPBody then
			return
		end

		local current = ply.wardrobe or ply:GetModel()

		if not erroredModels[current]
			and (not IsValid(ply.Body)
			or ply.Body:GetModel() ~= current) then
			MarkToRemove(ply.Body)
			MarkToRemove(ply.Body_NoDraw)

			ply.Body = ClientsideModel(current)
			ply.Body:SetNoDraw(true)
			ply.Body:SetIK(false)
			SetupBones(ply.Body)
			ply.Body.GetPlayerColor = function()
				return ply:GetPlayerColor()
			end

			local seq = ply.Body:LookupSequence("idle_all_01")

			if seq < 0 then
				MarkToRemove(ply.Body)

				erroredModels[current] = true

				return
			end

			ply.Body_NoDraw = ClientsideModel(current)
			ply.Body_NoDraw:SetNoDraw(true)
			ply.Body_NoDraw:SetIK(false)
			ply.Body_NoDraw.GetPlayerColor = function()
				return ply:GetPlayerColor()
			end

			ply.Body_NoDraw:SetSequence(seq)

			ply.Body.FullyLoaded, timeCacheBones = false, 0
		end

		if suppress then
			return
		end

		local RT = render.GetRenderTarget()

		if RT then
			return
		end

		if hook.Run("ShouldDisableLegs", ply.Body) == true then
			return
		end

		local ret = hook.Run("PreDrawBody", ply.Body)

		if ret == false then
			return
		end

		local shootPos, getPos = _EyePos(ply), GetPos(ply)
		shootPos.z = 0
		getPos.z = 0

		local color = ply:GetColor()
		local m1, m2, m3 = render.GetColorModulation()

		cam_Start3D(finalPos + (shootPos - getPos), nil, nil, 0, 0, nil, nil, 0.5, -1)
			local bEnabled = render_EnableClipping(true)
			render_PushCustomClipPlane(vector_down, vector_down:Dot(finalPos + vec1))
				render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255)
					ply.Body:DrawModel()
				render.SetColorModulation(m1, m2, m3)
			render_PopCustomClipPlane()
			render_EnableClipping(bEnabled)
		cam_End3D()

		hook.Run("PostDrawBody", ply.Body)
	end)

	hook.Add("PreDrawBody", "mur_body.PreDrawBody_Compat", function()
		if VWallrunning
			or inmantle then
			return false
		end
	end)
end)

hook.Add("Think", "mur_legs.Load", function()
	local ply = LocalPlayer()

	if IsValid(ply) then
		hook.Remove("Think", "mur_legs.Load")

		hook.Run("LocalPlayer_Validated", ply)
	end
end)