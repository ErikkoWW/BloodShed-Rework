include('shared.lua')

function ENT:Draw()
    self:DrawModel()

    local dlight = DynamicLight(self:EntIndex())
	if dlight then
		dlight.pos = self:GetPos()
		dlight.r = 200
		dlight.g = 20
		dlight.b = 20
		dlight.brightness = 2
		dlight.decay = 1000
		dlight.size = 256
		dlight.dietime = CurTime() + 1
	end
end