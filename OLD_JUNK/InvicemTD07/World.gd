extends WorldEnvironment
# Called when the node enters the scene tree for the first time.
@onready var main_menu = $CanvasLayer
@onready var address_entry = $CanvasLayer/VBoxContainer/AddressEntry

@export var MaxHealth = 3
@export var PlayerID = {}
@export var PlayerName = {}
@export var PlayerHealth = {}
@export var PlayerSpawn = {}
@export var PlayerArea = {}
@export var PlayerNode = {}
@export var PlayerData = {}

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _ready():
	PlayerData.values()
	pass # Replace with function body.

func PlayerInfo(playerID):
	PlayerData = {
		"ID": PlayerID[playerID],
		"Name": PlayerName[playerID],
		"Health": PlayerHealth[playerID],
		"Spawn": PlayerSpawn[playerID],
		"Area": PlayerArea[playerID],
		"Node": PlayerNode[playerID]
	}
	print(PlayerData)
		
func setSpawn(playerID):
	PlayerID[playerID] = $CanvasLayer/VBoxContainer/Name.text
	PlayerName[playerID] = playerID
	PlayerNode[playerID] = $Players.get_node(playerID+"/"+playerID)
	PlayerHealth[playerID] = MaxHealth
	PlayerSpawn[playerID] = $Players.get_node(playerID+"/"+playerID).position
	PlayerArea[playerID] = $Map.get_node(playerID)

func damage(raycast):	
	if raycast.is_colliding():
		var playerID = str(raycast.get_parent().get_instance_id())
		if playerID:
			PlayerHealth[playerID]-=1
			if PlayerHealth[playerID] <= 0:
				PlayerHealth[playerID] = MaxHealth
				get_node(playerID+"/"+playerID).position=PlayerSpawn[playerID]
			get_node(playerID+"/"+playerID).healthbar.value=PlayerHealth[playerID]

func _on_host_button_pressed():
	main_menu.hide()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect($Players.add)
	multiplayer.peer_disconnected.connect($Players.remove)
	$Players.add(1)

func _on_join_button_pressed():
	main_menu.hide()
	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer

func _on_multiplayer_spawner_spawned(node):
	#node.set_multiplayer_authority(node.get_instance_id())
	#print ( node.get_multiplayer_authority())
	pass
