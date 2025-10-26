class_name GameManager
extends Node

@export var obstacles : Node3D
var speed : float = 10

func _process(delta: float) -> void:
	obstacles.global_position.z += speed * delta
