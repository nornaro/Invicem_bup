extends Line2D

var saved_building = null
var default

# Called when the node enters the scene tree for the first time.
func _ready():
	default = points
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"../Building".selected_building && saved_building != $"../Building".selected_building[0]:
		points = default
		hide()
	if $"../Building".selected_building && $"../Building".selected_building[0] && points[0].x == -1:
		saved_building = $"../Building".selected_building[0]
		global_position=instance_from_id($"../Building".selected_building[0]).global_position
		for i in points.size():
			points[i].x *= instance_from_id($"../Building".selected_building[0]).mesh.size.x/2
			points[i].y *= instance_from_id($"../Building".selected_building[0]).mesh.size.y/2
		show()
