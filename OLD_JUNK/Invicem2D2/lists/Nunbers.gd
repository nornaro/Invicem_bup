extends ItemList


# Called when the node enters the scene tree for the first time.
func update(size):
	clear()
	for i in size:
		add_item(str(i),null,false)
