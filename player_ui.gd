class_name PlayerUI
extends Control

var currently_targeted_enemy : Area3D
var enemy : Enemy
var hitmarker_timer : float = .2
var is_mouse_swallowing_ui_open : bool = false
var player_loot_window : LootWindow
var new_loot_window : LootWindow

func _ready():
	EventBus.enemy_hit.connect(show_hitmarker)

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


func show_hitmarker(is_kill_shot : bool):
	$MarginContainer2/MarginContainer/Hitmarker.modulate = Color.RED if is_kill_shot else Color.WHITE
	hitmarker_timer = .2
	
func remove_loot_window_if_exists():
	is_mouse_swallowing_ui_open = false
	for child in $Inventories.get_children():
		child.queue_free()
			
func reparent_loot_window():
	is_mouse_swallowing_ui_open = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	remove_loot_window_if_exists()

func add_loot_window(_player_loot_window : LootWindow, _new_loot_window : LootWindow):
	if player_loot_window != null and new_loot_window != null:
		is_mouse_swallowing_ui_open = true
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		$Inventories.add_child(player_loot_window)
		$Inventories.add_child(new_loot_window)
	
func add_closest_loot_window(_player_loot_window : LootWindow, _new_loot_window : LootWindow):
	player_loot_window = _player_loot_window
	new_loot_window = _new_loot_window
	
func show_equipment(items : Array[Item]):
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	var loot_window = load("res://loot_window.tscn").instantiate()
	for item in items:
		loot_window.add_item(item)
	$Inventories.add_child(loot_window)
