extends Control

@onready var fish_frame = $NinePatchRect/MarginContainer/MainPanel/FishFrame/Sprite2D
@onready var fish_name = $NinePatchRect/MarginContainer/MainPanel/NinePatchRect/VBoxContainer/FishName
@onready var fish_rarity = $NinePatchRect/MarginContainer/MainPanel/NinePatchRect/VBoxContainer/FishRarity
@onready var fish_value = $NinePatchRect/MarginContainer/MainPanel/VBoxContainer/Stat1/Label
@onready var fish_width = $NinePatchRect/MarginContainer/MainPanel/VBoxContainer/Stat2/Label
@onready var fish_weight = $NinePatchRect/MarginContainer/MainPanel/VBoxContainer/Stat3/Label


func _on_close_shop_panel_button_pressed():
	self.visible = false

func get_fish_frame():
	return fish_frame

func get_fish_name():
	return fish_name

func get_fish_rarity():
	return fish_rarity

func get_fish_value():
	return fish_value

func get_fish_width():
	return fish_width

func get_fish_weight():
	return fish_weight
