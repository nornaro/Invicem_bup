extends Node3D

@onready var camera1 = $Player/Camera3D
@onready var camera2 = $Camera3D
@onready var camera = camera2
@onready var tooltip = %ToolTip
@onready var healthbar = $HUD/HealthBar
@onready var hud = $HUD
@onready var server = get_node("/root/World")

const SPEED = 15
const JUMP_VELOCITY = 10.0
var destination = Vector2()
var rotaNormal = Vector3()
var rota = Vector3()
var distance
var gravity = 20.0

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	hud.show()
	camera.current = true
	camera = camera2
	#server.rpc("setColor", get_parent().name)

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
		if camera == camera2: 
			camera = camera1
