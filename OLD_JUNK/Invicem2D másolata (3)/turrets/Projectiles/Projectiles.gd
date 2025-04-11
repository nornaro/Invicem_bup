extends Node2D

var aspd: float = 1.0 # Number of times the projectile will be fired per second.
var projectile_scene = preload("res://turrets/Projectiles/projectile.tscn")
var elapsed_time = 0.0
@onready var targets = $"..".targeting

func _ready():
	set_process(true) # Starts the _process function.

func _process(delta):
	elapsed_time += delta
	if elapsed_time >= 0.1 / aspd:
		elapsed_time = 0.0
		if targets.size() != 0:
			for target in targets:
				if is_instance_valid(target):
					fire_projectile(target.get_parent())

func fire_projectile(target):
	var projectile_instance = projectile_scene.instantiate()
#	projectile_instance.linear_velocity = (eta(target) - global_position).normalized()
	projectile_instance.target = target
	add_child(projectile_instance)
#
#func eta(target) -> Vector2: # estimated target arrival
#	var target_position = target.global_position # Example current position of target
#	var target_direction = target.linear_velocity # Example current direction of target
#	var target_speed_value = target.speed # Example speed of the target
#	var time_to_reach = target_position.distance_to(global_position) / 500
#
#	return target_position + target_direction * target_speed_value * time_to_reach

#func fire_projectile(target):
#	target.global_position()
