class_name Pistol
extends Weapon

var shot : bool = false
var bullet_scene := preload("res://bullet.tscn")

func _ready() -> void:
	stop_shooting.connect(handle_stop_shooting)
	active = true
	bullet_spawn = $Marker3D

func _shoot():
	if not shot:
		shot = true
		var bullet : Bullet = bullet_scene.instantiate()
		add_child(bullet)
		bullet.direction = Vector3(0, bullet_spawn.global_position.y, 0).direction_to(bullet_spawn.global_position)
		bullet.global_position = bullet_spawn.global_position
		

func handle_stop_shooting():
	shot = false
