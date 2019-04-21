-------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
-------------------------------
function ENT:Initialize()
	self:SetModel( "models/props_c17/oildrum001.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	phys:SetMass(35)

	self:SetAttachments()
	self.turrethp = 500
	timer.Create("TurretHPRegen"..self:EntIndex(),0.5,0,function()
		if self.turrethp < 500 then
			self.turrethp = self.turrethp + 1
		end
	end)
end

function ENT:SetAttachments()/*
	base = ents.Create('prop_physics')
	base:SetModel( "models/props_trainstation/trainstation_post001.mdl" )
	base:SetPos( self:GetPos() + Vector(-0.375, -2.381, 7.404) )
	base:SetAngles( self:GetAngles() + Angle(45.000, 90, 0))
	base:Spawn()
	base:SetParent( self )
	base:SetCollisionGroup( COLLISION_GROUP_WORLD )

	wand = ents.Create('prop_physics')
	wand:SetModel( "models/props_wasteland/prison_lamp001c.mdl" )
	wand:SetPos( self:GetPos() + Vector(-0.438, 36.377, 38.715) )
	wand:SetAngles( self:GetAngles() + Angle(0,0,0))
	wand:Spawn()
	wand:SetParent( self )
	wand:SetCollisionGroup( COLLISION_GROUP_WORLD )*/
end

function ENT:UpdateModel()
	if not self:IsValid() then return end
	//if self.sound then self.sound:Stop() end
end

function ENT:StartSound()
    self.sound = CreateSound(self, Sound("ambient/machines/machine3.wav"))
    self.sound:SetSoundLevel(60)
    self.sound:PlayEx(1, 85)
end

function ENT:Use(activator, caller)
	if (caller:GetEyeTrace().Entity != self) then return end
	self:UpdateModel()
end

function ENT:ShootBullet( damage, num_bullets, aimcone )

	local bullet = {}
	bullet.Num 	= num_bullets
	bullet.Src 	= self.Owner:GetShootPos() -- Source
	bullet.Dir 	= self.Owner:GetAimVector() -- Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )	-- Aim Cone
	bullet.Tracer	= 5 -- Show a tracer on every x bullets
	bullet.Force	= 1 -- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"

	self.Owner:FireBullets( bullet )

	self:ShootEffects()

end

function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)

    self.turrethp = (self.turrethp or 500) - dmg:GetDamage()
    if self.turrethp <= 0 then
        self:Destruct()
        self:Remove()
    end
end

function ENT:Destruct()
    local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetStart(vPoint)
    effectdata:SetOrigin(vPoint)
    effectdata:SetScale(1)
    util.Effect("Explosion", effectdata)
end

hook.Add("GravGunOnDropped", "Keepupright",function(ply, ent)
	local Ang = ent:GetAngles()

	if Ang != Angle(0,Ang.y,0) and ent:GetClass() == "ent_turret" then
		ent:SetAngles(Angle(0,Ang.y,0))
	end
end)

function ENT:OnRemove()
    if self.sound then self.sound:Stop() end
		timer.Remove("TurretHPRegen"..self:EntIndex())
end
