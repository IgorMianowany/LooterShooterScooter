class_name Player
extends CharacterBody3D

const TILT_LOWER_LIMIT := deg_to_rad(-90.0)
const TILT_UPPER_LIMIT := deg_to_rad(90.0)

var speed : float = 15
var sprint_multi : float = 1.5
var is_sprinting : bool = false
var jump_velocity = 20
var mouse_input : bool = false
var mouse_rotation : Vector3
var rotation_input : float
var tilt_input : float
var player_rotation : Vector3
var camera_rotation : Vector3
var aimed_at_enemy : Enemy = null
var dash_ready : bool = true

@export var camera_controller : Camera3D
@export var mouse_sensitivity : float = 0.15
@export var weapon : Weapon

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _exit():
	get_tree().quit()
	
func _process(_delta: float) -> void:
	$PlayerUI.set_ammo(weapon._get_current_magazine_size(), weapon._get_max_magazine_size(), weapon._get_ammo_reserve(), weapon.is_reloading)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >= 0:
			velocity += get_gravity() * 2.5 * delta
		else:
			velocity += get_gravity() * delta * 4
	else:
		dash_ready = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_pressed("sprint") and is_on_floor():
		is_sprinting = true
	if Input.is_action_just_released("sprint"):
		is_sprinting = false

	var input_direction = Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	var end_speed : float = speed + (speed * sprint_multi * int(is_sprinting))
	if direction:
		$AnimationPlayer.play("walk")
		velocity.x = direction.x * end_speed
		velocity.z = direction.z * end_speed
	else:
		velocity.x = move_toward(velocity.x, 0, end_speed)
		velocity.z = move_toward(velocity.z, 0, end_speed)
	if velocity.x == 0 and velocity.z == 0:
		$AnimationPlayer.stop()
	
	if Input.is_action_pressed("shoot"):
		weapon.start_shooting.emit()
		shoot()
		
	if Input.is_action_just_released("shoot"):
		weapon.stop_shooting.emit()
	
	$PlayerUI.currently_targeted_enemy = $Camera3D/RayCast3D.get_collider()
	
	update_camera(delta)
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"):
		reload()
	if event.is_action_pressed("sprint") and not is_on_floor() and dash_ready:
		dash()

	
func dash():
	dash_ready = false
	speed *= 5
	velocity.y = 0
	await(get_tree().create_timer(.15).timeout)
	speed = 15
	await(get_tree().create_timer(1).timeout)
	dash_ready = true
	
func _unhandled_input(event):
	mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if mouse_input:
		rotation_input = -event.relative.x * mouse_sensitivity
		tilt_input = -event.relative.y * mouse_sensitivity
	if event.is_action_pressed("exit"):
		_exit()

func update_camera(delta):
	mouse_rotation.x += tilt_input * delta
	mouse_rotation.x = clamp(mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	mouse_rotation.y += rotation_input * delta
	
	player_rotation = Vector3(0.0,mouse_rotation.y,0.0)
	camera_rotation = Vector3(mouse_rotation.x,0.0,0.0)
	
	camera_controller.transform.basis = Basis.from_euler(camera_rotation)
	camera_controller.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(player_rotation)
	
	rotation_input = 0.0
	tilt_input = 0.0
	
func shoot():
	#$Camera3D/WeaponsBackpack.weapon_1._shoot()
	weapon._shoot()

func reload():
	weapon._reload()
	
func hitmark():
	$PlayerUI.show_hitmarker()
	
	
	
