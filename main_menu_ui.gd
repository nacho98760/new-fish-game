extends Control


@onready var player: Player = get_tree().get_first_node_in_group("Player")


func _on_play_button_pressed():
	self.visible = false
	get_tree().paused = false
	player.visible = true


func _on_quit_button_pressed():
	GameManager.save_game()
	get_tree().quit()
