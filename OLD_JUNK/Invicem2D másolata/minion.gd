extends CharacterBody2D

@export var speed = 150.0
@export var jump = -400.0
@export var hp = 100
@export var def = 100
@export var size = 100
@export var dodge = 100

func _ready():
	add_to_group("minions")

func _physics_process(delta):
	velocity.x = -speed
	scale *= size/100
	move_and_slide()
