extends Control

@onready var fish_frame = $NinePatchRect/MarginContainer/MainPanel/FishFrame/Sprite2D
@onready var fish_name = $NinePatchRect/MarginContainer/MainPanel/NinePatchRect/VBoxContainer/FishName
@onready var fish_rarity = $NinePatchRect/MarginContainer/MainPanel/NinePatchRect/VBoxContainer/FishRarity
@onready var fish_value = $NinePatchRect/MarginContainer/MainPanel/VBoxContainer/Stat1/FishValue
@onready var fish_width = $NinePatchRect/MarginContainer/MainPanel/VBoxContainer/Stat2/FishWidth
@onready var fish_weight = $NinePatchRect/MarginContainer/MainPanel/VBoxContainer/Stat3/FishHeight


func _on_close_shop_panel_button_pressed() -> void:
	self.visible = false

func get_fish_frame() -> Sprite2D:
	return fish_frame

func get_fish_name() -> Label:
	return fish_name

func get_fish_rarity() -> Label:
	return fish_rarity

func get_fish_value() -> Label:
	return fish_value

func get_fish_width() -> Label:
	return fish_width

func get_fish_weight() -> Label:
	return fish_weight
