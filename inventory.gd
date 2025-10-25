class_name Inventory
extends Node3D

var items : Array[Item]
var can_open_inventory : bool = false
var is_enemy_inventory : bool = false
signal new_item_added

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
	
func _set_collision_shape_radius(rad : float):
	$LootRange/CollisionShape3D.shape = SphereShape3D.new()
	$LootRange/CollisionShape3D.shape.radius = rad

func take_item(item : Item) -> Item:
	var taken_item = items.pop_at(items.find(item))
	return taken_item

func add_item(new_item : Item):
	for item in items:
		if item.id == new_item.id:
			item.quantity += new_item.quantity
			return
	items.append(new_item)
	new_item_added.emit(new_item)

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

func create_loot_window(new_inventory : Inventory) -> LootWindow:
	var loot_window = load("res://loot_window.tscn").instantiate()
	loot_window.current_inventory = self
	loot_window.new_inventory = new_inventory
	for item in items:
		loot_window.add_item(item)
	return loot_window
	
func _on_loot_range_area_entered(area: Area3D) -> void:
	var player = area.get_parent() as Player
	if can_open_inventory:
		player.modify_interact_in_range(1)
		player.show_loot_ui(self, create_loot_window(player.inventory))

func _on_loot_range_area_exited(area: Area3D) -> void:
	var player = area.get_parent() as Player
	if can_open_inventory:
		player.modify_interact_in_range(-1)
	if items.size() == 0:
		can_open_inventory = false
	player.hide_loot_ui()
