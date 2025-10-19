class_name ItemSlot
extends Control

var item : Item

func _on_texture_button_pressed() -> void:
	print(get_parent().name +  " " + item.item_name)
	if not item.is_taken:
		PlayerInfo.equipment.append(item)
		item.is_taken = true
		queue_free()
	
func update_item_info():
	$MarginContainer/TextureButton.texture_normal = item.item_texture
	$MarginContainer/Label.text = str(item.quantity)
