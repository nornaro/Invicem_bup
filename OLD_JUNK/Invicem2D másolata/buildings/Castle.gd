extends MeshInstance2D

@export var max_health = 1000
@export var base_health = 100
@export var min_health = 1
@export var health = base_health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _on_area_entered(area):
#	print(area)
#	if area.is_in_group("minions"):  # Assuming you've added minions to the "minions" group
#		health -= 1
#		print("Main building health: ", health)
#		area.queue_free()
#		if health <= 0:
#			print("Main building destroyed!")
#
#
#
#func _on_area_2d_area_entered(area):
#	print(area)
#	if area.is_in_group("minions"):  # Assuming you've added minions to the "minions" group
#		health -= 1
#		print("Main building health: ", health)
#		area.queue_free()
#		if health <= 0:
#			print("Main building destroyed!")
