class_name WeaponsBackpack
extends Node3D

var weapon_1 : Weapon
var weapon_2 : Weapon
@export var player : Player

func _ready() -> void:
	weapon_1 = $Pistol
	weapon_1.player = player
