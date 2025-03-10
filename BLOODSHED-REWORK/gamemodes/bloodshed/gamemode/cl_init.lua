MuR = MuR or {}

function MuR.server()
end

function MuR.shared(path)
    include(path)
end

function MuR.client(path)
    include(path)
end

MuR.shared("shared.lua")

CreateConVar("cl_drawspawneffect", 0)