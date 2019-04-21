hook.Add("OnEntityCreated", "EntDrawDistance", function(ent)
	if (type(ent) == "Entity") and (type(ent) ~= "Vehicle") then
		ent:SetSaveValue("fademindist", 2400)
		ent:SetSaveValue("fademaxdist", 2500)
	elseif (type(ent) == "NPC") then
		ent:SetSaveValue("fademindist", 1400)
		ent:SetSaveValue("fademaxdist", 1500)
	else
		ent:SetSaveValue("fademindist", 2400)
		ent:SetSaveValue("fademaxdist", 2500)
	end
end)

hook.Add("PlayerSpawn", "plyDrawDistance", function(ply)
	if (type(ply) ~= "Player") then return end
	ply:SetSaveValue("fademindist", 3400)
	ply:SetSaveValue("fademaxdist", 3500)
end)
