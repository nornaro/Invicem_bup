extends TextEdit

func _ready() -> void:
	connect("text_changed",_on_join_data_text_changed)


func _on_join_data_text_changed() -> void:
	Global.join_data = text
