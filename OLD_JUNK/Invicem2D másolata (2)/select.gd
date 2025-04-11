extends Node2D

var showCollision = false
var color = "green"

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = $"..".mesh.size
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ShowCollision"):
		showCollision = true
	if event.is_action_released("ShowCollision"):
		showCollision = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$green.visible = false
	$red.visible = false
	if showCollision:
		get_node(color).visible = true
	pass
