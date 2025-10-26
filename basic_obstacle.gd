class_name BasicObstacle
extends StaticBody3D

var health : float = 100
@onready var mesh_instance : MeshInstance3D = $MeshInstance3D
var mesh_material : StandardMaterial3D = preload("res://materials/basic_obstacle_material.tres").duplicate()

func _ready() -> void:
	#mesh_instance.material_overlay = mesh_material
	mesh_instance.material_overlay = mesh_material

func _process(_delta: float) -> void:
	pass
	
func take_damage(damage : float, is_crit : bool):
	health -= damage
	if is_crit:
		health -= damage
	mesh_material.albedo_color.r = (health + 75)/255 # color is a value from 0 to 1, which is the value of RGB divided by max (255)
	if health <= 0:
		queue_free()
		
