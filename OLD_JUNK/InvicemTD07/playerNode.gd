extends Node3D

func _enter_tree():
	get_child(0).set_multiplayer_authority(get_instance_id())
