extends Node

var RL = ResLoad.new()

func _ready() -> void:
	for file in RL.get_files_at("res://Scenes/Server/Host/"):
		var instance = Node.new()
		var script = "res://Scenes/Server/Host/" + file
		instance.set_script(Global.RL.load(script))
		instance.name = file.split(".")[0]
		add_child(instance)
	for child in get_children():
		if child.has_method("host"):
			child.host()
