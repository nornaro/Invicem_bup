extends Area2D

var placement_color: Color = Color(1, 1, 1, 0.5)
var collision_color: Color = Color(1, 0.5, 0.5, 0.5)
@onready var mesh = $".."

func _ready():
	mesh.modulate = placement_color

func _on_area_entered(area):
	if !area.is_in_group("building"): return
	if mesh.temp: mesh.modulate = collision_color
	mesh.overlapping = true

func _on_area_exited(area):
	#if !area.get_parent().building: return
	if mesh.temp: mesh.modulate = placement_color
	mesh.overlapping = false
	
func is_overlapping() -> bool:
	return mesh.overlapping
