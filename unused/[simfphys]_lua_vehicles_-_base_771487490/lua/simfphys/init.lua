if SERVER then
	AddCSLuaFile("simfphys/client/killicons.lua")
	AddCSLuaFile("simfphys/client/fonts.lua")
	AddCSLuaFile("simfphys/client/tab.lua")
	AddCSLuaFile("simfphys/client/hud.lua")
	AddCSLuaFile("simfphys/client/seatcontrols.lua")
	AddCSLuaFile("simfphys/client/lighting.lua")
	AddCSLuaFile("simfphys/client/damage.lua")
	AddCSLuaFile("simfphys/client/poseparameter.lua")
	
	AddCSLuaFile("simfphys/anim.lua")
	AddCSLuaFile("simfphys/base_functions.lua")
	AddCSLuaFile("simfphys/rescuespawnlists.lua")
	AddCSLuaFile("simfphys/base_lights.lua")
	AddCSLuaFile("simfphys/base_vehicles.lua")
	AddCSLuaFile("simfphys/view.lua")
	AddCSLuaFile("simfphys/wheelpickup.lua")
	
	include("simfphys/base_functions.lua")
	include("simfphys/server/exitpoints.lua")
	include("simfphys/server/spawner.lua")
	include("simfphys/server/seatcontrols.lua")
	include("simfphys/server/damage.lua")
	include("simfphys/server/poseparameter.lua")
	include("simfphys/server/joystick.lua")
end
	
if CLIENT then
	include("simfphys/base_functions.lua")
	include("simfphys/client/killicons.lua")
	include("simfphys/client/fonts.lua")
	include("simfphys/client/tab.lua")
	include("simfphys/client/hud.lua")
	include("simfphys/client/seatcontrols.lua")
	include("simfphys/client/lighting.lua")
	include("simfphys/client/damage.lua")
	include("simfphys/client/poseparameter.lua")
end

include("simfphys/anim.lua")
include("simfphys/base_lights.lua")
include("simfphys/base_vehicles.lua")
include("simfphys/view.lua")
include("simfphys/wheelpickup.lua")

timer.Simple( 0.5, function()
	include("simfphys/rescuespawnlists.lua")
end)