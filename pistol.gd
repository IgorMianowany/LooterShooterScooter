class_name Pistol
extends Weapon

var shot : bool = false

func _ready() -> void:
	stop_shooting.connect(handle_stop_shooting)
	active = true

func _shoot():
	if not shot:
		shot = true

func handle_stop_shooting():
	shot = false
