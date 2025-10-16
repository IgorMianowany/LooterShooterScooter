class_name Hitbox
extends Area3D

@export var damage : float = 10
var hits : int = 0
var max_hits : int = 1
var enemies_already_hit : Array[Enemy]
var bullet : Bullet

func _process(_delta: float) -> void:
	if enemies_already_hit.size() >= max_hits:
		queue_free()
		
func hitmark():
	bullet.hitmark()
