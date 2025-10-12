class_name Enemy
extends CharacterBody3D

var health : float = 100
var max_health : float = 100
var player : Player
var player_in_range : bool = false
var speed : float = 200
var move_dir : Vector3 
var is_knocked_back : bool = false
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * 2.5 * delta
	if player == null:
		return
	look_at(player.global_position)
	rotate(Vector3(0,1,0), deg_to_rad(180))
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player > 5 and player_in_range:
		move_dir = global_position.direction_to(player.global_position)
		#global_position += move_dir * speed * delta
		velocity = (move_dir * (-2 * int(is_knocked_back) + 1)) * speed * delta
	move_and_slide()


func take_damage(damage : float, is_crit : bool = false):
	health -= damage
	_display_damage(damage, is_crit)
	if health <= 0:
		_die()

func _on_player_detection_range_area_entered(area: Area3D) -> void:
	player_in_range = true
	player = area.get_parent()


func _on_player_detection_range_area_exited(_area: Area3D) -> void:
	player_in_range = false
	

func _display_damage(damage : float, is_critical : bool = false):
	if damage <= 0:
		return
	var value : int = int(damage)
	var number = Label3D.new()
	add_child(number)
	number.position += Vector3(randf_range(-2.5,2.5), 3.5, 2)
	number.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	number.visible = true
	number.scale = Vector3.ONE
	number.text = str(value)
	
	var color = "#fff"
	if is_critical:
		color = "#b22"
	if value == 0:
		color = "fff8"
	number.modulate = color
	number.font_size = 200
	number.outline_modulate = "#000"
	number.outline_size = 100
	
	#number.pivot_offset = Vector2(number.size / 2)
	 
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y + 3, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector3.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished

func _on_collision_area_area_entered(area: Area3D) -> void:
	var knockback_dir = area.global_position.direction_to(global_position)
	global_position += knockback_dir * .25
	
func _die():
	print("nic")
	queue_free()
