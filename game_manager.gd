class_name GameManager
extends Node

@export var obstacles : Node3D
@export var speed : float = 0

func _process(delta: float) -> void:
	obstacles.global_position.z += speed * delta
