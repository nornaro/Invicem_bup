extends Timer

@onready var servernode: Node = $"../Server"
var is_server = true

func _ready() -> void:
	start()

func _on_timeout() -> void:
	for player_id in servernode.players:
		rpc_id(player_id, "spawn_minions")
