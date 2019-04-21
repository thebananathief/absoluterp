-------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
-------------------------------
local blacklist = {8, 10, -1} --RPG,Nades,NoAmmoWeps

function ENT:Initialize()
	self:SetModel( "models/props_c17/FurnitureWashingmachine001a.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	phys:SetMass(35)

	self:SetNWInt("Ammo", 0)
	self:StartSound()
	self:SetAttachments()
	self:AmmoAdd()
end

function ENT:AmmoAdd()
	timer.Create("AmmoAdd"..self:EntIndex(), 1, 0, function()
		//if self:GetNWInt("Ammo") > 119 then return end
		self:SetNWInt("Ammo", self:GetNWInt("Ammo") + 1)
		self:UpdateModel()
	end)
end

function ENT:SetAttachments()
	basket = ents.Create('prop_physics')
	basket:SetModel( "models/props_junk/PlasticCrate01a.mdl" )
	basket:SetPos( self:GetPos() + Vector(-0.094, 13.75, 0.031) )
	basket:SetAngles( self:GetAngles() + Angle(45,90,0))
	basket:Spawn()
	basket:SetParent( self )
	basket:SetCollisionGroup( COLLISION_GROUP_WORLD )

	box = ents.Create('prop_physics')
	box:SetModel( "models/Items/BoxMRounds.mdl" )
	box:SetPos( self:GetPos() + Vector(-0.062, -19.5, -6.594) )
	box:SetAngles( self:GetAngles() + Angle(0,90,0))
	box:Spawn()
	box:SetParent( self )
	box:SetCollisionGroup( COLLISION_GROUP_WORLD )
	box:SetRenderMode(RENDERMODE_TRANSALPHA)
	box:SetColor(Color(0,0,0,0))

	smallbox = ents.Create('prop_physics')
	smallbox:SetModel( "models/Items/BoxSRounds.mdl" )
	smallbox:SetPos( self:GetPos() + Vector(2.719, 15.813, -5.781) )
	smallbox:SetAngles( self:GetAngles() + Angle(45,90,0))
	smallbox:Spawn()
	smallbox:SetParent( self )
	smallbox:SetCollisionGroup( COLLISION_GROUP_WORLD )
	smallbox:SetRenderMode(RENDERMODE_TRANSALPHA)
	smallbox:SetColor(Color(0,0,0,0))

	medbox = ents.Create('prop_physics')
	medbox:SetModel( "models/Items/combine_rifle_cartridge01.mdl" )
	medbox:SetPos( self:GetPos() + Vector(-7.875, 19.313, 0.938) )
	medbox:SetAngles( self:GetAngles() + Angle(-30,-60,-45))
	medbox:Spawn()
	medbox:SetParent( self )
	medbox:SetCollisionGroup( COLLISION_GROUP_WORLD )
	medbox:SetRenderMode(RENDERMODE_TRANSALPHA)
	medbox:SetColor(Color(0,0,0,0))

	largebox = ents.Create('prop_physics')
	largebox:SetModel( "models/Items/357ammo.mdl" )
	largebox:SetPos( self:GetPos() + Vector(5.719, 19.25, 1.5) )
	largebox:SetAngles( self:GetAngles() + Angle(-45,90,0))
	largebox:Spawn()
	largebox:SetParent( self )
	largebox:SetCollisionGroup( COLLISION_GROUP_WORLD )
	largebox:SetRenderMode(RENDERMODE_TRANSALPHA)
	largebox:SetColor(Color(0,0,0,0))
end

function ENT:UpdateModel()
	if not self:IsValid() then return end

	if self:GetNWInt("Ammo") < 50 then
		smallbox:SetColor(Color(0,0,0,0))
	else
		smallbox:SetColor(Color(255,255,255,255))
	end

	if self:GetNWInt("Ammo") < 150 then
		medbox:SetColor(Color(0,0,0,0))
	else
		medbox:SetColor(Color(255,255,255,255))
	end

	if self:GetNWInt("Ammo") < 250 then
		largebox:SetColor(Color(0,0,0,0))
	else
		largebox:SetColor(Color(255,255,255,255))
	end

	if self:GetNWInt("Ammo") < 500 then
		box:SetColor(Color(0,0,0,0))
	else
		box:SetColor(Color(255,255,255,255))
	end
end

function ENT:StartSound()
    self.sound = CreateSound(self, Sound("ambient/machines/transformer_loop.wav"))
    self.sound:SetSoundLevel(60)
    self.sound:PlayEx(1, 85)
end

function ENT:Use(activator, caller)
	local Pos = self:GetPos() + Vector(0,0,10)
	local trace = { start = self:GetPos(), endpos = self:GetPos()}
	local tr = util.TraceEntity(trace,self)
	local atype = caller:GetActiveWeapon():GetPrimaryAmmoType()
	if (caller:GetEyeTrace().Entity != self) then return end
	if table.HasValue(blacklist, atype) then DarkRP.notify(caller, 1, 4, "Take out a gun!") return end
	self:UpdateModel()

	if IsValid(caller) and caller:IsPlayer() then
		if self:GetNWInt("Ammo") < 1 then return end

		local ammo = math.Clamp(caller:GetActiveWeapon():GetMaxClip1(), 1, self:GetNWInt("Ammo"))
		caller:GiveAmmo(ammo, atype)
		self:SetNWInt("Ammo", self:GetNWInt("Ammo") - ammo)
	end
end

function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)

    self.damage = (self.damage or 100) - dmg:GetDamage()
    if self.damage <= 0 then
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

	if Ang != Angle(0,Ang.y,0) and ent:GetClass() == "ent_amfab" then
		ent:SetAngles(Angle(0,Ang.y,0))
	end
end)

function ENT:OnRemove()
    if self.sound then
        self.sound:Stop()
    end
    timer.Remove("AmmoAdd"..self:EntIndex())
		local ch = self:GetChildren()
		for _,v in pairs(ch) do
			v:Remove()
		end
end
