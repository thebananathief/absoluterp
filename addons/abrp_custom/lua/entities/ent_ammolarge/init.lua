-------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
-------------------------------
local blacklist = {8, 10, -1} --RPG,Nades,NoAmmoWeps

function ENT:Initialize()
	self:SetModel( "models/Items/ammocrate_smg1.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	phys:SetMass(35)

	self:SetNWInt("AmmClip", 10)
	self:StartSound()
	self:SetAttachments()
end

function ENT:SetAttachments()
	batt1 = ents.Create('prop_physics')
	batt1:SetModel( "models/Items/combine_rifle_cartridge01.mdl" )
	batt1:SetPos( self:GetPos() + Vector(-11.406, -19.313, 18.469) )
	batt1:SetAngles( self:GetAngles() + Angle(-45,180,0))
	batt1:Spawn()
	batt1:SetParent( self )
	batt1:SetCollisionGroup( COLLISION_GROUP_WORLD )

	batt2 = ents.Create('prop_physics')
	batt2:SetModel( "models/Items/combine_rifle_cartridge01.mdl" )
	batt2:SetPos( self:GetPos() + Vector(-11.406, 19.344, 18.469) )
	batt2:SetAngles( self:GetAngles() + Angle(-45,180,0))
	batt2:Spawn()
	batt2:SetParent( self )
	batt2:SetCollisionGroup( COLLISION_GROUP_WORLD )

	batt3 = ents.Create('prop_physics')
	batt3:SetModel( "models/props_combine/suit_charger001.mdl" )
	batt3:SetPos( self:GetPos() + Vector(15.063, 0.531, 0.219) )
	batt3:SetAngles( self:GetAngles() + Angle(0,0,90))
	batt3:Spawn()
	batt3:SetParent( self )
	batt3:SetCollisionGroup( COLLISION_GROUP_WORLD )

	batt4 = ents.Create('prop_physics')
	batt4:SetModel( "models/props_lab/reciever01b.mdl" )
	batt4:SetPos( self:GetPos() + Vector(-8.281, 0, 14) )
	batt4:SetAngles( self:GetAngles() + Angle(-45,0,0))
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
	if (caller:GetEyeTrace().Entity != self) then return end
	local atype = caller:GetActiveWeapon():GetPrimaryAmmoType()
	if table.HasValue(blacklist, atype) then DarkRP.notify(caller, 1, 4, "Take out a gun!") return end

	if IsValid(caller) and caller:IsPlayer() then
		local ammo = caller:GetActiveWeapon():GetMaxClip1()
		caller:GiveAmmo(ammo, atype)
		self:SetNWInt("AmmClip", self:GetNWInt("AmmClip", 10) - 1)
	end

	if self:GetNWInt("AmmClip", 10) < 1 then
		self:Remove()
	end
end

function ENT:OnRemove()
    local ch = self:GetChildren()
		for _,v in pairs(ch) do
			v:Remove()
		end
end
