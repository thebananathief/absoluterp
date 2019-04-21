HintsEng = {
	"You can type /job to set your role to something more specific.",
	"Shotguns can blast down doors at close range.",
	"Explosives can blast open nearby doors and fading doors.",
	"Did you know that every job in the jobs menu has a custom-made description?",
	"The universal ammo will adjust to whichever gun you hold out while collecting it.",
	"The propeller engine allows you to fly around at great speeds.",
	"You can customize your thirdperson view with held weapons in the options tab of the Q menu.",
	"You can customize your flashlight settings in the options tab of the Q menu.",
	"The gun fabricator will produce guns at much cheaper cost, but is randomized."
}

timer.Create( "Client.HINTS", 300, 0, function()//1, 203, 102
		chat.AddText( Color(2, 119, 189), "[HINT] ", Color( 255, 255, 255 ), HintsEng[ math.random( 1, #HintsEng ) ] )
end )
