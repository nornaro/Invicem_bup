extends Node

func _ready():
	var scene = load("res://Scenes/Building/Castle/Castle.tscn")
	var instance = scene.instantiate()
	instance.name = "Castle"
	add_child(instance)
