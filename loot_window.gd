class_name LootWindow
extends Control

var current_inventory : Inventory
var new_inventory : Inventory

func _ready() -> void:
	EventBus.inventory_changed.connect(update_items)
	current_inventory.new_item_added.connect(add_item)
	#EventBus.inventory_changed.connect(add_missing_items)

func add_item(item : Item):
	var item_slot = load("res://item_slot.tscn").instantiate()
	item_slot.current_inventory = current_inventory
	item_slot.new_inventory = new_inventory
	item_slot.item = item
	item_slot.update_item_info()
	$Panel/MarginContainer/VBoxContainer/Row1.add_child(item_slot)

#func add_missing_items():
	#if new_inventory.items.size() > $Panel/MarginContainer/VBoxContainer/Row1.get_children().size():
		#print(new_inventory.get_parent().name)
	
	
func update_items():
	for row in $Panel/MarginContainer/VBoxContainer.get_children():
		for item_slot in row.get_children():
			(item_slot as ItemSlot).update_item_info()
	
