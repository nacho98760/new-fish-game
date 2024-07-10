extends Panel

signal buy_button_pressed

@onready var buy_button = $NinePatchRect/CenterContainer/Panel/CenterContainer/Panel/BuyButton
@onready var sprite_2d = $NinePatchRect/CenterContainer/Panel/CenterContainer/Panel/BuyButton/Sprite2D

func _on_buy_button_pressed():
	buy_button_pressed.emit()

