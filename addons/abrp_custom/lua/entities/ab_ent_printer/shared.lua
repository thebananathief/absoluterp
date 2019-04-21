ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Printer"
ENT.Author = "Husky Hobo"
ENT.Category = "DarkRP"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "owning_ent")
end
