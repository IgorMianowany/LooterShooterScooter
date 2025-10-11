class_name Zombie
extends Enemy

var move_dir : Vector3 

func _process(delta):
	super(delta)
	$"character-l".look_at(Vector3.FORWARD)
	$"character-l".rotate(Vector3(0,1,0), deg_to_rad(180))
