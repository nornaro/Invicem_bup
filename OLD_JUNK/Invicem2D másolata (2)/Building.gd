extends Node

@onready var BuildingList = $"../UI/BuildingList"
@onready var BuildArea = $"../Map/Area"
var instance
var build = true
var normal_color: Color = Color(1, 1, 1, 1) # original color
var placement_color: Color = Color(1, 1, 1, 0.5) # original color
var collision_color: Color = Color(1, 0.5, 0.5, 0.5) # reddish color
var selected

func _input(event):
	if event.is_action_pressed("LMB"):
		build = true
		if !BuildingList.visible && !instance:
			BuildingList.position = BuildArea.get_local_mouse_position()
			BuildingList.show()
			
		if not instance:
			return
		for child in get_children():
			if child == instance:
				continue
			if instance.overlapping:
				build = false
		if build:
			instance.modulate = normal_color
			instance.temp = false
			instance_scene_from_name(selected)
			
	if event.is_action_pressed("RMB"):
		if instance:
			instance.queue_free()
			instance = null
		if BuildingList.visible:
			BuildingList.hide()
			BuildingList.deselect_all()
			

func is_point_in_mesh_bounds(mesh: MeshInstance2D, point: Vector2) -> bool:
	var mesh_extents = mesh.mesh.get_aabb().size / 2
	var mesh_extents_2d = Vector2(mesh_extents.x, mesh_extents.y) * mesh.scale
	var min_point = mesh.global_position - mesh_extents_2d
	var max_point = mesh.global_position + mesh_extents_2d

	return point.x > min_point.x and point.x < max_point.x and point.y > min_point.y and point.y < max_point.y
	
func _on_item_list_item_selected(index):
	selected = BuildingList.get_item_text(index)
	instance_scene_from_name(selected)

func instance_scene_from_name(scene_name: String):
	var scene_path = "res://buildings/" + scene_name + ".tscn"
	scene_path = scene_path.to_lower()
	
	if ResourceLoader.exists(scene_path):
		var scene = load(scene_path)
		instance = scene.instantiate()
		instance.temp = true
#		instance.get_node("Area2D").unique_id = scene.get_instance_id()
		instance.modulate = placement_color
		get_node(scene_name).add_child(instance)				
				
	else:
		print("Scene does not exist:", scene_path)

func _process(delta):
	if instance:
		instance.position = get_snap_to_hundred($"../Map/Ground".get_local_mouse_position())

func get_snap_to_hundred(position: Vector2) -> Vector2:
	var x = round(position.x / 50.0) * 50
	var y = round(position.y / 50.0) * 50
	
	x = clamp(x, -750, 750)
	if y <= 0:
		y = clamp(y, -400, -100)
	if y >= 0:
		y = clamp(y, 50, 400)
	
	return Vector2(x, y)
