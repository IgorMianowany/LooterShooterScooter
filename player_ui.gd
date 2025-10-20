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
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		remove_loot_window_if_exists()
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func show_hitmarker():
	hitmarker_timer = .2
	
func remove_loot_window_if_exists():
	for child in get_children():
		if child.name == "LootWindow":
			child.queue_free()
			return
			
func reparent_loot_window():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	remove_loot_window_if_exists()
	
func add_loot_window(ui : LootWindow):
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	add_child(ui)
	
func show_equipment(items : Array[Item]):
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	var loot_window = load("res://loot_window.tscn").instantiate()
	for item in items:
		loot_window.add_item(item)
	add_child(loot_window)
