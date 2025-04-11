extends Camera2D

@onready var main_menu = preload("res://Scenes/MainMenu/home_screen.tscn")

func _ready() -> void:
	add_child(main_menu.instantiate())
 
func _process(delta: float) -> void:
	print(get_tree().get_node_count_in_group("projectile"))
