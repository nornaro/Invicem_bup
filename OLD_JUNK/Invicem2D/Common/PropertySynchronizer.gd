extends MultiplayerSynchronizer
class_name PropertySynchronizer

var last_properties = {}
var saved_properties = {}
@export var Server = "127.0.0.1"
@export var Port = 4433
var multiplayer_peer = ENetMultiplayerPeer.new()
var cached_property_paths = {}
@onready var root = get_tree().root

func _ready():
	serverConnect()
	cache_property_paths(root, root.get_path())
	write_json(cached_property_paths, "res://Common/cached_property_paths.json")
	last_properties = gather_current_properties()
	# ... rest of the code remains the same

func should_cache(node: Node) -> bool:
	if node == null:
		return false
	if node == self:
		return false
	if node == get_node("."):
		return false
	return true

func cache_property_paths(node: Node, node_path: String):
	if not should_cache(node):
		return
	
	var properties = gather_properties_from_node(node)
	if properties.size() > 0:
		cached_property_paths[node_path] = properties
	
	for child in node.get_children():
		var child_path = "%s/%s" % [node_path, child.name]
		cache_property_paths(child, child_path)

func gather_properties_from_node(node: Node) -> Array:
	var property_list = []
	for property_info in node.get_property_list():
		if property_info.usage & PROPERTY_USAGE_STORAGE == 0:
			continue
		
		var property_name = property_info.name
		property_list.append(property_name)
		
		var property_value = node.get(property_name)
		if property_value is Object and !(property_value is Node):
			var sub_properties = gather_properties_recursive(property_value, property_name)
			for sub_property_name in sub_properties:
				property_list.append("%s.%s" % [property_name, sub_property_name])
	return property_list

func gather_properties_recursive(obj: Object, parent_property: String) -> Array:
	var property_list = []
	for property_info in obj.get_property_list():
		if property_info.usage & PROPERTY_USAGE_STORAGE == 0:
			continue
		var property_name = property_info.name
		property_list.append(property_name)
		
		var property_value = obj.get(property_name)
		if property_value is Object and !(property_value is Node):
			var sub_properties = gather_properties_recursive(property_value, property_name)
			for sub_property_name in sub_properties:
				property_list.append("%s.%s" % [property_name, sub_property_name])
	return property_list

func gather_current_properties() -> Dictionary:
	var current_properties = {}
	for node_path in cached_property_paths.keys():
		var node = get_node_or_null(node_path)
		if not node:
			continue
		var properties_dict = {}
		for property_name in cached_property_paths[node_path]:
			properties_dict[property_name] = node.get(property_name)
		current_properties[node_path] = properties_dict
	return current_properties

func compare_changes(current: Dictionary, last: Dictionary):
	for node_path in current.keys():
		if not last.has(node_path):
			continue
		for property_name in current[node_path].keys():
			var full_path = "%s.%s" % [node_path, property_name]
			if saved_properties.has(node_path) and saved_properties[node_path].has(property_name):
				continue
			if last[node_path][property_name] == current[node_path][property_name]:
				continue
			saved_properties.merge({node_path: {property_name: true}})
			write_json(saved_properties, "res://Common/to_sync.json")

func add_replication_config(saved_properties, rootpath):
	print(rootpath)
	for node_path in saved_properties.keys():
		for property_name in saved_properties[node_path].keys():
			replication_config.add_property(node_path.replace(rootpath, "") + ":" + property_name)
			print(replication_config.get_properties())

func serverConnect():
	multiplayer_peer.create_client(Server, Port)
	multiplayer.multiplayer_peer = multiplayer_peer

func serverDisconnect():
	multiplayer_peer.close()

func load_json(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	return JSON.parse_string(json_text)

func write_json(dict, path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json = JSON.stringify(dict, "\t", true)
	file.store_string(json)
	file.close()
