class_name Hut
extends StaticBody3D

var storage : Array[Item]

func create_loot_window(new_inventory : Inventory) -> LootWindow:
	var loot_window = load("res://loot_window.tscn").instantiate()
	loot_window.current_inventory = $Inventory
	loot_window.new_inventory = new_inventory
	for item in $Inventory.items:
		loot_window.add_item(item)
	return loot_window

func _on_loot_range_area_entered(area: Area3D) -> void:
	var player = area.get_parent() as Player
	player.show_loot_ui(create_loot_window(player.inventory))



func _on_loot_range_area_exited(area: Area3D) -> void:
	(area.get_parent() as Player).hide_loot_ui()

			
