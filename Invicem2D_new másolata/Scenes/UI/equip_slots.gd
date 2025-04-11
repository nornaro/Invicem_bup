extends GridContainer

var button = preload("res://Scenes/UI/equip_slot.tscn")

func _ready() -> void:
	for i in range(4):
		var instance = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)

func fill() -> void:
	var data: Dictionary = get_tree().get_first_node_in_group("selected").get_parent().Data.Equip
	var keys: Array = data.keys()
	for i in range(keys.size()):
		var node = get_node(str(i+1))  # Get the node based on the calculated index
		node.tooltip_text = data[keys[i]]

func clear() -> void:
	for child in get_children():
		child.tooltip_text = "Equip Module Slot"
		for grandchild in child.get_children():
			grandchild.queue_free()
