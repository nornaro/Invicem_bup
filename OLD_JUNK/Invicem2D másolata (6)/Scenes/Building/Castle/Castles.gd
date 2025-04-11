extends Node

func _ready():
	var scene
	var instance
	scene = load("res://Scenes/Building/building.tscn")
	instance = scene.instantiate()
	instance.name = str(instance.get_instance_id())
	instance.modulate = Color(1, 1, 1, 1)
	add_child(instance)
	
	var child = instance
	scene = load("res://Scenes/Building/Castle/health_bar.tscn")
	instance = scene.instantiate()
	child.add_child(instance)
	var script = "res://Scenes/Building/Castle/Castle.gd"
	if FileAccess.file_exists(script):
		child.set_script(load(script))
		child._ready()
