class_name Enemy
extends Node3D

var health : float = 100
var max_health : float = 100
@export var player : Player

func _process(_delta):
	look_at(player.global_position)
	rotate(Vector3(0,1,0), deg_to_rad(180))

func take_damage(damage : float):
	health -= damage
	_display_damage(damage)
	if health <= 0:
		await(get_tree().create_timer(.5).timeout)
		queue_free()


func _on_player_detection_range_area_entered(area: Area3D) -> void:
	print(area.name)
	
func _display_damage(damage : float, is_critical : bool = false):
	if damage <= 0:
		return
	var value : int = int(damage)
	var number = Label.new()
	$SubViewport.add_child(number)
	number.position = Vector2(10,20)
	number.position += Vector2(randf_range(-25,25), randf_range(-25,25))
	number.visible = true
	number.scale = Vector2.ONE
	number.text = str(value)
	number.label_settings = LabelSettings.new()
	
	var color = "#fff"
	if is_critical:
		color = "#b22"
	if value == 0:
		color = "fff8"
	number.label_settings.font_color = color
	number.label_settings.font_size = 40
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	
	number.pivot_offset = Vector2(number.size / 2)
	 
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
