AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


util.AddNetworkString("NET_APrinterAction")
util.AddNetworkString("NET_APrinterRefresh")

ENT.SeizeReward = 1000

function ENT:Initialize()
	self:SetModel(self.DarkRPItem.model)
	self:SetColor(self.DarkRPItem.color)
	self:SetMaterial(self.DarkRPItem.mat)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

	self.health = 100
	self.money = 0
	self.heat = 0
	self.prog = 0
	self.ininv = false
	self.overheating = false

	self:Print()
	self:Temp()
end

function UpdatePrinterInfo(printer)
	local info                 = {}
	info.health             =       printer.health
	info.money             =       printer.money
	info.heat                  =       printer.heat
	info.prog                  =       printer.prog
	info.name                =       printer.DarkRPItem.name
	info.overheating =       printer.overheating
	info.ininv                  =    printer.ininv

	net.Start('NET_APrinterRefresh')
		net.WriteEntity(printer)
		net.WriteTable(info)
	net.Broadcast()
end

function ENT:Print()
	timer.Create("printtimer"..self:EntIndex(), 0.1, 0, function() -- 1.4s for a single print
		self.prog = (self.prog + 1)

		if self.prog >= 100 then
			self.money = self.money +self.DarkRPItem.printa
			self.heat = self.heat + 10 -- Heat Gain (10 by default)
			if self.heat >= 100 then
				self.heat = 100
				self.overheating = true
				timer.Pause("printtimer"..self:EntIndex())
			end
			self.prog = 0
		end
		UpdatePrinterInfo(self)
	end)
end

function ENT:Temp()
	timer.Create("printtemp"..self:EntIndex(), 1.3, 0, function()
		if self.heat <= 0 then return end
		if self.overheating then
			self.heat = self.heat - 10
		else
			self.heat = self.heat - 1
		end
		UpdatePrinterInfo(self)
	end)
end

function ENT:Use(activator, caller)
	if not self:IsValid() and caller:IsValid() then return end
	if self.ininv then return end

	if self.overheating then
		if self.heat != 0 then
			return
		end
		timer.UnPause("printtimer"..self:EntIndex())
		self:EmitSound("UI/buttonclick.wav")
		DarkRP.notify(caller, 0, 5, "You restarted a printer.")
		self.overheating = false
	else
		if self.money <= 0 then return end
		if (caller:GetEyeTrace().Entity != self) then return end
		caller:addMoney(self.money)
		DarkRP.notify(caller, 3, 5, "You collected "..DarkRP.formatMoney(self.money).." from a printer.")
		self.money = 0
	end
	UpdatePrinterInfo(self)
end

function ENT:OnTakeDamage(dmg)
	self.health = self.health - dmg:GetDamage()
	if self.health <= 0 then
		self:BlowUp()
		self:Remove()
	end
	UpdatePrinterInfo(self)
end

function ENT:BlowUp()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end

function ENT:InvDoThing(action)
	if action == 1 then
		self.ininv = true
		timer.Pause("printtimer"..self:EntIndex())
		print("Printer put in inv")
	end
	if action == 0 then
		self.ininv = false
		timer.UnPause("printtimer"..self:EntIndex())
		print("Printer Dropped")
	end
	UpdatePrinterInfo(self)
end

function ENT:Think()
end

function ENT:OnRemove()
	timer.Remove("printtimer"..self:EntIndex())
	timer.Remove("printtemp"..self:EntIndex())
	if self.sound then
		self.sound:Stop()
	end
end
