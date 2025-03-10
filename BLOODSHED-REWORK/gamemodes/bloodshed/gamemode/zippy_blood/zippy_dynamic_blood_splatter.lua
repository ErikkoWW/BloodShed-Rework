AddCSLuaFile("dynsplatter/sh_override_funcs.lua")

game.AddParticles("particles/blood_impact.pcf")
PrecacheParticleSystem("blood_impact_synth_01")

if SERVER then
	include("dynsplatter/sv_hooks.lua")
end

include("dynsplatter/sh_override_funcs.lua")