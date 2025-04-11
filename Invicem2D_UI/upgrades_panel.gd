extends GridContainer

@onready var button = preload("res://Scenes/UI/upgrade_button.tscn")
"""
func _ready() -> void:
	for i in range(12):
		var instance = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)

func fill(source) -> void:
	clear()
	var data: Dictionary = get_tree().get_first_node_in_group("selected").get_parent().Data[name]
	var keys: Array = data.keys()
	for i in range(keys.size()):
		var node = get_node(str(i+1))
		node.tooltip_text = keys[i]
"""		
func fill(source,data) -> void:
	var keys = data.keys()
	for i in range(keys.size()):
		var node = get_node(str(i+1))
		var label = RichTextLabel.new()
		label.name = "Label"
		label.set_anchors_preset(PRESET_FULL_RECT)
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.text = str(data[keys[i]])
		node.add_child(label)
"""
func clear() -> void:
	for child in get_children():
		child.tooltip_text = name
		for grandchild in child.get_children():
			grandchild.queue_free()
"""
