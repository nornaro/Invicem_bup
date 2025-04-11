extends ItemList

@export var menu = {
	"Academy": [],
	"Barrack": [],
	"Forge": [],
	"Market": [],
	"Tower": ["Turret >"],
	"Castle": [],
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_selected(_index):
	get_selected_items()
	hide()
