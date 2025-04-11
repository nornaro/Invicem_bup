extends ItemList

@export var Items = {}

func _ready():
	var buildings = "res://Scenes/Buildings/Building/"
	dir_to_list(buildings,"Buildings")
	for building in Items["Buildings"]:
		dir_to_list(buildings+building+"s",building+"s")

func dir_to_list(dir,dirname):
	print(dir)
	var directory = DirAccess.open(dir)
	if !directory:
		return
	Items[dirname]=buildings_list(directory)
	
func buildings_list(directory):
	directory.list_dir_begin()  # skip navigation entries
	var list = []
	for file_name in directory.get_files():
		if file_name.ends_with(".png"):
			if file_name.begins_with("Castle"):
				continue 
			list.append(file_name.replace(".png", ""))
	return list

func _on_item_selected(_index):	
	pass
	
func _input(_event):
	if !visible:
		return
	for i in range(10):# Loop through numbers 0-9
		if i > item_count:
			return
		if Input.is_key_pressed(KEY_0 + i):
			_on_item_selected(i)

#func load_directory_data(dir):
#	var directory = DirAccess.open(dir)
#	if !directory:
#		return
#	directory.list_dir_begin()
#	var file_name = directory.get_next()
#	while file_name != "":
#		if !file_name.ends_with(".tscn"):
#			continue 
#		if file_name == "Castle.tscn":
#			continue 
#		add_item(file_name.replace(".tscn", ""))
#		file_name = directory.get_next()
#	directory.list_dir_end()

"""
@onready var Building = $"../../Building"

func _ready():
	var directory = DirAccess.open("res://buildings/")
	if !directory:
		return
	directory.list_dir_begin()
	var file_name = directory.get_next()
	while file_name != "":
		if !file_name.ends_with(".tscn"):
			continue 
		if file_name == "Castle.tscn":
			continue 
		add_item(file_name.replace(".tscn", ""))
		file_name = directory.get_next()
	directory.list_dir_end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_item_selected(index):
	if Building.temp_instance:
		Building.temp_instance.queue_free()
		Building.temp_instance = null

func _input(event):
	if !visible:
		return
	for i in range(10):# Loop through numbers 0-9
		if i > item_count:
			return
		if Input.is_key_pressed(KEY_0 + i):
			_on_item_selected(i)

"""
