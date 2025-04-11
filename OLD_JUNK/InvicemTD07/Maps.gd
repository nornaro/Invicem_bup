extends Node

const Map = preload("res://map.tscn")

func add(ID):	
	var map = Map.instantiate()	
	map.name = ID
	add_child(map)

func remove(peer_id):
	var map = get_node_or_null(str(peer_id))
	if map:
		map.queue_free()
