class_name ItemSlot
extends Control

var item : Item

func _on_texture_button_pressed() -> void:
	print(get_parent().name +  " " + name)
	
func update_item_info():
	$MarginContainer/TextureButton.texture_normal = item.item_texture
	$MarginContainer/Label.text = str(item.quantity)
