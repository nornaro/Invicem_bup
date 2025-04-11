extends MeshInstance2D

@export var Data = {
	"temp" = false,
	"max_health" = 1000,
	"base_health" = 100,
	"min_health" = 1,
	"health" = 0,
}

func _ready():
	Data["health"] = Data["base_health"]
	self.modulate = Color(1, 1, 1, 1)
	$HealthBar.value = Data["health"]
	$HealthBar.value = Data["health"]
	var upscale = 2.5
	scale = Vector2(100 * upscale / mesh.size.x, -100 * upscale / mesh.size.y)

	$Outline.scale *= 2 / upscale
	$Outline.width *= 1- 2 / upscale
	$Outline.hide()
	notify_property_list_changed()
		
func life_stolen():
	Data["health"] -= 1
	get_tree().call_group("HealthBar","value_change",Data["health"])
	if Data["health"] <= 0:
		queue_free()
	notify_property_list_changed()
