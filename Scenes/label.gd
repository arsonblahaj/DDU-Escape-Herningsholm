extends Label3D

@export var chalk_font: Font

func _ready():
	if chalk_font: set("font", chalk_font)
	
	# Scrambled clues - no numbers. 
	# The player has to connect the symbols to the objects.
	text = "    STUDY GUIDE    \n" + \
		   " Algebra: X, Y\n" + \
		   " Chronology: Σ\n" + \
		   " Possession: Ω\n" + \
		   "\n" + \
		   " [ X ] [ Y ] [ Σ ] [ Ω ]" 
		   # The boxes at the bottom hint at the order without saying it.
