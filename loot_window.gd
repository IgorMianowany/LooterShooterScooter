class_name LootWindow
extends Control

var current_inventory : Inventory
var new_inventory : Inventory
var row1 : HBoxContainer
var rows : VBoxContainer
var label : Label

func _ready() -> void:
	EventBus.inventory_changed.connect(update_items)
	label = find_child("Owner", true)
	if current_inventory != null:
		current_inventory.new_item_added.connect(add_item)
		label.text = current_inventory.get_parent().name
	else:
		label.text = "Player"
		
func add_item(item : Item):
	var item_slot = load("res://item_slot.tscn").instantiate()
	item_slot.current_inventory = current_inventory
	item_slot.new_inventory = new_inventory
	item_slot.item = item
	item_slot.update_item_info()
	
	## TODO logic for placing items in correct rows would go here
	if row1 == null:
		row1 = find_child("Row1", true)
	row1.add_child(item_slot)
	
func update_items():
	if rows == null:
		rows = find_child("Rows", true)
	for row in rows.get_children():
		for item_slot in row.get_children():
			(item_slot as ItemSlot).update_item_info()
	
