extends ItemList

@export var Items = {}
var Data = {}

func dir_to_list(dir,dirname):
	var directory = DirAccess.open(dir)
	if !directory:
		return
	Items[dirname] = buildings_list(directory)
	
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
	if !Items.has(list):
		return
	clear()
	for item in Items[list]:
		add_item(item)
	$"../Numbers".update(Items[list].size())
	show()


#func _on_building_menu_item_selected(index):
#	if BuildingMenu.get_item_text(index) == "Turret >":
#		BuildingMenu.hide()
#		TurretList.show()
#		if !UI.fixed: TurretList.position = BuildingMenu.position
#	return

func add_turrets_list():
	var turrets = "res://Scenes/Building/Tower/Turrets/"
	dir_to_list(turrets,"Turret")
