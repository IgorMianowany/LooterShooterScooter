class_name Hut
extends StaticBody3D

var storage : Array[Item]

func create_loot_window() -> LootWindow:
	var loot_window = load("res://loot_window.tscn").instantiate()
	for item in storage:
		loot_window.add_item(item)
	return loot_window




func _on_loot_range_area_entered(area: Area3D) -> void:
	(area.get_parent() as Player).show_loot_ui(create_loot_window())



func _on_loot_range_area_exited(area: Area3D) -> void:
	(area.get_parent() as Player).hide_loot_ui()

			
