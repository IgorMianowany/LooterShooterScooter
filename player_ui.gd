extends Control

func set_ammo(current : int, max_ammo : int, reserve : int, is_reloading : bool):
	var text_to_set : String = "reloading" if is_reloading else str(current) + "/" + str(max_ammo) + "   |   " +  str(reserve)
	$MarginContainer/Label.text = text_to_set
