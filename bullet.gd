class_name Bullet
extends Node3D

var lifetime : float = 5
var speed : float = 250
var direction : Vector3 
var is_owner_player : bool = true
var weapon : Weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)
	direction = global_position.direction_to($Tip.global_position)
	$Hitbox.bullet = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime < 0:
		queue_free()
		
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	
func hitmark():
	weapon.hitmark()
