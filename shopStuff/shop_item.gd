extends Panel

signal buy_button_pressed

@onready var sprite2d = $NinePatchRect/CenterContainer/Panel/CenterContainer/Panel/BuyButton/Sprite2D

func get_sprite():
	return sprite2d

func _on_buy_button_pressed():
	buy_button_pressed.emit()

