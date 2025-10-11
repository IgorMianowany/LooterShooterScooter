class_name Zombie
extends Enemy

func _ready() -> void:
	speed = 300
	health = 1000

func _physics_process(delta: float) -> void:
	super(delta)
	
