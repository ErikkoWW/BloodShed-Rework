local grtodown = Material( "vgui/gradient-u" )
local grtoup = Material( "vgui/gradient-d" )
local grtoright = Material( "vgui/gradient-l" )
local grtoleft = Material( "vgui/gradient-r" )
local addmat_r = Material("CA/add_r")
local addmat_g = Material("CA/add_g")
local addmat_b = Material("CA/add_b")
local vgbm = Material("vgui/black")

local blurimpulse = 0
local impulse = 0
local k = 0
local k4 = 0
local k3 = 0
local time = 0

net.Receive("MuR.PainImpulse",function()
	local fl = net.ReadFloat()
	impulse = fl * 10
	blurimpulse = fl * 5
end)

hook.Add("HUDPaint","MuR.PainEffect",function()
   if not LocalPlayer():Alive() then return end
   if blurimpulse <= 0 then return end

   k = Lerp(0.1,k,math.Clamp(blurimpulse / 250,0,15))
   DrawMotionBlur(0.2, k * 0.7, 0.02)
end)

local function DrawCA(rx, gx, bx, ry, gy, by)
	render.UpdateScreenEffectTexture()
	addmat_r:SetTexture("$basetexture", render.GetScreenEffectTexture())
	addmat_g:SetTexture("$basetexture", render.GetScreenEffectTexture())
	addmat_b:SetTexture("$basetexture", render.GetScreenEffectTexture())
	render.SetMaterial(vgbm)
	render.DrawScreenQuad()
	render.SetMaterial(addmat_r)
	render.DrawScreenQuadEx(-rx / 2, -ry / 2, ScrW() + rx, ScrH() + ry)
	render.SetMaterial(addmat_g)
	render.DrawScreenQuadEx(-gx / 2, -gy / 2, ScrW() + gx, ScrH() + gy)
	render.SetMaterial(addmat_b)
	render.DrawScreenQuadEx(-bx / 2, -by / 2, ScrW() + bx, ScrH() + by)
end

hook.Add("RenderScreenspaceEffects","MuR.PainImpulse",function()
	if impulse <= 0 and blurimpulse <= 0 then return end
	k3 = math.Clamp(Lerp(0.01,k3,impulse),0,50)
	if LocalPlayer():Alive() then
		impulse = math.max(impulse-FrameTime()/0.05, 0)
		blurimpulse = math.max(blurimpulse-FrameTime(), 0)
	else
		impulse = 0
		blurimpulse = 0
	end
	DrawCA(4 * k3, 2 * k3, 0, 2 * k3, 1 * k3, 0)
end)