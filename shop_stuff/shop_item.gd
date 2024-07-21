extends Panel

signal buy_button_pressed

@onready var sprite2d: Sprite2D = $NinePatchRect/CenterContainer/Panel/CenterContainer/Panel/BuyButton/Sprite2D

func get_sprite() -> Sprite2D:
	return sprite2d

func _on_buy_button_pressed() -> void:
	buy_button_pressed.emit()

