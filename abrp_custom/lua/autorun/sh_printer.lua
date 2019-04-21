local printers = {}
/* ADD NEW PRINTERS HERE
local printer = {}
printer.name  		=
printer.type    		=
printer.mdl     		=
printer.price        	=
printer.clr       		=
printer.printa 		=
printer.mat           	=
printer.cat 		=
printer.sort           	=
table.insert(printers, printer)
*/
local printer = {}
printer.name  		= "Basic Money Printer"
printer.type    		= "basicmp"
printer.mdl     		= "models/props_c17/consolebox01a.mdl"
printer.price        	= 1000
printer.clr       		= Color(0, 255, 160)
printer.printa 		=  7
printer.mat           	= ""
printer.cat 		= "Money"
printer.sort           	= 1
table.insert(printers, printer)

local printer = {}
printer.name  		= "Improved Money Printer"
printer.type    		= "impmp"
printer.mdl     		= "models/props_c17/consolebox01a.mdl"
printer.price        	= 2500
printer.clr       		= Color(130, 160, 255)
printer.printa 		=  10
printer.mat           	= ""
printer.cat 		= "Money"
printer.sort           	= 2
table.insert(printers, printer)

local printer = {}
printer.name  		= "Super Money Printer"
printer.type    		= "supermp"
printer.mdl     		= "models/props_c17/consolebox01a.mdl"
printer.price        	= 5000
printer.clr       		= Color(127, 0, 95)
printer.printa 		=  13
printer.mat           	= ""
printer.cat 		= "Money"
printer.sort           	= 3
table.insert(printers, printer)

hook.Add("loadCustomDarkRPItems", "absoluteprinterload", function()
	for k, v in pairs(printers) do
		DarkRP.createEntity(v.name,{
			ent = "ab_ent_printer",
			model = v.mdl,
			price = v.price,
			printer = true,
			max = 2,
			cmd = "abbuy"..v.type,
			name = v.name,
			color = v.clr,
			mat = v.mat,
			printa = v.printa,
			category = v.cat,
			sortOrder = v.sort
		})
	end
end)
