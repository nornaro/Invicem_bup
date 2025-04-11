extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.





#func _on_pressed() -> void:
	#GlobalMultiplayerSynchronizer.increase_score.rpc(multiplayer.get_unique_id())


func _on_toggled(toggled_on: bool) -> void:
	modulate = Color.WHITE
	if toggled_on:
		modulate = Color.YELLOW
	GlobalMultiplayerSynchronizer.end_turn.rpc(multiplayer.get_unique_id(), toggled_on)	
	%TurnCounter.turn(GlobalMultiplayerSynchronizer.turn_count) 
