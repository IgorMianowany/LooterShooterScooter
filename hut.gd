class_name Hut
extends StaticBody3D

func _on_loot_range_area_entered(area: Area3D) -> void:
	var player = area.get_parent() as Player
	player.show_loot_ui($Inventory.create_loot_window(player.inventory))

func _on_loot_range_area_exited(area: Area3D) -> void:
	(area.get_parent() as Player).hide_loot_ui()

			
