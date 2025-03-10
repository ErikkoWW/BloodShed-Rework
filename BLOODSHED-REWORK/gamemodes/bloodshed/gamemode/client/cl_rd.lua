local ragent = nil

local function LerpAngleFT(lerp,source,set)
	return LerpAngle(math.min(lerp * 0.5,1),source,set)
end

local LerpEyeRagdoll = Angle(0,0,0)
hook.Add("CalcView", "zRD_CamWork", function(ply, pos, angles, fov)
	ragent = ply:GetNWEntity('RD_EntCam')
	local ent = ragent
	local anim = ply:GetSVAnimation()

	if IsValid(ent) and !ent:IsPlayer() then
		if ent:LookupBone("ValveBiped.Bip01_Head1") then
			ent:ManipulateBoneScale(ent:LookupBone("ValveBiped.Bip01_Head1"), Vector(0, 0, 0))
		end

		timer.Create("headbackrag" .. ent:EntIndex(), 0.1, 1, function()
			if not IsValid(ent) then return end

			if ent:LookupBone("ValveBiped.Bip01_Head1") then
				ent:ManipulateBoneScale(ent:LookupBone("ValveBiped.Bip01_Head1"), Vector(1, 1, 1))
			end
		end)

		local t = ent:GetAttachment(ent:LookupAttachment("eyes"))

		if istable(t) then
			if ply:Alive() then
				t.Ang = angles + Angle(0, 0, t.Ang.z / 10)
				LerpEyeRagdoll = t.Ang
			end

			t.Pos = LocalToWorld(Vector(0, 0, 0), t.Ang, t.Pos, t.Ang)

			local view = {
				origin = t.Pos + Vector(0, 0, 2),
				angles = LerpEyeRagdoll,
				fov = fov,
				drawviewer = false
			}

			return view
		end
	end

	if string.match(anim, "mur_") or string.match(anim, "execution") or string.match(anim, "sequence_ron_") then
		local t = ply:GetAttachment(ply:LookupAttachment("eyes"))
		local cpos, cang = t.Pos, t.Ang
		if string.match(anim, "sequence_ron_") then
			cpos = cpos - ply:GetForward()*48 + ply:GetRight()*16 - Vector(0,0,8)
			cang = angles
		end
		if istable(t) then
			local view = {
				origin = cpos,
				angles = cang,
				fov = fov,
				drawviewer = true
			}

			return view
		end
	end
end)
net.Receive("MuR.RD_Cam", function()
	local ent = net.ReadEntity()
	ragent = net.ReadEntity()
end)

hook.Add("HUDPaint", "RD_CamWork", function()
	local ply = LocalPlayer()
	local ent = ply:GetNWEntity('RD_EntCam')
	local time = ply:TimeGetUp() - CurTime() + 1
	local formattime = string.FormattedTime(time, "%02i:%02i")

	if IsValid(ent) and ply:Alive() then
		if time > 999 then
			local parsed = markup.Parse("<font=MuR_Font3><colour=200,20,20>"..MuR.Language["ragdoll_heavy"])
			parsed:Draw(ScrW() / 2, He(880) + He(32), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		elseif time > 1 then
			local parsed = markup.Parse("<font=MuR_Font3><colour=255,255,255>"..MuR.Language["ragdoll_getup"].."<colour=200,200,0>" .. math.floor(time) .. "<colour=255,255,255>"..MuR.Language["second"])
			parsed:Draw(ScrW() / 2, He(880) + He(32), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			if ply:CanGetUp() then
				local parsed = markup.Parse("<font=MuR_Font3><colour=255,255,255>"..MuR.Language["ragdoll_press"].."<colour=200,200,0>C<colour=255,255,255>"..MuR.Language["ragdoll_getup2"])
				parsed:Draw(ScrW() / 2, He(880) + He(32), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				local parsed = markup.Parse("<font=MuR_Font3><colour=255,200,200>"..MuR.Language["ragdoll_cant"])
				parsed:Draw(ScrW() / 2, He(880) + He(32), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		local parsed = markup.Parse("<font=MuR_Font1><colour=255,255,255>"..MuR.Language["ragdoll_hold"].."<colour=200,200,0>LMB or RMB<colour=255,255,255>"..MuR.Language["ragdoll_pull"])
		parsed:Draw(ScrW() / 2, He(880) + He(60), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		local parsed = markup.Parse("<font=MuR_Font1><colour=255,255,255>"..MuR.Language["ragdoll_press"].."<colour=200,200,0>Shift or Alt<colour=255,255,255>"..MuR.Language["ragdoll_grab"])
		parsed:Draw(ScrW() / 2, He(880) + He(75), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		local parsed = markup.Parse("<font=MuR_Font1><colour=255,255,255>"..MuR.Language["ragdoll_press"].."<colour=200,200,0>Space<colour=255,255,255>"..MuR.Language["ragdoll_jump"])
		parsed:Draw(ScrW() / 2, He(880) + He(90), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		local parsed = markup.Parse("<font=MuR_Font1><colour=255,255,255>"..MuR.Language["ragdoll_press"].."<colour=200,200,0>F<colour=255,255,255>"..MuR.Language["ragdoll_stand"])
		parsed:Draw(ScrW() / 2, He(880) + He(105), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
		local wep = ply:GetNWEntity('RD_Weapon')
		if IsValid(wep) then
			if wep:GetNWBool('IsItem') then
				local parsed = markup.Parse("<font=MuR_Font1><colour=255,255,255>"..MuR.Language["ragdoll_press"].."<colour=200,200,0>CTRL<colour=255,255,255>"..MuR.Language["ragdoll_wep3"])
				parsed:Draw(ScrW() / 2, He(880) + He(130), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			elseif wep:LookupAttachment("muzzle_flash") > 0 then
				local parsed = markup.Parse("<font=MuR_Font1><colour=255,255,255>"..MuR.Language["ragdoll_press"].."<colour=200,200,0>CTRL<colour=255,255,255>"..MuR.Language["ragdoll_wep1"])
				parsed:Draw(ScrW() / 2, He(880) + He(130), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				local parsed = markup.Parse("<font=MuR_Font1><colour=255,255,255>"..MuR.Language["ragdoll_press"].."<colour=200,200,0>R<colour=255,255,255>"..MuR.Language["ragdoll_wep2"])
				parsed:Draw(ScrW() / 2, He(880) + He(145), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end)

local glow_mat = Material("sprites/glow04_noz")
hook.Add("PostDrawOpaqueRenderables", "fdasdf", function()
	local ply = LocalPlayer()
	local tr = ply:GetEyeTrace()

	local wep = ply:GetNWEntity('RD_Weapon')
	if IsValid(wep) and wep:LookupAttachment("muzzle_flash") > 0 then
		local att = wep:GetAttachment(wep:LookupAttachment("muzzle_flash"))
		local tr = util.TraceLine({
			start = att.Pos+att.Ang:Forward(),
			endpos = att.Pos+att.Ang:Forward()*1000,
			mask = MASK_SHOT,
			filter = wep,
		})
		local pos = tr.HitPos:ToScreen()
		cam.Start3D2D(tr.HitPos, tr.HitNormal:Angle()+Angle(90,0,0), 1)
			surface.SetDrawColor( 255, 0, 0, 255 )
			surface.SetMaterial(glow_mat)
			surface.DrawTexturedRect( -4, -4, 8, 8 )
		cam.End3D2D()
	end
end)

local HAND_ICON_MATERIAL = Material("vgui/hud/gmod_hand", "smooth")



hook.Add("PostDrawOpaqueRenderables", "DrawHandIcons", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local rag = ply:GetNWEntity("RD_Ent")
    if not IsValid(rag) then return end

    local leftHandGrabbing = rag:GetNWBool("LeftHandIcon", false)
    local rightHandGrabbing = rag:GetNWBool("RightHandIcon", false)

    if not leftHandGrabbing and not rightHandGrabbing then return end

    local leftHandBone = rag:LookupBone("ValveBiped.Bip01_L_Hand")
    local rightHandBone = rag:LookupBone("ValveBiped.Bip01_R_Hand")

    local iconSize = 32

    local eyeAng = ply:EyeAngles()
    eyeAng:RotateAroundAxis(eyeAng:Right(), 90) -- Adjust to always be flat
    eyeAng:RotateAroundAxis(eyeAng:Up(), 180)   -- Flip to face player correctly

    render.DepthRange( 0, 0.01 )
    render.OverrideDepthEnable(true, true)


    if leftHandGrabbing and leftHandBone then
        local boneMatrix = rag:GetBoneMatrix(leftHandBone)
        if boneMatrix then
            local pos = boneMatrix:GetTranslation()
            cam.Start3D2D(pos + eyeAng:Up() * 5, eyeAng, 0.1)
                surface.SetMaterial(HAND_ICON_MATERIAL)
                surface.SetDrawColor(255, 255, 255, 200)
                surface.DrawTexturedRect(-iconSize / 2, -iconSize / 2, iconSize, iconSize)
            cam.End3D2D()
        end
    end

    if rightHandGrabbing and rightHandBone then
        local boneMatrix = rag:GetBoneMatrix(rightHandBone)
        if boneMatrix then
            local pos = boneMatrix:GetTranslation() + eyeAng:Right() * 0
            cam.Start3D2D(pos + eyeAng:Up() * 5, eyeAng, 0.1)
                surface.SetMaterial(HAND_ICON_MATERIAL)
                surface.SetDrawColor(255, 255, 255, 200)
                surface.DrawTexturedRect(-iconSize / 2, -iconSize / 2, iconSize, iconSize)
            cam.End3D2D()
        end
    end

    -- Restore normal rendering
    render.DepthRange( 0, 1 )
    render.OverrideDepthEnable(false, false)  -- Restore depth behavior
end)