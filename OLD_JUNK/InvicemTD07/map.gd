extends GridMap

func _enter_tree():
	set_multiplayer_authority(get_instance_id())

# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_multiplayer_authority(): return
