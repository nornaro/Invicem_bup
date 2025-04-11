extends Label

var last_turn = 0

# Called when the node enters the scene tree for the first time.
func turn(t: int):
	if t == last_turn:
		return
	text = str(t)
	%EndTurn.button_pressed = false
	%EndTurn.modulate = Color.WHITE
	
