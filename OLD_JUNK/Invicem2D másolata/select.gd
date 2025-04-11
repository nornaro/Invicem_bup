extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	scale = $"..".mesh.size
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ShowCollision"):
		print("OK")
			
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
