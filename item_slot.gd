class_name ItemSlot
extends Control

var item : Item
var current_inventory : Inventory
var new_inventory : Inventory
var hover_style_box : StyleBoxFlat

func _ready():
	hover_style_box = $MarginContainer/Panel.get_theme_stylebox("panel").duplicate()
	hover_style_box.border_width_top = 1
	hover_style_box.border_width_left = 1
	hover_style_box.border_width_right = 1
	hover_style_box.border_width_bottom = 1
	hover_style_box.border_color = Color(0.775, 0.775, 0.775, 1.0)
	$MarginContainer/Selected.visible = false

func _on_texture_button_pressed() -> void:
	print(get_parent().name +  " " + item.item_name)
	if new_inventory == null:
		return
	new_inventory.add_item((current_inventory.take_item(item)))
	queue_free()

func update_item_info():
	$MarginContainer/TextureButton.texture_normal = item.item_texture
	$MarginContainer/Label.text = str(item.quantity)

func _on_texture_button_mouse_entered() -> void:
	$MarginContainer/Selected.visible = true
	$MarginContainer/Panel.add_theme_stylebox_override("panel", hover_style_box)
	#$MarginContainer/Panel.get_theme_stylebox("panel").border_width_right = 1
	#$MarginContainer/Panel.get_theme_stylebox("panel").border_width_left = 1
	#$MarginContainer/Panel.get_theme_stylebox("panel").border_width_top = 1
	#$MarginContainer/Panel.get_theme_stylebox("panel").border_width_bottom = 1

func _on_texture_button_mouse_exited() -> void:
	$MarginContainer/Selected.visible = false
	$MarginContainer/Panel.remove_theme_stylebox_override("panel")
	#$MarginContainer/Panel.get_theme_stylebox("panel").border_width_right = 0
	#$MarginContainer/Panel.get_theme_stylebox("panel").border_width_left = 0
	#$MarginContainer/Panel.get_theme_stylebox("panel").border_width_top = 0
	#$MarginContainer/Panel.get_theme_stylebox("panel").border_width_bottom = 0
