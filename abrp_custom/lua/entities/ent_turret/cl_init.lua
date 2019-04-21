include('shared.lua')

function ENT:Initialize()
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

	local Pos = self:LocalToWorld(self:OBBCenter()) + Vector(0, 0, 30)
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
    draw.DrawText("Turret", "Calibri128_blur", 0, -130 + (110 * 2), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
    draw.DrawText("Turret", "Calibri128", 0, -130 + (110 * 2), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
  cam.End3D2D()
end

function GunfabHover()
	local ply = LocalPlayer()
	local trace = ply:GetEyeTrace().Entity
	local text = ""
	if trace:IsValid() and trace:GetClass() == "ent_turret" and trace:GetPos():Distance(ply:GetPos()) < 130 then
		draw.DrawText("Press 'E' to configure friends.", "ChatFont", (ScrW()/2), (ScrH()/2) + 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
end
hook.Add("HUDPaint", "GunfabHover", GunfabHover)

function ENT:Think()
end
