extends WorldEnvironment

@onready var main_menu = $CanvasLayer
@onready var address_entry = $CanvasLayer/VBoxContainer/AddressEntry

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

@export var playerdata = {}
@export var Player = {}
var MaxHealth = 3

func _ready():
	pass # Replace with function body.

func setPlayer(playerID):
	playerdata = {
		#"PID"	: $Players.get_node(playerID).name,
		"IID"	: $Players.get_node(playerID).get_instance_id(),
		"Name"	: $CanvasLayer/VBoxContainer/Name.text,
		"Health": MaxHealth,
		"Spawn"	: $Players.get_node(playerID).position,
		"Area"	: $Players.get_node(playerID).get_node("GridMap"),
		"Color" : Color(randf_range(0,1), randf_range(0,1), randf_range(0,1)),
		"Node"	: $Players.get_node(playerID).get_node("Player")
	}
	Player[playerID] = playerdata
	print($Players.get_children())
	
@rpc("any_peer")
func damage(playerID):
	var raycast = $Players.get_node(str(playerID)).raycast
	if raycast.is_colliding():
		var target = str(raycast.get_collider().name)
		if target:
			Player[target]["Health"]-=1
			if Player[target]["Health"] <= 0:
				Player[target]["Health"] = MaxHealth
				$Players.get_node(target).position=Player[target]["Spawn"]
			$Players.get_node(target).healthbar.value=Player[target]["Health"]

@rpc("any_peer")
func setColor(playerID):
	var material = Player[playerID]["Area"].get_node("Castle/Mesh").get_active_material(3)
	material.albedo_color = Player[playerID]["Color"]
	for child in Player[playerID]["Area"].get_node("Baracks").get_children():
		material = Player[playerID]["Area"].get_node("Castle/Mesh").get_active_material(3)
		material.albedo_color = Player[playerID]["Color"]
	for child in Player[playerID]["Area"].get_node("Towers").get_children():
		material = Player[playerID]["Area"].get_node("Castle/Mesh").get_active_material(3)
		material.albedo_color = Player[playerID]["Color"]
	if not is_multiplayer_authority(): return

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_host_button_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	multiplayer.peer_connected.connect($Players.add)
	multiplayer.peer_disconnected.connect($Players.remove)
	$Players.add(1)
	#$Maps.rpc("add",1,Vector3(0,0,0))
	
func _on_join_button_pressed():
	main_menu.hide()
	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer
	#$Maps.add(enet_peer.get_unique_id(),Vector3(Player.size()*130,0,0))
	
func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
		pass
