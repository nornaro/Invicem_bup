extends Node

@export var fixed = true
@onready var List = $List

func _ready():
	add_buildings_list()
	add_turrets_list()
	
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		clear()
	if event.is_action_pressed("RMB"):
		for building in get_tree().get_nodes_in_group("selected"):
			menu(building.get_parent().get_parent().name)
	if event.is_action_pressed("Build"):
		clear()
		List.menu("Buildings")
	if event.is_action_pressed("LMB"):
		if active():
			return
		if %Buildings.temp_instance:
			return
		List.menu("Buildings")
	for i in range(10):# Loop through numbers 0-9
		if i > List.item_count:
			return
		if Input.is_key_pressed(KEY_0 + i):
			_on_list_item_selected(i)
	
func clear():
	for ui in get_children():
		if ui.get_class() == "ItemList":
			ui.deselect_all()
#		ui.hide()

func active():
	for ui in get_children():
		if ("List" in ui.name) && ui.visible:
			return ui

func _on_buildings_data():
	pass # Replace with function body.

func _on_list_item_selected(index):
	if index >= List.item_count:
		return
	var text = List.get_item_text(index)
	if %Buildings.temp_instance:
		list_buildings(text)
		return
	if List.Items["Buildings"].has(text):
		%Buildings.instance_scene_from_name(text)
		return
	if List.Items["Turret"].has(text):
		List.list_turrets(text)
		return
	if List.Items.has(text):
		List.menu(text)
		clear()

func list_buildings(text):
	%Buildings.temp_instance.queue_free()
	%Buildings.temp_instance = null
	%Buildings.instance_scene_from_name(text)

func dir_to_list(dir,dirname):
	var directory = DirAccess.open(dir)
	if !directory:
		return
	List.Items[dirname] = buildings_list(directory)
	
func buildings_list(directory):
	directory.list_dir_begin()  # skip navigation entries
	var list = []
	for building in directory.get_directories():
			if building.begins_with("Castle"):
				continue 
			list.append(building)
	return list

func list_turrets(text):
	var towers =  get_tree().get_nodes_in_group("Tower")
	for tower in towers:
		if !tower.Data.has("selected"):
			continue
		if tower.Data["selected"] == false:
			continue
		tower.instance_scene_from_name(text)

func menu(list):
	if !List.Items.has(list):
		return
	List.clear()
	for item in List.Items[list]:
		List.add_item(item)
	if List.Items[list]:
		$Numbers.update(List.Items[list].size())
	List.show()

func _on_building_menu_item_selected(index):
	if List.get_item_text(index) == "Turret":
		List.show()
	return

func add_turrets_list():
	var turrets = "res://Scenes/Building/Tower/Turrets/"
	dir_to_list(turrets,"Turret")

func add_buildings_list():
	var buildings = "res://Scenes/Building/"
	dir_to_list(buildings,"Buildings")
	for building in List.Items["Buildings"]:
		if !%Buildings.get_node_or_null(building):
			continue
		if %Buildings.get_node(building).Data.has("menu"):
#			dir_to_list(building,Buildings.get_node(building).Data["menu"])
			List.Items[building] = %Buildings.get_node(building).Data["menu"]
