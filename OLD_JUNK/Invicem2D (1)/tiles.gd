extends Node

# Called when the node and its children are ready.
func _ready():
	if not DirAccess.dir_exists_absolute("res://children"):
		DirAccess.make_dir_recursive_absolute("res://children")

	for child in get_children():
		# Set ownership to ensure it can be packed.
		child.owner = self
		
		# Create a new PackedScene.
		var packed_scene = PackedScene.new()
		if packed_scene.pack(child) == OK:
			var save_path = "res://children/" + child.name + ".tscn"
			var error = ResourceSaver.save(packed_scene,save_path)
			if error == OK:
				print("Saved ", child.name, " successfully at: ", save_path)
			else:
				print("Failed to save ", child.name, ": ", error)
		else:
			print("Failed to pack the scene for ", child.name)
			if child is Sprite2D and child.texture == null:
				print("Sprite node is missing its texture:", child.name)
			elif child is AnimatedSprite2D and child.frames == null:
				print("AnimatedSprite node is missing its frames:", child.name)
