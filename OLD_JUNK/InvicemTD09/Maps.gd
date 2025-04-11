extends GridMap

const Map = preload("res://map.tscn")

@rpc("any_peer")
func add(peer_id,shift):	
	var map = Map.instantiate()
	map.name = str(peer_id)
	map.position+=shift
	add_child(map)

func remove(peer_id):
	var map = get_node_or_null(str(peer_id))
	if map:
		map.queue_free()
