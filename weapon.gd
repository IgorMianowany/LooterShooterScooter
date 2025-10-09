class_name Weapon
extends Node3D

var active : bool = false
var bullet_spawn : Marker3D
var player : Player
var current_magazine_size : int = 5
var max_magazine_size : int = 10
var ammo_reserve : int = 50

signal start_shooting
signal stop_shooting

func _shoot():
	#(get_children()[0] as Pistol)._shoot()
	pass
	
func _reload():
	#for child in get_children():
		#(child as Weapon)._reload()
	pass
	
func _get_current_magazine_size() -> int:
	return current_magazine_size
func _get_max_magazine_size() -> int:
	return max_magazine_size
func _get_ammo_reserve() -> int:
	return ammo_reserve
