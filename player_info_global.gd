#class_name PlayerInfoGlobal
extends Node

var equipment : Array[Item]

func add_item_to_equipment(new_item : Item):
	for item in equipment:
		if item.id == new_item.id:
			item.quantity += new_item.quantity
			return
	equipment.append(new_item)
