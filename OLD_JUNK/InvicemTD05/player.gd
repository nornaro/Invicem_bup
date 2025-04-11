extends CharacterBody3D

signal health_changed(health_value)

@onready var camera1 = $Camera3D
@onready var camera2 = $"../../Camera3D"
@onready var anim_player = $AnimationPlayer
@onready var muzzle_flash = $Camera3D/Pistol/MuzzleFlash
@onready var raycast = $Camera3D/RayCast3D
@onready var tooltip = %ToolTip
@onready var hud = $HUD
@onready var healthbar = $HUD/HealthBar


@export var health := 3
const SPEED = 15
const JUMP_VELOCITY = 10.0
var destination = Vector2()
var rotaNormal = Vector3()
var rota = Vector3()
var distance
var camera = Camera3D.new()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 20.0

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	hud.show()
	camera.current = true
	camera = camera2
	
func dead():
	position = Vector3.ZERO
	
func hit(newHP):
	print(health)
	health=newHP

func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	
	if event is InputEventMouseMotion:
		var scr = get_viewport().get_visible_rect().size
		#var pos = rad_to_deg(Vector2(0,0).angle_to_point(event.global_position))
		rota=Vector2((event.global_position.x-scr.x/2),(event.global_position.y-scr.y/2))
		rotaNormal=Vector2((event.global_position.x-scr.x/2)/scr.x,(event.global_position.y-scr.y/2)/scr.y)
		distance=Vector2(0,0).distance_to(Vector2((event.global_position.x-scr.x/2)/scr.x,(event.global_position.y-scr.y/2)/scr.y))
		
		if camera1.current:
			rotate_y(-event.relative.x * .005)
			camera1.rotate_x(-event.relative.y * .005)
			camera1.rotation.x = clamp(camera1.rotation.x, -PI/2, PI/2)
			
		if camera2.current:
			look_at(Vector3(rota.x,position.y,rota.y))
			camera2.rotation = Vector3(deg_to_rad(-90),deg_to_rad(0),deg_to_rad(0))
		
		destination=Vector2()
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			destination = rotaNormal/distance
	
	if Input.is_action_just_pressed("shoot") \
			and anim_player.current_animation != "shoot":
		play_shoot_effects()
		get_parent().get_parent().damage(raycast)
		
		#var hit_player = raycast.get_collider()

func _physics_process(delta):
	if not is_multiplayer_authority(): return
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction
	
	if camera2.current:
		camera2.rotation = Vector3(deg_to_rad(-80),deg_to_rad(0),deg_to_rad(0))
		camera2.position = position + Vector3 (0,15,0)	
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		if destination:
			direction = Vector3(destination.x, 0, destination.y)
		if input_dir:
			direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if camera1.current:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if input_dir:
			direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#print(direction)
		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	#print(direction)
	if anim_player.current_animation == "shoot":
		pass
	elif input_dir != Vector2.ZERO and is_on_floor():
		anim_player.play("move")
	else:
		anim_player.play("idle")

	move_and_slide()

func play_shoot_effects():
	anim_player.stop()
	anim_player.play("shoot")
	muzzle_flash.restart()
	muzzle_flash.emitting = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shoot":
		anim_player.play("idle")		

func _unhandled_key_input(event):
	tooltip.text = ""
	if event.is_pressed():
		match event.as_text():
			"0": tooltip.text = "[center]Demolish[/center]"
			"1": tooltip.text = "[center]Build Tower[/center]"
			"2": tooltip.text = "[center]Build Barack[/center]"
			"3": tooltip.text = "[center]Build Market[/center]"
			"4": tooltip.text = "[center]Build Armory[/center]"
	if event.is_action_pressed("ui_home"):
		if camera == camera1: 
			camera = camera2
		else:
			camera = camera1
