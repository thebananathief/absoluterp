local EntList = {
  spawned_weapon = {halo=true},
  ent_ammo = {halo=true, text="Press 'E' to pick up this ammo box."},
  spawned_shipment = {halo=true},
  ent_amfab = {halo=true, keepup=true, text="Press 'E' with a gun out to collect ammo."},
  ent_gunfab = {halo=true, keepup=true, text="Press 'E' to insert $1,000 and start fabrication.", text2=". . . Fabrication in progress . . ."},
  propbox = {halo=true, text="Press 'E' to equip this engine."},
  ab_ent_printer = {halo=true},
  ent_tip = {halo=true},
  ent_ammolarge = {halo=true, text="Press 'E' with a gun out to collect from this ammo crate."},
  spawned_money = {halo=true},
  func_door_rotating = {halo=true}
}

hook.Add("GravGunOnDropped", "Keepupright",function(ply, ent)
	local chose = EntList[ent:GetClass()]
	local Ang = ent:GetAngles()

	if Ang != Angle(0,Ang.y,0) and chose.keepup then
		ent:SetAngles(Angle(0,Ang.y,0))
	end
end)

if CLIENT then
	function HUDPaint()
		local ply = LocalPlayer()
		local trace = ply:GetEyeTrace()
		if trace.HitPos:Distance(ply:GetPos()) > 100 then return end
		local ent = trace.Entity
	  local chose = EntList[ent:GetClass()]
		if chose and ent:IsValid() then
	    if chose.halo then
	      local prop = {}
			  prop[1] = ent
				halo.Add(prop, Color(200,200,200),1,1,1,true,false)
	    end
	    if chose.text then
	      if chose.text2 then
					if ent:Getcreating() then
		        draw.DrawText(chose.text2, "ChatFont", (ScrW()/2), (ScrH()/2) + 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					else
		        draw.DrawText(chose.text, "ChatFont", (ScrW()/2), (ScrH()/2) + 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					end
	      else
	        draw.DrawText(chose.text, "ChatFont", (ScrW()/2), (ScrH()/2) + 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	      end
	    end
		end
	end
	hook.Add("HUDPaint", "HoverText", HUDPaint)
	hook.Add("PreDrawHalos", "PropHalo", HUDPaint)
end
