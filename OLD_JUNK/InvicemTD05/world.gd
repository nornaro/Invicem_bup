extends Node

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry

const Player = preload("res://player.tscn")
const Env = preload("res://grid_map.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_host_button_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	add_terrain()
	add_player(multiplayer.get_unique_id())
	
func add_terrain():	
	var env = Env.instantiate()
	#env.translate(Vector3(instanceCount*20,-1,0))
	env.name = str(env.get_index())
	$Map.add_child(env)
	
func _on_join_button_pressed():
	main_menu.hide()
	add_terrain()
	#instanceCount=instanceCount+1
	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	$Spawn.add_child(player)
	if player.is_multiplayer_authority():
		pass

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
		pass
		
func damage(raycast):	
	if raycast.is_colliding():
		var hit_player = raycast.get_collider()
		print(hit_player)
		if hit_player:
			hit_player.hit( hit_player.health-1 )
			if hit_player.health <= 0:
				hit_player.health = 3
				hit_player.dead()
	
	

