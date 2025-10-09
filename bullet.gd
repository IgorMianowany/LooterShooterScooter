class_name Bullet
extends Node3D

var lifetime : float = 5
var speed : float = 150
var direction : Vector3 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)
	direction = global_position.direction_to($Tip.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime < 0:
		queue_free()
		
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
