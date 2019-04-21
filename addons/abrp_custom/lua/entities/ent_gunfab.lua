AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Gun Fabricator"
ENT.Author = "TheBananaThief"
ENT.Category = "DarkRP"
ENT.Spawnable = true
ENT.AdminSpawnable = true

local tierOneGuns = {
	"weapon_ut99_biorifle",
	"weapon_ut99_enforcer",
	"weapon_ut99_flak",
	"weapon_ut99_impacthammer",
	"weapon_ut99_minigun",
	"weapon_ut99_pulsegun",
	"weapon_ut99_redeemer",
	"weapon_ut99_ripper",
	"weapon_ut99_eight",
	"weapon_ut99_shock",
	"weapon_ut99_rifle",
	"weapon_beam",
	"weapon_slam",
	"weapon_cangun",
	"weapon_nomad",
	"weapon_asmd"}

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "price")
    self:NetworkVar("Entity", 0, "owning_ent")

    self:NetworkVar("Int", 1, "CreateCost")
    self:NetworkVar("Bool", 1, "creating")
    self:NetworkVar("Int", 2, "prog")

    if SERVER then
      self:SetCreateCost( 1000 )
      self:Setcreating( false )
      self:Setprog(0)
    end
end

if SERVER then
	function ENT:Initialize()
		self:SetModel( "models/props_lab/reciever_cart.mdl" )
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then phys:Wake() end
		phys:SetMass(35)

	  local function SetAttachments()
	  	base = ents.Create('prop_physics')
	  	base:SetModel( "models/props_trainstation/trainstation_post001.mdl" )
	  	base:SetPos( self:GetPos() + Vector(-0.375, -2.381, 7.404) )
	  	base:SetAngles( self:GetAngles() + Angle(45.000, 90, 0))
	  	base:Spawn()
	  	base:SetParent( self )
	  	base:SetCollisionGroup( COLLISION_GROUP_WORLD )
	  end
		//SetAttachments()
	end

	function ENT:Start()
	  local function CreateGun()
	    local wep = ents.Create(tierOneGuns[math.random(#tierOneGuns)])
	  	local weapon = ents.Create("spawned_weapon")
	  	weapon:SetModel(wep:GetWeaponWorldModel())
	  	weapon:SetWeaponClass(wep:GetClass())
	  	weapon:SetPos(self:LocalToWorld(self:OBBCenter() + Vector(20, 5, -18)))
	  	weapon:SetAngles(self:GetAngles()+Angle(0,90,0))
			weapon.clip1 = wep.clip1
			weapon.clip2 = wep.clip2
	    weapon.ammoadd = wep.ammoadd or 0
	  	weapon.nodupe = true
	  	weapon:Spawn()
	  	weapon.dt.amount = 1
	  end

		self:Setcreating( true )
	  self:SoundUpdate()
		timer.Create("guntimer"..self:EntIndex(), 0.01, 0, function() -- 1.4s
	    self:Setprog(self:Getprog()+1)

			if self:Getprog() >= 100 then
				self:Setprog(0)
				CreateGun()
				self:Setcreating( false )
	      self:EmitSound("buttons/weapon_confirm.wav")
	    	self:SoundUpdate()
				timer.Remove("guntimer"..self:EntIndex())
			end
		end)
	end

	function ENT:SoundUpdate()
		if not self:IsValid() then return end
		if self:Getcreating() then
	    self.sound = CreateSound(self, Sound("ambient/machines/machine3.wav"))
	    self.sound:SetSoundLevel(60)
	    self.sound:PlayEx(1, 85)
		else
			if self.sound then self.sound:Stop() end
		end
	end

	function ENT:Use(activator, caller)
		if self:Getcreating() then DarkRP.notify(caller, 1, 4, "A fabrication is in progress!") return end

		if caller:canAfford(self:GetCreateCost()) then
			caller:addMoney(-self:GetCreateCost())
	  	DarkRP.notify(caller, 2, 5, "You inserted "..DarkRP.formatMoney(self:GetCreateCost()).." into the gun fabricator.")
	  	self:Start()
		end
	end

	function ENT:OnTakeDamage(dmg)
	    self:TakePhysicsDamage(dmg)
	    self.health = (self.health or 100) - dmg:GetDamage()
	    if self.health <= 0 then
	        self:Destruct()
	    end
	end

	function ENT:Destruct()
	    local vPoint = self:GetPos()
	    local effectdata = EffectData()
	    effectdata:SetStart(vPoint)
	    effectdata:SetOrigin(vPoint)
	    effectdata:SetScale(1)
	    util.Effect("Explosion", effectdata)
	    self:Remove()
	end

	function ENT:OnRemove()
	    if self.sound then self.sound:Stop() end
			timer.Remove("guntimer"..self:EntIndex())
			local ch = self:GetChildren()
			for _,v in pairs(ch) do
				v:Remove()
			end
	end
end

if CLIENT then
  function ENT:Initialize()
      self.smoothprog = 0
  end
  function ENT:Draw()
  		local ply = LocalPlayer()
      local distance = ply:GetPos():Distance(self:GetPos())
      if distance >= 2048 then
  			self:DrawShadow(false)
  			self:DestroyShadow()
  			return
  		else
  			self:DrawModel()
  		end
      local alpha  = 255
      local alphat  = 150
      if distance > 100 then
      	alpha = 255 - (distance - 50)
      	alphat = 150 - (distance - 100)
      end

  	self.smoothprog = Lerp(0.3, self.smoothprog, (self:Getprog() * 10))

  	local Pos = self:LocalToWorld(self:OBBCenter() + Vector(0, 5, 45))
    local planeNormal = Vector(0, 0, 0)
    local relativeEye = EyePos() - Pos
    local relativeEyeOnPlane = relativeEye - planeNormal * relativeEye:Dot(planeNormal)
    local textAng = relativeEyeOnPlane:AngleEx(planeNormal)

    textAng:RotateAroundAxis(textAng:Up(), 90)
    textAng:RotateAroundAxis(textAng:Forward(), 90)

    local owner = self:Getowning_ent()
    owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

  	cam.Start3D2D(Pos, textAng, 0.02)
    	surface.SetDrawColor( 0, 0, 0, alphat )
      surface.DrawRect(-(1150 / 2), -120 + (110 * 1), 1150, 100 )
      surface.SetDrawColor(2, 119, 189, alpha)
      surface.DrawRect(-(1180 / 2), -120 + (110 * 1), 15, 100)
      surface.SetDrawColor( 2, 119, 189, alpha )
      surface.DrawRect((1150 / 2), -120 + (110 * 1), 15, 100)
      draw.DrawText(owner.."'s", "Calibri128_blur", 0, -130 + (110 * 1), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
      draw.DrawText(owner.."'s", "Calibri128", 0, -130 + (110 * 1), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)

      surface.SetDrawColor( 0, 0, 0, alphat )
      surface.DrawRect(-(1150 / 2), -120 + (110 * 2), 1150, 100 )
      surface.SetDrawColor(2, 119, 189, alpha)
      surface.DrawRect(-(1180 / 2), -120 + (110 * 2), 15, 100)
      surface.SetDrawColor( 2, 119, 189, alpha )
      surface.DrawRect((1150 / 2), -120 + (110 * 2), 15, 100)
      draw.DrawText("Gun Fabricator", "Calibri128_blur", 0, -130 + (110 * 2), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
      draw.DrawText("Gun Fabricator", "Calibri128", 0, -130 + (110 * 2), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)

  		surface.SetDrawColor(0, 0, 0, alphat)
  		surface.DrawRect(-(1150 / 2), -120 + (110 * 3), 1150, 100)
  		surface.SetDrawColor(3, 161, 252, alpha)
  		surface.DrawRect(-(1150 / 2), -120 + (110 * 3), self.smoothprog, 100)
  		surface.SetDrawColor(2, 119, 189, alpha)
  		surface.DrawRect(-(1180 / 2), -120 + (110 * 3), 15, 100)
  		surface.SetDrawColor(2, 119, 189, alpha)
  		surface.DrawRect((1150 / 2), -120 + (110 * 3), 15, 100)
  	 	draw.DrawText("Progress: "..self:Getprog().."%", "Calibri128_blur",  0, -130 + (110 *3), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
  		draw.DrawText("Progress: "..self:Getprog().."%", "Calibri128",  0, -130 + (110 *3), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
    cam.End3D2D()
  end
end
