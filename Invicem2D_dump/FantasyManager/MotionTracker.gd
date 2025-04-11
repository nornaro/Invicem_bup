extends AnimationTree

@export var player : Node3D

var last_position : Vector3 = Vector3.ZERO
var last_stunned : bool = false

func _process(_delta : float):
	#Get our immediate displacement vector first
	var motion := player.global_position - last_position
	last_position = player.global_position
	
	# Update animation tree with parameters for cardinal directions and stunned
	self.set("parameters/up/blend_amount", 
		1.0 if motion.dot(Vector3.UP) > 0.0 else 0.0)
	self.set("parameters/down/blend_amount",
		1.0 if motion.dot(Vector3.DOWN) > 0.0 else 0.0)
	self.set("parameters/left/blend_amount",
		1.0 if motion.dot(Vector3.LEFT) > 0.0 else 0.0)
	self.set("parameters/right/blend_amount",
		1.0 if motion.dot(Vector3.RIGHT) > 0.0 else 0.0)
	
	if !last_stunned and player.stunned:
		self.set("parameters/stunned/request", 
			AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	last_stunned = player.stunned
