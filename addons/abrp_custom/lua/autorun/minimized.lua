
local esc = CreateConVar("game_focus_esc", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Whether to show the message when the client has their escape menu open.")
local msg = CreateConVar("game_focus_msg", "Minimized", {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "What the message should be above the AFK player's head")
if CLIENT then
	timer.Create("TabbedOut", 3, 0, function()
		if (not system.HasFocus()) or (gui.IsGameUIVisible() and esc:GetBool())then
			net.Start("Minimized")
				net.WriteBool(true)
			net.SendToServer()
		else
			net.Start("Minimized")
				net.WriteBool(false)
			net.SendToServer()
		end
	end)

	hook.Add( "PostDrawTranslucentRenderables", "DrawMinimized", function()
		for id,ply in pairs(player.GetAll()) do
			if not IsValid(ply) then continue end
			if ply == LocalPlayer() then continue end
			if not ply:Alive() then continue end
			if ply:Team() == TEAM_SPECTATOR then continue end

			if ply:GetNWBool("Minimized", false) then
				local lply = LocalPlayer()
				local alpha  = 255
				local alphat  = 150
			 	local distance = lply:GetPos():Distance(ply:GetPos())
				if distance >= 255 then return end
				if distance > 100 then
					alpha = 255 - (distance - 50)
					alphat = 150 - (distance - 100)
				end
				local Pos = ply:LocalToWorld(ply:OBBCenter()) + Vector(0, 0, 37)
				local planeNormal = Vector(0, 0, 0)
				local relativeEye = EyePos() - Pos
				local relativeEyeOnPlane = relativeEye - planeNormal * relativeEye:Dot(planeNormal)
				local textAng = relativeEyeOnPlane:AngleEx(planeNormal)

			  textAng:RotateAroundAxis(textAng:Up(), 90)
			  textAng:RotateAroundAxis(textAng:Forward(), 90)

				cam.Start3D2D(Pos, textAng, 0.02)
					surface.SetDrawColor( 0, 0, 0, alphat )
					surface.DrawRect(-(570 / 2), -120 + (110 * 1), 570, 100 )
					surface.SetDrawColor(2, 119, 189, alpha)
					surface.DrawRect(-(600 / 2), -120 + (110 * 1), 15, 100)
					surface.SetDrawColor( 2, 119, 189, alpha )
					surface.DrawRect((570 / 2), -120 + (110 * 1), 15, 100)
					draw.DrawText(msg:GetString(), "Calibri128_blur", 0, -130 + (110 * 1), Color(0, 0, 0, alpha), TEXT_ALIGN_CENTER)
					draw.DrawText(msg:GetString(), "Calibri128", 0, -130 + (110 * 1), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
				cam.End3D2D()
			end
		end
	end)
else
	util.AddNetworkString("Minimized")

	net.Receive("Minimized", function(len, ply)
		local isMinimized = net.ReadBool()
		ply:SetNWBool("Minimized", isMinimized)
	end)
end
