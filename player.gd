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
var is_mouse_swallowing_ui_open : bool = false
var equipment : Array[Item] : get = get_equipment
var inventory : Inventory
var playerUI : PlayerUI

@export var camera_controller : Camera3D
@export var mouse_sensitivity : float = 0.15
@export var weapon : Weapon

func get_equipment() -> Array[Item]:
	return PlayerInfo.equipment

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inventory = $Inventory
	playerUI = $PlayerUI
	
func _exit():
	get_tree().quit()
	
func _process(_delta: float) -> void:
	playerUI.set_ammo(weapon._get_current_magazine_size(), weapon._get_max_magazine_size(), weapon._get_ammo_reserve(), weapon.is_reloading)
	is_mouse_swallowing_ui_open = playerUI.is_mouse_swallowing_ui_open
	
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
	
	if Input.is_action_pressed("shoot") and not is_mouse_swallowing_ui_open:
		weapon.start_shooting.emit()
		shoot()
		
	if Input.is_action_just_released("shoot") and not is_mouse_swallowing_ui_open:
		weapon.stop_shooting.emit()
	
	playerUI.change_targeted_enemy($Camera3D/RayCast3D.get_collider())
	#playerUI.currently_targeted_enemy = $Camera3D/RayCast3D.get_collider()
	
	update_camera(delta)
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if is_mouse_swallowing_ui_open:
		return
	if event.is_action_pressed("reload"):
		reload()
	if event.is_action_pressed("sprint") and not is_on_floor() and dash_ready:
		dash()
	if event.is_action_pressed("switch_weapon_1"):
		weapon.visible = false
		weapon = $Camera3D/WeaponsBackpack.weapon_1
		weapon.visible = true
	if event.is_action_pressed("switch_weapon_2"):
		weapon.visible = false
		weapon = $Camera3D/WeaponsBackpack.weapon_2
		weapon.visible = true
	if event.is_action_pressed("open_equipment"):
		show_equipment()
	if event.is_action_pressed("interact"):
		playerUI.add_loot_window(null, null)
	
func dash():
	dash_ready = false
	speed *= 5
	velocity.y = 0
	await(get_tree().create_timer(.15).timeout)
	speed = 15
	await(get_tree().create_timer(1).timeout)
	dash_ready = true
	
func _unhandled_input(event):
	if is_mouse_swallowing_ui_open:
		return
	mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if mouse_input:
		rotation_input = -event.relative.x * mouse_sensitivity
		tilt_input = -event.relative.y * mouse_sensitivity
	if event.is_action_pressed("close_game"):
		_exit()
		#pass

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
	weapon._shoot()

func reload():
	weapon._reload()
	
func show_loot_ui(new_inventory : Inventory, new_loot_window : LootWindow):
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	#maybe do this on tree_exited/tree_exiting signal to make sure it's called
	playerUI.add_closest_loot_window(inventory.create_loot_window(new_inventory), new_loot_window)
	
func hide_loot_ui():
	playerUI.reparent_loot_window()
	
func show_equipment():
	get_tree().paused = true
	playerUI.show_equipment($Inventory.items)

func modify_interact_in_range(modify_value : int):
	playerUI.modify_interact(modify_value)
