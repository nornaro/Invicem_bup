extends Node3D

@onready var show: Node3D = $"."
@onready var sub_viewport: SubViewport = $SubViewport
@onready var mesh_instance_3d: MeshInstance3D = $SubViewport/MeshInstance3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
