class_name Enemy
extends Node3D

var health : float = 100

func _ready() -> void:
	$SubViewport/TextureProgressBar.max_value = health

func _process(_delta: float) -> void:
	$SubViewport/TextureProgressBar.value = health

func take_damage(damage : float):
	health -= damage
	if health <= 0:
		await(get_tree().create_timer(.5).timeout)
		queue_free()
