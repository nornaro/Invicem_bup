extends Node

const Player = preload("res://player.tscn")

func add(ID):	
	var player = Player.instantiate()
	ID = str(player.get_instance_id())
	
	player.name = ID
	player.get_child(0).name = ID
	add_child(player)
	
	$"../Map".add(ID)
	$"..".setSpawn(ID)
	#$"..".PlayerInfo(ID)
	
func remove():
	var player = get_node_or_null(str(get_instance_id()))
	if player:
		player.queue_free()
