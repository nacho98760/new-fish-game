extends Control

@onready var sell_one_button: Button = $Background/InnerBackground/HBoxContainer/SellOne
@onready var sell_all_button: Button = $Background/InnerBackground/HBoxContainer/SellAll

func _on_close_shop_panel_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false


func get_sell_one_button() -> Button:
	return sell_one_button

func get_sell_all_button() -> Button:
	return sell_all_button
