extends Control

func _on_texture_button_pressed() -> void:
	print(get_parent().name +  " " + name)
