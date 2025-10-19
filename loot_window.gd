class_name LootWindow
extends Control

func add_item(item : Item):
	var item_slot = load("res://item_slot.tscn").instantiate()
	item_slot.item = item
	item_slot.update_item_info()
	$Panel/MarginContainer/VBoxContainer/Row1.add_child(item_slot)
