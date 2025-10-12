class_name Hitbox
extends Area3D

@export var damage : float = 10
var hits : int = 0
var max_hits : int = 1
var enemies_already_hit : Array[Enemy]

func _process(delta: float) -> void:
	if enemies_already_hit.size() >= max_hits:
		queue_free()
