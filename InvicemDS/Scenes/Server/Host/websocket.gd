extends Node

func host():
	var peer := WebSocketMultiplayerPeer.new()
	multiplayer.multiplayer_peer = null
	peer.create_server(9080)
	multiplayer.multiplayer_peer = peer
	set_process(true)
	await get_tree().create_timer(3.0).timeout
	print_debug("Status after 3s:", multiplayer.multiplayer_peer.get_connection_status())

func _process(delta: float) -> void:
	print_debug("Status after 3s:", multiplayer.multiplayer_peer.get_connection_status())




#extends Node
#
#const PORT = 9090
#var peer = WebSocketMultiplayerPeer.new()
#var server_node:Node
#var player: PackedScene = preload("res://Scenes/Server/client.tscn")
#
#func host():
	#server_node = get_tree().get_first_node_in_group("Server")
	#peer.supported_protocols = ["ludus"]
	#multiplayer.connect("peer_disconnected",Callable(self,"_peer_disconnected"))
	#multiplayer.connect("peer_connected",Callable(self,"_peer_connected"))
	#multiplayer.connect("connection_failed",Callable(self,"_close_network"))
	#multiplayer.connect("connected_to_server",Callable(self,"_connected"))
	#multiplayer.multiplayer_peer = null
	#var err = peer.create_server(PORT,"*",null)
	#multiplayer.multiplayer_peer = peer
	#print_debug("Server results: ",err)
	#if err != OK:
		#print("Unable to start server")
		#set_process(false)
		#return
	#print("Websocket running on: ",PORT)
#
#@rpc("any_peer", "call_remote", "reliable")
#func my_relay_rpc(data: String):
	#print_debug(data)
	#
#func _on_peer_connected(id):
	#print_debug("New peer connected: ", id)
	#add_player.rpc(id)
	#
#@rpc("any_peer")
#func add_player(id):
	#if server_node.get_node_or_null(str(id)):
		#return
	#var player_instance = player.instantiate()
	#player_instance.name = str(id)
	#server_node.add_child(player_instance)
	#Global.clients.append(id)
	#Global.clienthp[id] = 100
#
#@rpc("any_peer")
#func remove_player(id):
	#if server_node.get_node(str(id)):
		#server_node.get_node(str(id)).queue_free()
		#Global.clients.erase(id)
	#
#func _close_network():
	#multiplayer.multiplayer_peer = null
	#peer.close()
	#
#func _process(_delta):
	#print(multiplayer.get_peers())
	#print(multiplayer.multiplayer_peer.get_connection_status())
	##print(multiplayer.multiplayer_peer.get_connection_status())
