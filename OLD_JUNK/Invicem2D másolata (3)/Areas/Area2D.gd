extends Area2D

var placement_color: Color = Color(1, 1, 1, 0.5)
var collision_color: Color = Color(1, 0.5, 0.5, 0.5)
@onready var mesh = $".."
@onready var UI = $"../../../../UI/"
@onready var Building = $"../../../../Building/"
var multiselect = false

func _ready():
	mesh.modulate = placement_color

func _on_area_entered(area):
	if !area.is_in_group("building"): return
	mesh.overlapping.append(area)

func _on_area_exited(area):
	if !area.is_in_group("building"): return
	mesh.overlapping.erase(area)
	
func _process(_delta):
	if mesh.temp: mesh.modulate = placement_color
	$"../Select".color = "green"
	if mesh.overlapping:	
		if mesh.temp: mesh.modulate = collision_color
		$"../Select".color = "red"
	if 	UI.get_node("BuildingMenu").get_selected_items():
		var selected = UI.get_node("BuildingMenu").get_item_text(UI.get_node("BuildingMenu").get_selected_items()[0])
#		if selected == "Destroy":
#			UI.get_node("Destroy").show()
#			UI.get_node("BuildingMenu").clear()
		if selected == "Turret >":
			UI.get_node("BuildingList").hide()
			UI.get_node("TurretList").show()
			if !UI.fixed: UI.get_node("TurretList").position = UI.get_node("BuildingMenu").position
	
	if Input.is_key_pressed(KEY_DELETE):	
		UI.get_node("Destroy").show()		
	if UI.get_node("Destroy").confirm != null:
		instance_from_id(UI.get_node("Destroy").confirm).queue_free()
		UI.get_node("Destroy").confirm = null

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		for ui in UI.get_children():
			if "List" in ui.name && ui.visible:
				ui.hide()
		if !UI.fixed: UI.get_node("BuildingMenu").position = Building.BuildArea.get_local_mouse_position()
		if !Building.instance:
			UI.get_node("BuildingMenu").clear()
			if multiselect: 
				Building.selected_building.append(get_parent().get_instance_id())
			if !multiselect: 
				Building.selected_building.clear()
				Building.selected_building.append(get_parent().get_instance_id())
			UI.get_node("Destroy").choice = Building.selected_building[0]
			UI.get_node("Destroy").get_node("VBoxContainer/Text").set_text("Destroy the " + instance_from_id(Building.selected_building[0]).get_parent().name + "?")
			for item in UI.get_node("BuildingMenu").menu[get_parent().get_parent().name]:
				UI.get_node("BuildingMenu").add_item(item)
			UI.get_node("BuildingMenu").show()

func _on_mouse_entered():
	Building.property_list = true
func _on_mouse_exited():
	Building.property_list = false
func _input(event):
	if event.is_action_pressed("RMB"):
		UI.get_node("BuildingMenu").clear()
	if event.is_action_pressed("Ctrl"):
		multiselect = true
	if event.is_action_released("Ctrl"):
		multiselect = false
