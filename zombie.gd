class_name Zombie
extends Enemy

func _ready() -> void:
	speed = 300
	health = 100

func _physics_process(delta: float) -> void:
	if health <= 0:
		return
	super(delta)
	if velocity > Vector3.ZERO and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("walk")
	
func _die():
	super()
	$AnimationPlayer.play("die")
	
func take_damage(damage : float, is_crit : bool = false):
	speed = 200
	if (randf_range(0,1) <= knockback_chance or is_crit) and knockback_cooldown <= 0:
		knockback_cooldown = 2
		knockback_speed = 400
		is_knocked_back = true
	$AnimationPlayer.play("headshot")
	super(damage, is_crit)
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		await(get_tree().create_timer(1).timeout)
		#queue_free()
	else:
		speed = 300
		knockback_speed = 0
		is_knocked_back = false
