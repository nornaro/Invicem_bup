extends Node

# Called when the node and its children are ready.
func _ready():
	
	# Ensure directory exists
	if not DirAccess.dir_exists_absolute("res://bdings"):
		DirAccess.make_dir_recursive_absolute("res://bdings")

	# List including Camera3D and Sun nodes to pack
	var nodes_to_pack = get_children()

	for child in nodes_to_pack:
		pack_and_save_node(child)

func pack_and_save_node(child):
	# Set ownership to ensure it can be packed.
	child.owner = self

	# Create a new PackedScene.
	var packed_scene = PackedScene.new()
	if packed_scene.pack(child) == OK:
		var save_path = "res://bdings/" + child.name + ".tscn"
		var error = ResourceSaver.save(packed_scene, save_path)
		if error == OK:
			print("Saved ", child.name, " successfully at: ", save_path)
		else:
			print("Failed to save ", child.name, ": ", error)
	else:
		print("Failed to pack the scene for ", child.name)
