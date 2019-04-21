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

		local owner = self:Getowning_ent()
    owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	cam.Start3D2D(Pos, textAng, 0.02)
			surface.SetDrawColor( 0, 0, 0, alphat )
			surface.DrawRect(-(1000 / 2), -120 + (110 * 1), 1000, 100 )
			surface.SetDrawColor(2, 119, 189, alpha)
			surface.DrawRect(-(1030 / 2), -120 + (110 * 1), 15, 100)
			surface.SetDrawColor( 2, 119, 189, alpha )
			surface.DrawRect((1000 / 2), -120 + (110 * 1), 15, 100)
			draw.DrawText(owner.."'s", "Calibri128_blur", 0, -130 + (110 * 1), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
			draw.DrawText(owner.."'s", "Calibri128", 0, -130 + (110 * 1), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)

			surface.SetDrawColor( 0, 0, 0, alphat )
			surface.DrawRect(-(1000 / 2), -120 + (110 * 2), 1000, 100 )
			surface.SetDrawColor(2, 119, 189, alpha)
			surface.DrawRect(-(1030 / 2), -120 + (110 * 2), 15, 100)
			surface.SetDrawColor( 2, 119, 189, alpha )
			surface.DrawRect((1000 / 2), -120 + (110 * 2), 15, 100)
			draw.DrawText("Tip Jar", "Calibri128_blur", 0, -130 + (110 * 2), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
			draw.DrawText("Tip Jar", "Calibri128", 0, -130 + (110 * 2), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)

			surface.SetDrawColor( 0, 0, 0, alphat )
			surface.DrawRect(-(1000 / 2), -120 + (110 * 3), 1000, 100 )
			surface.SetDrawColor(2, 119, 189, alpha)
			surface.DrawRect(-(1030 / 2), -120 + (110 * 3), 15, 100)
			surface.SetDrawColor( 2, 119, 189, alpha )
			surface.DrawRect((1000 / 2), -120 + (110 * 3), 15, 100)
			draw.DrawText(DarkRP.formatMoney(self:GetNWInt("Money")), "Calibri128_blur", 0, -130 + (110 * 3), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
			draw.DrawText(DarkRP.formatMoney(self:GetNWInt("Money")), "Calibri128", 0, -130 + (110 * 3), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function TipMenu()
	local ply = net.ReadEntity()
	local tipjar = net.ReadEntity()

	local base = vgui.Create("DFrame")
	base:SetSize(100, 100)
	base:SetSkin("DarkRP")
	base:Center()
	base:ShowCloseButton(true)
	base:MakePopup()
	base:SetTitle("Tip Jar")

	local value = vgui.Create("DTextEntry", base)
	value:Center()
	value:RequestFocus()
	value:SetText("0")
	value:SelectAllText()
	value:SetNumeric(true)

	local bsubmit = vgui.Create("DButton", base)
	bsubmit:SetSize(50, 20)
	bsubmit:SetPos(25, 80)
	bsubmit:SetText("Tip!")
	bsubmit.DoClick = function()
		net.Start("NET_tipaction")
			net.WriteEntity(ply)
			net.WriteEntity(tipjar)
			net.WriteInt(value:GetValue(), 32)
		net.SendToServer()
		base:Remove()
	end
end
net.Receive("NET_tipmenu", TipMenu)

function ENT:Think()
end

function TipHover()
	local ply = LocalPlayer()
	local trace = ply:GetEyeTrace().Entity
	if trace:IsValid() and trace:GetClass() == "ent_tip" and trace:GetPos():Distance(ply:GetPos()) < 100 then
		if LocalPlayer() == trace:CPPIGetOwner() then
			draw.DrawText("Press 'E' to collect tips.", "ChatFont", (ScrW()/2), (ScrH()/2) + 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		else
			draw.DrawText("Press 'E' to leave a tip.", "ChatFont", (ScrW()/2), (ScrH()/2) + 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
	end
end
hook.Add("HUDPaint", "TipHover", TipHover)
