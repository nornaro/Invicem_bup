extends Node

func join():
	var peer := WebSocketMultiplayerPeer.new()
	multiplayer.multiplayer_peer = null
	multiplayer.connected_to_server.connect(connected)
	peer.create_client("ws://127.0.0.1:9080")
	multiplayer.multiplayer_peer = peer
	set_process(true)
	await get_tree().create_timer(3.0).timeout
	print_debug("Status after 3s:", multiplayer.multiplayer_peer.get_connection_status())


func connected():
	print("C")

func lobby():
	pass

func _process(delta: float) -> void:
	print_debug("Status after 3s:", multiplayer.multiplayer_peer.get_connection_status())
	

#extends Node
#
#var player: PackedScene = preload("res://Scenes/Client/2d_client.tscn")
#var server_node: Node
#var broadcast_port = 9090
#var uid: String
#var peer = WebSocketMultiplayerPeer.new()
#
#func lobby() -> void:
	#set_process(true)
#
	#
#func join() -> void:
	#server_node = get_tree().get_first_node_in_group("Server")
	#peer.supported_protocols = ["ludus"]
	#multiplayer.connect("peer_disconnected",Callable(self,"_peer_disconnected"))
	#multiplayer.connect("peer_connected",Callable(self,"_peer_connected"))
	#multiplayer.connect("connection_failed",Callable(self,"_close_network"))
	#multiplayer.connect("connected_to_server",Callable(self,"_connected"))
	#var join_data = "127.0.0.1:"+str(broadcast_port)
	#if Global.join_data:
		#join_data = Global.join_data
	#print_debug("Connecting to:","ws://" +  join_data)
	#multiplayer.multiplayer_peer = null
	#var err = peer.create_client("ws://" + join_data)
	#multiplayer.multiplayer_peer = peer
	##peer.open("ws://" + join_data)
	#while peer.get_connection_status() != 2:
		#await get_tree().process_frame  # Allow a frame to pass before checking again
		#print_debug("Connection result:", err)
#
#@rpc("any_peer")
#func remove_player(id):
	#server_node.get_node_or_null(str(id)).queue_free()
#
#func connected():
	##_game.set_player_name.rpc(_name_edit.text)
	#add_player.rpc(multiplayer.get_unique_id())
#
#func disconnected():
	#push_warning("Connection lost")
	#remove_player.rpc_id(multiplayer.get_unique_id())
#
#@rpc("any_peer")
#func add_player(id):
	#var player_instance = player.instantiate()
	#player_instance.name = str(id)
	#server_node.add_child(player_instance)
#
## rpc declaration must match server script, but definition can be different.
#@rpc("any_peer", "call_remote", "reliable")
#func my_relay_rpc(_data: String):
	#pass
#
#func _input(event: InputEvent) -> void:
	#if event.is_action("ui_accept"):
		#var response = "My player name is: " + str(multiplayer.get_unique_id())
		#my_relay_rpc.rpc_id(1, response)
#
#func _close_network():
	#multiplayer.multiplayer_peer = null
	#peer.close()
#
#func _process(_delta):
	#if multiplayer.multiplayer_peer.get_packet_error() != 0:
		#print(multiplayer.multiplayer_peer.get_packet_error())
