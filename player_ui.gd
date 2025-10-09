extends Control

func set_ammo(current : int, max : int, reserve : int):
	$MarginContainer/Label.text = str(current) + "/" + str(max) + "   |   " + str(reserve)
