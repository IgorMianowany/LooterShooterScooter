class_name Inventory
extends Node3D

var items : Array[Item]

func _ready():
	var item = Item.new()
	item.id = 1
	item.item_name = "Crown"
	item.quantity = randf_range(1,5)
	item.item_texture = preload("res://textures/items/crown.png")
	var item2 = Item.new()
	item2.id = 2
	item2.item_name = "Gold"
	item2.quantity = randf_range(1,5)
	item2.item_texture = preload("res://textures/items/gold.png")
	items.append(item)
	items.append(item2)

func take_item(item : Item) -> Item:
	return items.pop_at(items.find(item))

func add_item(new_item : Item):
	for item in items:
		if item.id == new_item.id:
			item.quantity += new_item.quantity
			return
	items.append(new_item)
	
func show_inventory():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	var loot_window = load("res://loot_window.tscn").instantiate()
	for item in items:
		loot_window.add_item(item)
	add_child(loot_window)

func close_inventory():
	for child in get_children():
		if child is LootWindow:
			child.queue_free()
			return
