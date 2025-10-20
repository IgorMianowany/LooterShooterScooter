class_name ItemSlot
extends Control

var item : Item
var current_inventory : Inventory
var new_inventory : Inventory

func _on_texture_button_pressed() -> void:
	print(get_parent().name +  " " + item.item_name)
	if new_inventory == null:
		return
	new_inventory.add_item((current_inventory.take_item(item)))
	queue_free()
	#if not item.is_taken:
		#current_inventory
		#item.is_taken = true
		#queue_free()
	
func update_item_info():
	$MarginContainer/TextureButton.texture_normal = item.item_texture
	$MarginContainer/Label.text = str(item.quantity)
