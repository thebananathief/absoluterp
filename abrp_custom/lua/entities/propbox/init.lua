-------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
-------------------------------
function ENT:Initialize()
	self:SetModel( "models/props_c17/TrapPropeller_Engine.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	phys:SetMass(35)
end

function ENT:Use(activator, caller)
	if (caller:GetEyeTrace().Entity != self) then return end
	if caller.authorized then caller:SendLua("chat.AddText(Color(255,255,255),'You already have an engine equipped! Type ',Color(2, 119, 189),'/equip ',Color(255,255,255),'or ',Color(1, 203, 102),'/unequip ',Color(255,255,255),'in the chat to use it.')") return end

	if IsValid(caller) and caller:IsPlayer() then
		caller.authorized = true
	end

	caller:SendLua("chat.AddText(Color(255,255,255),'Type ',Color(2, 119, 189),'/equip ',Color(255,255,255),'or ',Color(1, 203, 102),'/unequip ',Color(255,255,255),'in the chat to use your engine.')")

	self:Remove()
end
