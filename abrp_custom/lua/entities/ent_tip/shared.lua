ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Tip Jar"
ENT.Author = "TheBananaThief"
ENT.Category = "DarkRP"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "price")
    self:NetworkVar("Entity", 0, "owning_ent")
end
