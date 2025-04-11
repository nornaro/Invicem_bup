extends GPUParticles2D

@export var target: Node2D = null
var velocity: Vector2
var speed: float
var fade_timer: float = 100
var freedom: bool = false
var Data = {}

func _ready():
	if !target:
		queue_free()
		return

	# Calculate movement direction
	var direction = (target.global_position - global_position).normalized()
	rotation = direction.angle()  # Face the target

		#process_material.spread = Vector2.ONE * Data.Spread
	process_material.initial_velocity = Vector2.ONE * 25* (Data.ProjectileSpeed + 10)
	#process_material.angle = Vector2.ONE * deg_to_rad(90)  # Ensure movement follows rotation


func _process(delta):
	if freedom:
		modulate.a = lerp(modulate.a, 0.0, 0.1)
		if modulate.a <= 0.01:
			queue_free()
		return

	# Simulate movement
	#position += velocity * delta

	# Lifetime handling
	#lifetime -= delta
	#if lifetime <= fade_timer:
		#set_free()
	if lifetime <= 0:
		queue_free()

func _on_area_2d_area_entered(area):
	if !area.get_parent().is_in_group("minions"):
		return
	Data.Damage -= 1
	area.get_parent().hurt(Data)
	if Data.Damage < 1:
		queue_free()

func set_free():
	freedom = true
