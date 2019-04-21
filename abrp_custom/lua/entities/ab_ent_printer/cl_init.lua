include("shared.lua")
function ReceivePrinterInfo()
	local printer    	 =       net.ReadEntity()
	local info        	 =       net.ReadTable()

	printer.health             =       info.health
	printer.money             =       info.money
	printer.heat                  =       info.heat
	printer.prog                  =       info.prog
	printer.name                =        info.name
	printer.overheating =      info.overheating
                 printer.ininv                  =    info.ininv
end
net.Receive('NET_APrinterRefresh', ReceivePrinterInfo)

function ENT:Initialize()
	self.name = ""
	self.health = 100
	self.money = 0
	self.heat     = 0
	self.prog     = 0
                 self.ininv = false
	self.overheating = false
	self.smoothprog = 0
	self.smoothheat = 0
	self.smoothmoney = 0
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

    local owner = self:Getowning_ent()
    owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

    local Pos = self:LocalToWorld(self:OBBCenter()) + Vector(0, 0, 25)
    local planeNormal = Vector(0, 0, 0)
    local relativeEye = EyePos() - Pos
    local relativeEyeOnPlane = relativeEye - planeNormal * relativeEye:Dot(planeNormal)
    local textAng = relativeEyeOnPlane:AngleEx(planeNormal)

    textAng:RotateAroundAxis(textAng:Up(), 90)
    textAng:RotateAroundAxis(textAng:Forward(), 90)

    self.smoothheat = Lerp(0.05, self.smoothheat, (self.heat * 10)) -- Lerped Heat
    self.smoothprog = Lerp(0.3, self.smoothprog, (self.prog * 10)) -- Lerped Progress
    self.smoothmoney = Lerp(0.05, self.smoothmoney, self.money) -- Lerped Money

    cam.Start3D2D(Pos, textAng, 0.02)
    	draw.DrawText(owner.."'s "..self.name, "Calibri128_blur",  0, -130, Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
    	draw.DrawText(owner.."'s "..self.name, "Calibri128",  0, -130, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)

		surface.SetDrawColor(0, 0, 0, alphat)
		surface.DrawRect(-(970 / 2), -10, 1000, 100)
		surface.SetDrawColor(255, 170, 0, alpha)
		surface.DrawRect(-(970 / 2), -10, self.smoothheat, 100)
		surface.SetDrawColor(255, 100, 0, alpha)
		surface.DrawRect(-(1000 / 2), -10, 15, 100)
	if self.overheating and self.heat <= 0 then
    		draw.DrawText("Press 'E' to restart.", "Calibri128_blur",  0, -130 + (110 *1), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
    		draw.DrawText("Press 'E' to restart.", "Calibri128",  0, -130 + (110 *1), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
	else
    		draw.DrawText("Heat: "..self.heat, "Calibri128_blur",  0, -130 + (110 *1), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
    		draw.DrawText("Heat: "..self.heat, "Calibri128",  0, -130 + (110 *1), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
    	end

		surface.SetDrawColor(0, 0, 0, alphat)
		surface.DrawRect(-(970 / 2), -10 + 110, 1000, 100)
		surface.SetDrawColor(22, 139, 209, alpha)
		surface.DrawRect(-(970 / 2), -10 + 110, self.smoothprog, 100)
		surface.SetDrawColor(2, 119, 189, alpha)
		surface.DrawRect(-(1000 / 2), -10 + 110, 15, 100)
    	draw.DrawText("Prog: "..self.prog.."%", "Calibri128_blur",  0, -130 + (110 *2), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
    	draw.DrawText("Prog: "..self.prog.."%", "Calibri128",  0, -130 + (110 *2), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)

		surface.SetDrawColor(0, 0, 0, alphat)
		surface.DrawRect(-(970 / 2), -10 + 110 * 2, 1000, 100)
		surface.SetDrawColor(130, 255, 0, alpha)
		surface.DrawRect(-(1000 / 2), -10 + 110 * 2, 15, 100)
    	draw.DrawText("Money: "..DarkRP.formatMoney(math.Round(self.smoothmoney)), "Calibri128_blur",  0, -130 + (110 *3), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
    	draw.DrawText("Money: "..DarkRP.formatMoney(math.Round(self.smoothmoney)), "Calibri128",  0, -130 + (110 *3), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

function PrinterHover()
    local ply = LocalPlayer()
    local trace = ply:GetEyeTrace().Entity
		local text = ""
    if trace.ininv then return end

    if trace:IsValid() and trace:GetClass() == "ab_ent_printer" and trace:GetPos():Distance(ply:GetPos()) < 200 then
			if trace.overheating then
				text = "Press 'E' to restart printer."
			else
				text = "Press 'E' to collect "..DarkRP.formatMoney(math.Round(trace.smoothmoney)).."."
			end
			draw.DrawText(text, "ChatFont", (ScrW()/2), (ScrH()/2) + 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end
end
hook.Add("HUDPaint", "PrinterHover", PrinterHover)

function ENT:Think()
end
