class_name Zombie
extends Enemy

@export var outline_shader : Material = preload("res://materials/outline_material.tres")

func _ready() -> void:
	super()
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
	$RayCastHitbox/CollisionShape3D.transform = $RayCastHitbox/AfterDeathCollision.transform
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
		
func _change_outline(should_turn_outline_on : bool):
	if should_turn_outline_on:
		($"character-l/root/leg-left" as MeshInstance3D).material_overlay = outline_shader
		($"character-l/root/leg-right" as MeshInstance3D).material_overlay = outline_shader
		($"character-l/root/torso" as MeshInstance3D).material_overlay = outline_shader
		($"character-l/root/torso/arm-left" as MeshInstance3D).material_overlay = outline_shader
		($"character-l/root/torso/arm-right" as MeshInstance3D).material_overlay = outline_shader
		($"character-l/root/torso/head" as MeshInstance3D).material_overlay = outline_shader

	else:
		($"character-l/root/leg-left" as MeshInstance3D).material_overlay = null
		($"character-l/root/leg-right" as MeshInstance3D).material_overlay = null
		($"character-l/root/torso" as MeshInstance3D).material_overlay = null
		($"character-l/root/torso/arm-left" as MeshInstance3D).material_overlay = null
		($"character-l/root/torso/arm-right" as MeshInstance3D).material_overlay = null
		($"character-l/root/torso/head" as MeshInstance3D).material_overlay = null
