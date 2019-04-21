-------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
-------------------------------
local blacklist = {8, 10, -1} --RPG,Nades,NoAmmoWeps

function ENT:Initialize()
	self:SetModel( "models/Items/BoxMRounds.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	phys:SetMass(15)

	self:StartSound()
	self:SetAttachments()
end

function ENT:SetAttachments()
	batt1 = ents.Create('prop_physics')
	batt1:SetModel( "models/Items/battery.mdl" )
	batt1:SetPos( self:GetPos() + Vector(5, -8.594, 9.094) )
	batt1:SetAngles( self:GetAngles() + Angle(0,-90,90))
	batt1:Spawn()
	batt1:SetParent( self )
	batt1:SetCollisionGroup( COLLISION_GROUP_WORLD )

	batt2 = ents.Create('prop_physics')
	batt2:SetModel( "models/Items/battery.mdl" )
	batt2:SetPos( self:GetPos() + Vector(5, -8.594, 4.188) )
	batt2:SetAngles( self:GetAngles() + Angle(0,-90,90))
	batt2:Spawn()
	batt2:SetParent( self )
	batt2:SetCollisionGroup( COLLISION_GROUP_WORLD )

	batt3 = ents.Create('prop_physics')
	batt3:SetModel( "models/Items/battery.mdl" )
	batt3:SetPos( self:GetPos() + Vector(5, 8.594, 4.156) )
	batt3:SetAngles( self:GetAngles() + Angle(0,90,-90))
	batt3:Spawn()
	batt3:SetParent( self )
	batt3:SetCollisionGroup( COLLISION_GROUP_WORLD )

	batt4 = ents.Create('prop_physics')
	batt4:SetModel( "models/Items/battery.mdl" )
	batt4:SetPos( self:GetPos() + Vector(5, 8.594, 9.013) )
	batt4:SetAngles( self:GetAngles() + Angle(0,90,-90))
	batt4:Spawn()
	batt4:SetParent( self )
	batt4:SetCollisionGroup( COLLISION_GROUP_WORLD )
end

function ENT:StartSound()
    self.sound = CreateSound(self, Sound("items/spawn_item.wav"))
    self.sound:SetSoundLevel(60)
    self.sound:PlayEx(0.2, 100)
end

function ENT:Use(activator, caller)
	local atype = caller:GetActiveWeapon():GetPrimaryAmmoType()
	if blacklist[atype] then DarkRP.notify(caller, 1, 4, "Take out a gun!") return end

	if IsValid(caller) and caller:IsPlayer() then
		local ammo = 0
		if caller:GetActiveWeapon():GetMaxClip1() > 0 then
			ammo = caller:GetActiveWeapon():GetMaxClip1()
		else
			ammo = 1
		end
		caller:GiveAmmo(ammo, atype)
	end

	self:Remove()
end

function ENT:OnRemove()
    local ch = self:GetChildren()
		for _,v in pairs(ch) do
			v:Remove()
		end
end
