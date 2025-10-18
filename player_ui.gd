class_name PlayerUI
extends Control
var currently_targeted_enemy : Area3D
var enemy : Enemy
var hitmarker_timer : float = .2

func set_ammo(current : int, max_ammo : int, reserve : int, is_reloading : bool):
	var text_to_set : String = "reloading" if is_reloading else str(current) + "/" + str(max_ammo) + "   |   " +  str(reserve)
	$MarginContainer/AmmoText.text = text_to_set
	
	
func _process(delta: float) -> void:
	hitmarker_timer -= delta
	$MarginContainer2/MarginContainer/Hitmarker.visible = hitmarker_timer > 0
		
	if currently_targeted_enemy != null:
		enemy = currently_targeted_enemy.get_parent()
		$EnemyInfoContainer.visible = true
		$EnemyInfoContainer/EnemyName.text = enemy.name
		$EnemyInfoContainer/MarginContainer3/AspectRatioContainer/EnemyHealthBar.value = enemy.health
		$EnemyInfoContainer/MarginContainer3/AspectRatioContainer/EnemyHealthBar.max_value = enemy.max_health
	else:
		$EnemyInfoContainer.visible = false
	$FPS.text = str(Engine.get_frames_per_second())
	
func show_hitmarker():
	hitmarker_timer = .2
	
func reparent_loot_window(parent : Enemy):
	for child in get_children():
		if child.name == "LootWindow":
			child.queue_free()
			return
	#
