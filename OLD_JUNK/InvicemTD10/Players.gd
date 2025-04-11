extends Node

const Player = preload("res://player_map.tscn")
const Map = preload("res://map.tscn")

func add(peer_id):
	#var instance = Node3D.new()
	var script = GDScript.new()

	#instance.name = str(peer_id)
	#var shift = Vector3($"..".Player.size()*130,0,0)
	var player = Player.instantiate()
	#var map = Map.instantiate()	
	
	#instance.position+=shift
	#instance.script = script
	#instance.set_multiplayer_authority(peer_id)
	#instance.add_child(map)
	#instance.add_child(player)	
	player.set_multiplayer_authority(peer_id)
	add_child(player)
	
	print(player.is_multiplayer_authority())
	
	$"../".setPlayer(str(peer_id))	
	
	if player.is_multiplayer_authority():
		pass

func remove():
	var player = get_node_or_null(str(get_instance_id()))
	if player:
		player.queue_free()
