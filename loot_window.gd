class_name LootWindow
extends Control

var current_inventory : Inventory
var new_inventory : Inventory

func add_item(item : Item):
	var item_slot = load("res://item_slot.tscn").instantiate()
	item_slot.current_inventory = current_inventory
	item_slot.new_inventory = new_inventory
	item_slot.item = item
	item_slot.update_item_info()
	$Panel/MarginContainer/VBoxContainer/Row1.add_child(item_slot)
	
