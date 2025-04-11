extends Node

var Player = {}

func _ready():
	set_network_mode(NetworkedMultiplayerPeer.PROTOCOL_SERVER)

func set_data(key, value):
	Player[key] = value

func get_data(key):
	return Player.get(key, null)
