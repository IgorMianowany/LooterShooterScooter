extends Area3D



func _on_area_entered(area: Area3D) -> void:
	if owner.has_method("take_damage"):
		owner.take_damage((area as Hitbox).damage)
