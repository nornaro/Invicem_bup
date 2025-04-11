extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_scoreboard()
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if !multiplayer.is_server():
		return
	if !GlobalMultiplayerSynchronizer.score:
		return
	fill_scoreboard()

func fill_scoreboard():
	var name_id_children = get_node("NameID").get_children()
	var score_children = get_node("Score").get_children()

	var i = 0
	for key in GlobalMultiplayerSynchronizer.score.keys():
		if i < name_id_children.size() and i < score_children.size():
			name_id_children[i].text = str(key)
			score_children[i].text = str(GlobalMultiplayerSynchronizer.score[key])
			i += 1

	# Set remaining children text to empty string
	while i < name_id_children.size():
		name_id_children[i].text = ""
		score_children[i].text = ""
		i += 1
