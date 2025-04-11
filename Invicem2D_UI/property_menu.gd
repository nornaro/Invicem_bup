extends GridContainer

var root = "res://Scenes/"
var scene = preload("res://Scenes/UI/item_list.tscn")
var button = preload("res://Scenes/UI/property_menu_button.tscn")
"""
func _ready() -> void:
	for i in range(4):
		var instance = button.instantiate()
		instance.name = str(i+1)
		add_child(instance)

func fill(source) -> void:
	clear()
	var data: Dictionary = get_tree().get_first_node_in_group("selected").get_parent().Data[name]
	var keys: Array = data.keys()
	for i in range(data.size()):
		var node = get_node(str(i+1))  # Get the node based on the calculated index
		node.tooltip_text = keys[i]
		var itemlist:ItemList = scene.instantiate()
		var list = DirAccess.get_directories_at(root + "/" + source + "/" + keys[i])
		for item in list:
			itemlist.add_item(item)
			if data[keys[i]] == item:
				itemlist.item_count-1
				itemlist.select(itemlist.item_count-1)
		node.add_child(itemlist)

func clear() -> void:
	for child in get_children():
		child.tooltip_text = name
		for grandchild in child.get_children():
			grandchild.queue_free()
"""
