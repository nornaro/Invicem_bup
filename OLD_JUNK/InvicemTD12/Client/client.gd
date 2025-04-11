extends Node

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _ready():	
	enet_peer.create_client("127.0.0.1", PORT)
	multiplayer.multiplayer_peer = enet_peer
	name=str(multiplayer.multiplayer_peer.get_unique_id())
	set_multiplayer_authority(multiplayer.multiplayer_peer.get_unique_id())
	print(name)
	print(is_multiplayer_authority())
