extends Node2D

@onready var UI = %UI
@onready var BuildArea = $"../Map/Area"

@export var showCollisionToggle = false
@export var showCollision = false
@export var property_list = false
@export var list_shown = false

var instance
var build = true
var normal_color: Color = Color(1, 1, 1, 1) # original color
var placement_color: Color = Color(1, 1, 1, 0.5) # original color
var collision_color: Color = Color(1, 0.5, 0.5, 0.5) # reddish color
var building_to_build
var selected_building = []

func _input(event):
	if event.is_action_pressed("RMB"):
		clear_ui()
	list_shown = false
	
	for ui in UI.get_children():
		if ("List" in ui.name || "Menu" in ui.name) && ui.visible:
			list_shown = true
	if event.is_action_pressed("LMB") && !list_shown:
		build = true
		if !UI.get_node("BuildingList").visible && !instance && !property_list:
			if !UI.fixed: UI.get_node("BuildingList").position = BuildArea.get_local_mouse_position()
			UI.get_node("BuildingList").show()
			
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
			instance_scene_from_name(building_to_build)
			clear_ui()
			
	if event.is_action_pressed("RMB"):
		if instance:
			instance.queue_free()
			instance = null
			
	if event.is_action_pressed("ShowCollision"):
		showCollision = true
	if event.is_action_released("ShowCollision"):
		showCollision = false	
	if event.is_action_released("ShowCollisionToggle"):
		showCollisionToggle = !showCollisionToggle
					

func is_point_in_mesh_bounds(mesh: MeshInstance2D, point: Vector2) -> bool:
	var mesh_extents = mesh.mesh.get_aabb().size / 2
	var mesh_extents_2d = Vector2(mesh_extents.x, mesh_extents.y) * mesh.scale
	var min_point = mesh.global_position - mesh_extents_2d
	var max_point = mesh.global_position + mesh_extents_2d

	return point.x > min_point.x and point.x < max_point.x and point.y > min_point.y and point.y < max_point.y
	
func _on_item_list_item_selected(index):
	building_to_build = UI.get_node("BuildingList").get_item_text(index)
	instance_scene_from_name(building_to_build)

func instance_scene_from_name(scene_name: String):
	var scene_path = "res://buildings/" + scene_name + ".tscn"
	
	if ResourceLoader.exists(scene_path):
		clear_ui()
		var scene = load(scene_path)
		instance = scene.instantiate()
		instance.temp = true
#		instance.get_node("Area2D").unique_id = scene.get_instance_id()
		instance.modulate = placement_color
		get_node(scene_name).add_child(instance)
				
	else:
		print("Scene does not exist:", scene_path)

func _process(_delta):
	if instance:
		instance.position = get_snap_to_hundred($"../Map/Ground".get_local_mouse_position())

func get_snap_to_hundred(position: Vector2) -> Vector2:
	var x = round(position.x / 25.0) * 25
	var y = round(position.y / 25.0) * 25
	
	x = clamp(x, -750, 750)
	if y <= 0:
		y = clamp(y, -450, -150)
	if y >= 0:
		y = clamp(y, 125, 425)
	
	return Vector2(x, y)

func clear_ui():
	for ui in UI.get_children():
		if "List" in ui.name || "Menu" in ui.name:
			ui.hide()
			ui.deselect_all()
