class_name Pistol
extends Weapon

var shot : bool = false
var bullet_scene := preload("res://bullet.tscn")
var original_transform : Transform3D
var cooldown : float = 0
var cooldown_time : float = .25

func _ready() -> void:
	#stop_shooting.connect(handle_stop_shooting)
	active = true
	bullet_spawn = $BulletSpawn
	original_transform = $GunModel.transform
	current_magazine_size = max_magazine_size
	ammo_reserve = 100
	
func _process(delta: float) -> void:
	cooldown -= delta
	if(cooldown <= 0):
		handle_stop_shooting()

func _shoot():
	if not is_reloading and not shot and current_magazine_size > 0:
		current_magazine_size -= 1
		cooldown = cooldown_time
		animate_recoil()
		shot = true
		var bullet : Bullet = bullet_scene.instantiate()
		add_child(bullet)
		bullet.global_position = bullet_spawn.global_position
		

func handle_stop_shooting():
	shot = false
	
func animate_recoil():
	var tween = get_tree().create_tween()
	tween.tween_property($GunModel, "transform", Transform3D($GunModel.transform).rotated(Vector3(1,0,0).normalized(), deg_to_rad(45) + $GunModel.rotation.x), .1)
	tween.tween_property($GunModel, "transform", original_transform, .2)
	
func _reload():
	if is_reloading:
		return
	is_reloading = true
	await(get_tree().create_timer(reload_time).timeout)
	var amount_to_take = max_magazine_size - current_magazine_size
	var amount_taken = amount_to_take if ammo_reserve > amount_to_take else ammo_reserve
	ammo_reserve -= amount_taken
	current_magazine_size += amount_taken
	is_reloading = false
