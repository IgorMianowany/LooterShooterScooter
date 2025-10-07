class_name Bullet
extends Node3D

var lifetime : float = 5
var speed : float = 10
var direction : Vector3 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)
	direction = Vector3(0,0,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * speed * delta
	lifetime -= delta
	if lifetime < 0:
		queue_free()
