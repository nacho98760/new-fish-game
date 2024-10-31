extends Panel

signal buy_button_pressed

@onready var rod_model_color: Sprite2D = $NinePatchRect/CenterContainer/Panel/CenterContainer/Panel/RodModelColor
@onready var sprite2d: Sprite2D = $NinePatchRect/CenterContainer/Panel/CenterContainer/Panel/BuyButton/Sprite2D
	
func get_rod_model_color():
	return rod_model_color

func get_sprite() -> Sprite2D:
	return sprite2d

func _on_buy_button_pressed() -> void:
	buy_button_pressed.emit()

