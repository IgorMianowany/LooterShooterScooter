class_name Weapon
extends Node3D

var active : bool = false
var bullet_spawn : Marker3D
var player : Player

signal start_shooting
signal stop_shooting

func _shoot():
	#(get_children()[0] as Pistol)._shoot()
	pass
	
func _reload():
	#for child in get_children():
		#(child as Weapon)._reload()
	pass
		
func _get_max_magazine_size() -> int:
	return 10
	
func _get_current_magazine_size() -> int:
	return 5
	
func _get_ammo_reserve() -> int:
	return 50
