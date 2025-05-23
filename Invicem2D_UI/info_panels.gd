extends GridContainer

var button = preload("res://Scenes/UI/info_panel.tscn")
"""
func _ready() -> void:
	for i in range(3):
		var instance = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)
		
func fill(source) -> void:
	clear()
	var data: Dictionary = get_tree().get_first_node_in_group("selected").get_parent().Data.Info
	var keys: Array = data.keys()
	for i in range(keys.size()-1):
		var node = get_node(str(i+1))
		node.tooltip_text = keys[i]

func clear() -> void:
	for child in get_children():
		child.tooltip_text = name
		for grandchild in child.get_children():
			grandchild.queue_free()
"""
