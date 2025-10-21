class_name Hut
extends StaticBody3D

func _ready():
	$Inventory.can_open_inventory = true
	$Inventory._set_collision_shape_radius(10)
