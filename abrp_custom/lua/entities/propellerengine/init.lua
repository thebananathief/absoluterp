AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

CreateConVar("propeller_engine_damage", 0, FCVAR_ARCHIVE)

concommand.Add("_propeller_engine_yaw", function(ply, command, args)
	local self = ply.propellerengine
	if not IsValid(self) then return end
	self.clientyaw = tonumber(args[1])
	if game.SinglePlayer() or self.ply:Alive() then
		self.bump = self:GetColliding()
	end
end)

hook.Add("PlayerSay","EquipChat",function(ply, text)
		if ( string.lower( text ) == "/equip" ) then
			if not (ply.authorized) then ply:SendLua("chat.AddText(Color(255,255,255),'You must own a propeller engine to equip it.')") return "" end
			scripted_ents.Get("propellerengine"):SpawnFunction(ply)
			return ""
		elseif ( string.lower( text ) == "/unequip" ) then
			if not (ply.authorized) then ply:SendLua("chat.AddText(Color(255,255,255),'You must own a propeller engine to equip it.')") return "" end
			local self = ply.propellerengine
			if IsValid(self) then
				self:Remove()
			end
			return ""
		end
end)

hook.Add("PlayerFootstep", "PropellerEngine:PlayerFootstep", function(ply)
	local self = ply.propellerengine
	if not IsValid(self) then return end

	ply.pefootsteps = ply.pefootsteps or 0

	ply.pefootsteps = ply.pefootsteps + 1

	if ply.pefootsteps == 3 then
		self.dt.engineoff = true
		local volume = math.Clamp(ply:GetInfoNum("propeller_engine_idle_sound_volume", 0),0,1)*100
		if volume > 0 then self:EmitSound("vehicles/airboat/fan_motor_shut_off1.wav", volume, math.random(90,110)) end
	end
end)

function ENT:SpawnFunction( ply )
	if ply.propellerengine then return end

	local self = ents.Create("propellerengine")
	self.ply = ply
	ply.propellerengine = self

	self:SetOwner(ply)
	self:SetPos(ply:GetPos())
	self:Spawn()
	self:Activate()
	self:SetParent(ply)
	self:SetModel("models/props_junk/PopCan01a.mdl")
	self:SetNoDraw(true)

	self.smooththrust = 0

	return self
end

function ENT:Initialize()
	self.dt.ply = self.ply
	self.speed = 0
	self.clientyaw = 0
end

function ENT:Think()

	self:GetZVelocity()

	local ply = self.ply

	self.dt.playerpitch = ply:EyeAngles().p

	if not IsValid(ply) or not IsValid(self.ply.propellerengine) then self:Remove() return end

	local vehicle = ply:GetVehicle()
	local phys = IsValid(vehicle) and vehicle:GetPhysicsObject()

	self.dt.isthrusting = false

	local thrust = 0
	local pitch = 0
	local roll = 0

	if not self.bumped and (phys or ply:GetMoveType() ~= MOVETYPE_NOCLIP) then
		if ply:KeyDown(IN_WALK) then
		thrust = thrust + 10
			pitch = pitch + 55
			self.dt.isthrusting = true
			self.dt.engineoff = false
		elseif ply:KeyDown(IN_JUMP) then
			//thrust = thrust + 20
			//pitch = pitch + 120
			thrust = thrust + 10
			pitch = pitch + 70
			self.dt.isthrusting = true
			self.dt.engineoff = false
		elseif ply:KeyDown(IN_SPEED) and not ply:OnGround() then
			thrust = thrust + 15
			pitch = pitch + 100
			self.dt.isthrusting = true
			self.dt.engineoff = false
		end
		thrust = ply:KeyDown(IN_USE) and -thrust or thrust
	end

	ply.pefootsteps = self.dt.isthrusting and 0 or ply.pefootsteps or 0

	self.dt.pitch = pitch

	self.smooththrust = Lerp(FrameTime()*3,self.smooththrust,thrust)

	self.dt.thrust = self.smooththrust

	if phys then phys:AddVelocity(ply:EyeAngles():Up() * self:GetThrust() ) end

	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	self.ply.propellerengine = false
end

hook.Add("PlayerDeath", "PropellerEngine:AuthExp", function(ply)
	ply.authorized = false
	local self = ply.propellerengine
	if IsValid(self) then
		self:Remove()
	end
end)
