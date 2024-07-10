extends Panel

signal buy_button_pressed

func _on_buy_button_pressed():
	buy_button_pressed.emit()

