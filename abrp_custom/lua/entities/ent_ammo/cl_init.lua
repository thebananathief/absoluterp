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

		local Pos = self:LocalToWorld(self:OBBCenter()) + Vector(0, 0, 15)
    local planeNormal = Vector(0, 0, 0)
    local relativeEye = EyePos() - Pos
    local relativeEyeOnPlane = relativeEye - planeNormal * relativeEye:Dot(planeNormal)
    local textAng = relativeEyeOnPlane:AngleEx(planeNormal)

    textAng:RotateAroundAxis(textAng:Up(), 90)
    textAng:RotateAroundAxis(textAng:Forward(), 90)

		cam.Start3D2D(Pos, textAng, 0.02)
					surface.SetDrawColor( 0, 0, 0, alphat )
					surface.DrawRect(-(1000 / 2), -120 + (110 * 2), 1000, 100 )
					surface.SetDrawColor(2, 119, 189, alpha)
					surface.DrawRect(-(1030 / 2), -120 + (110 * 2), 15, 100)
					surface.SetDrawColor( 2, 119, 189, alpha )
					surface.DrawRect((1000 / 2), -120 + (110 * 2), 15, 100)
					draw.DrawText("Universal Ammo", "Calibri128_blur", 0, -130 + (110 * 2), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
					draw.DrawText("Universal Ammo", "Calibri128", 0, -130 + (110 * 2), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

function ENT:Think()
end
