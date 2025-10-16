class_name Hurtbox
extends Area3D

@export var is_crit : bool = false

func _on_area_entered(area: Area3D) -> void:
	var hitbox : Hitbox = area as Hitbox
	if owner.has_method("take_damage") and not hitbox.enemies_already_hit.has(get_parent()):
		hitbox.enemies_already_hit.append(get_parent())
		owner.take_damage(hitbox.damage if not is_crit else hitbox.damage * 2, is_crit)
		
		hitbox.hitmark()
