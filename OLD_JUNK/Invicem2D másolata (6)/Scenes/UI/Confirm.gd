extends Panel

@onready var choice = null
@onready var confirm = null

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/Text").set_text("Destroy the building(s)?")

func _input(_event):
	if visible:
		if Input.is_key_pressed(KEY_ENTER):
			_on_confirm_pressed()
		return
	if Input.is_key_pressed(KEY_DELETE):
		if get_tree().get_nodes_in_group("selected"):
			show()
			return

func _on_confirm_pressed():
	for building in get_tree().get_nodes_in_group("selected"):
		building.get_parent().queue_free()
	hide()
