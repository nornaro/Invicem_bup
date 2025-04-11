extends Node
# Called when the node enters the scene tree for the first time.

@export var MaxHealth = 3
@export var PlayerID = {}
@export var PlayerHealth = {}
@export var PlayerSpawn = {}
@export var PlayerArea = {}
@export var PlayerNode = {}
@export var PlayerData = {}

func _ready():

	PlayerData.values()
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func PlayerInfo(playerID):
	PlayerData = {
		"ID": PlayerID[playerID],
		"Health": PlayerHealth[playerID],
		"Spawn": PlayerSpawn[playerID],
		"Area": PlayerArea[playerID],
		"Node": PlayerNode[playerID]
	}
	print(PlayerData)
		
func setSpawn(playerID):
	PlayerID[playerID] = playerID
	PlayerNode[playerID] = get_node(playerID+"/"+playerID)
	PlayerHealth[playerID] = MaxHealth
	PlayerSpawn[playerID] = get_node(playerID+"/"+playerID).position
	PlayerArea[playerID] = $"../Map".get_node(playerID)

func damage(raycast):	
	if raycast.is_colliding():
		var playerID = str(raycast.get_collider().get_parent().get_instance_id())
		if playerID:
			PlayerHealth[playerID]-=1
			if PlayerHealth[playerID] <= 0:
				PlayerHealth[playerID] = MaxHealth
				get_node(playerID+"/"+playerID).position=PlayerSpawn[playerID]
			get_node(playerID+"/"+playerID).healthbar.value=PlayerHealth[playerID]
