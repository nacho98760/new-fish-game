extends Node2D

var is_close_menu_open: bool = false

func _ready():
	get_tree().set_auto_accept_quit(false)
	resume_game()
	
func _process(delta):
	if Input.is_action_just_pressed("close_game"):
		if is_close_menu_open:
			resume_game()
		else:
			pause_game()

func pause_game():
	$CanvasLayer/CloseGamePanel.visible = true
	is_close_menu_open = true
	get_tree().paused = true
	
func resume_game():
	$CanvasLayer/CloseGamePanel.visible = false
	is_close_menu_open = false
	get_tree().paused = false

func _on_save_and_quit_button_pressed():
	GameManager.save_game()
	get_tree().quit()

func _on_resume_button_pressed():
	resume_game()
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		pause_game()
