extends Control


func _ready():
	pass

func _on_close_shop_panel_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false
