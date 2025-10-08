class_name Weapon
extends Node3D

var active : bool = false
var bullet_spawn : Marker3D
var player : Player

signal start_shooting
signal stop_shooting

func _shoot():
	(get_children()[0] as Pistol)._shoot()
	
func _reload():
	for child in get_children():
		(child as Weapon)._reload()
