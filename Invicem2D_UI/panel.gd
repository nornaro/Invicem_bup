extends Panel

func _ready() -> void:
	connect("mouse_entered", _undim)
	connect("mouse_exited", _dim)
	for child in get_children():
		get_ready(child)

func _undim() -> void:
	self_modulate.a = 0.4
	modulate.a = 0.8

func _dim() -> void:
	self_modulate.a = 0.1
	modulate.a = 0.4

func get_ready(child) -> void:
	for i in range(4):
		var instance = child.button.instantiate()
		instance.name = str(i+1)
		child.add_child(instance)

func fill(source) -> void:
	clear()
	var data: Dictionary = get_tree().get_first_node_in_group("selected").get_parent().Data[name]
	var keys: Array = data.keys()
	for i in range(keys.size()):
		var node = get_node(str(i+1))
		node.tooltip_text = keys[i]

func clear() -> void:
	for child in get_children():
		child.tooltip_text = name
		for grandchild in child.get_children():
			grandchild.queue_free()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("RMB"):
		var data: Dictionary = get_tree().get_first_node_in_group("selected").get_parent().Data.Inventory
		if data.has(tooltip_text):
			data.erase(tooltip_text)
