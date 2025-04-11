extends Node2D

var overlapping
@export var Data = {}

# 2DO Placement grid?

var build = false
var normal_color: Color = Color(1, 1, 1, 1) # original color
var placement_color: Color = Color(1, 1, 1, 0.5) # original color
var collision_color: Color = Color(1, 0.5, 0.5, 0.5) # reddish color
var temp_instance
var placement = false
var drag = false
var rectangle = Area2D.new()

func _ready():
	load_directory_data("res://Scenes/Building/")

func load_directory_data(dir):
	var directory = DirAccess.open(dir)
	if not directory:
		return
	add_buildings_list(buildings_list(directory))
	
func buildings_list(directory):
	directory.list_dir_begin()
	var list = []
	for building in directory.get_directories():
		list.append(building)
	return list
		
func add_buildings_list(list):
	for building in list:
		var instance = Node.new()
		instance.name = building
		add_child(instance)
		
		if building == "Castle":
			build_castle(building)

func _input(event):
	if !temp_instance:
		return
	var instance = instance_from_id(temp_instance)
	if event.is_action_pressed("RMB"):
		instance.queue_free()
		instance = null
		temp_instance = null
	if event.is_action_pressed("LMB"):
		build = true
	if event.is_action_released("LMB"):
		build = false
	instance.position = snap(get_global_mouse_position())
	var colliding = get_tree().get_nodes_in_group(str(instance.get_node("Area2D").get_instance_id()))
	if colliding:
		instance.modulate = collision_color
		return
	instance.modulate = placement_color
	if !build:
		return
	instance.modulate = normal_color

func selection_rectangle():
	rectangle.add_child(CollisionShape2D.new())
	rectangle.scale += get_local_mouse_position()	

func is_point_in_mesh_bounds(mesh: MeshInstance2D, point: Vector2) -> bool:
	var mesh_extents = mesh.mesh.get_aabb().size / 2
	var mesh_extents_2d = Vector2(mesh_extents.x, mesh_extents.y) * mesh.scale
	var min_point = mesh.global_position - mesh_extents_2d
	var max_point = mesh.global_position + mesh_extents_2d

	return point.x > min_point.x and point.x < max_point.x and point.y > min_point.y and point.y < max_point.y

func instance_scene_from_name(scene_name: String,parent_scene_name: String):
	var old
	var instance
	if temp_instance:
		old = instance_from_id(temp_instance)
		old.remove_from_group("temp")
	var scene = load("res://Scenes/Building/building.tscn")
	instance = scene.instantiate()
	instance.add_to_group("temp")
	if old:
		old.get_node("Area2D").add_to_group(str(instance.get_node("Area2D").get_instance_id()))
	instance.position = snap(get_global_mouse_position())
	instance.name = scene_name
	instance.modulate = placement_color
	instance.get_node("Select/red").hide()
	instance.get_node("Select/green").show()
	temp_instance = instance.get_instance_id()
	get_node(parent_scene_name).add_child(instance)
	return temp_instance

func build_castle(scene_name):
	var scene = load("res://Scenes/Building/building.tscn")
	var instance = scene.instantiate()
	instance.name = str(instance.get_instance_id())
	get_node(scene_name).add_child(instance)
	instance.modulate = normal_color
	instance.get_node("Sprite").offset.y -= 100

	var script = "res://Scenes/Building/"+scene_name+"/"+scene_name+".gd"
	FileAccess.file_exists(script)
	if FileAccess.file_exists(script):
		instance.set_script(load(script))
		instance._ready()

func load_script_from_name(id,scene_name: String):
	if !temp_instance:
		return
	var instance = instance_from_id(temp_instance)
	instance = instance_from_id(id)
	var script = "res://Scenes/Building/"+scene_name+"/"+scene_name+".gd"
	FileAccess.file_exists(script)
	if FileAccess.file_exists(script):
		instance.set_script(load(script))
		instance._ready()
	return temp_instance

func snap(pos: Vector2) -> Vector2:
	var x = round(pos.x / 25.0) * 25
	var y = round(pos.y / 25.0) * 25
	
	x = clamp(x, -750, 750)
	if y <= 0:
		y = clamp(y, -450, -150)
	if y >= 0:
		y = clamp(y, 125, 425)
	
	return Vector2(x, y)
