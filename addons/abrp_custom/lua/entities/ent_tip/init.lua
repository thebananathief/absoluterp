util.AddNetworkString("NET_tipmenu")
util.AddNetworkString("NET_tipaction")
local model = "models/props_lab/jar01a.mdl"
-------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
-------------------------------

function ENT:Initialize()
	self:SetModel( model )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:CPPISetOwner(self.dt.owning_ent)
	self:SetNWInt("Money", 0)
end

function ENT:Use(activator, caller)
	if self.dt.owning_ent == caller then
		caller:addMoney(self:GetNWInt("Money"))		
		self:SetNWInt("Money", 0)
	else
		net.Start("NET_tipmenu")
			net.WriteEntity(caller)
			net.WriteEntity(self)
		net.Send(caller)
	end
end

function LeaveTip()
    local ply = net.ReadEntity()
    local self = net.ReadEntity()
    local amount = net.ReadInt(32)
    if amount <= 0 then return end
    if ply:getDarkRPVar("money") < amount then return end

    ply:addMoney(-amount)
    self:SetNWInt("Money", self:GetNWInt("Money") + amount)
end
net.Receive("NET_tipaction", LeaveTip)

function ENT:Think()

end
