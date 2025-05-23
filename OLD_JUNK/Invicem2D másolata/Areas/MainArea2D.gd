extends Area2D

@onready var main = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	print(area)
	if area.get_parent().is_in_group("minions"):  # Assuming you've added minions to the "minions" group
		main.health -= 1
		print("Main building health: ", main.health)
		print(area.get_parent())
		area.get_parent().queue_free()
		if main.health <= 0:
			print("Main building destroyed!")
