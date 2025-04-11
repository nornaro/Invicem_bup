extends MeshInstance2D

@export var temp = true
@export var overlapping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func get_random_position_in_area(area: Area2D) -> Vector2:
	var collision_shape = area.get_node("CollisionShape2D")  # Assuming CollisionShape2D is a direct child; adjust if necessary
	var rect_shape = collision_shape.shape as RectangleShape2D

	var extents = rect_shape.extents
	var random_x = randf_range(-extents.x, extents.x)
	var random_y = randf_range(-extents.y, extents.y)
	return area.position + Vector2(random_x, random_y)
