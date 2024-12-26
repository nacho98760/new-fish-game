extends Panel

signal buy_button_pressed

@onready var rod_model_color: Sprite2D = $NinePatchRect/CenterContainer/Panel/CenterContainer/Panel/RodModelColor
@onready var sprite2d: Sprite2D = $NinePatchRect/CenterContainer/Panel/CenterContainer/Panel/BuyButton/Sprite2D
@onready var rod_price_label: Label = $NinePatchRect/CenterContainer/Panel/CenterContainer/Panel/RodPricePanel/Label

func get_rod_model_color() -> Sprite2D:
	return rod_model_color

func get_sprite() -> Sprite2D:
	return sprite2d

func get_rod_price_label() -> Label:
	return rod_price_label

func _on_buy_button_pressed() -> void:
	buy_button_pressed.emit()

