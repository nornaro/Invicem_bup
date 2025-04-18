extends SceneTree

func _init():
	var me = ProjectSettings.localize_path(ProjectSettings.globalize_path(get_script().resource_path))
	var dir = ProjectSettings.localize_path(me.get_base_dir())

	if dir != "res://":
		print_debug("Must be run with the script dir as the res:// path")
		print_debug("Current path: ", ProjectSettings.globalize_path(dir))
		print_debug("RES:// path: ", ProjectSettings.globalize_path("res://"))
		quit()
		return
	var n = load("res://tester.gd").new()
	root.add_child(n)
	current_scene = n
