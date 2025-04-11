extends GridMap

@onready var server = get_node("/root/World")

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

# Called when the node enters the scene tree for the first time.
func _ready():
	print(is_multiplayer_authority())
	pass
	
func PlayerColor(C):
	var material = get_node("Castle/Mesh").get_active_material(3)
	material.albedo_color = C
	for child in $Baracks.get_children():
		material = get_node("Castle/Mesh").get_active_material(3)
		material.albedo_color = C
	for child in $Towers.get_children():
		material = get_node("Castle/Mesh").get_active_material(3)
		material.albedo_color = C
	if not is_multiplayer_authority(): return


func _on_castle_input_event(camera, event, position, normal, shape_idx):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pass # Replace with function body.
