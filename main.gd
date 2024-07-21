extends Node2D

var is_close_menu_open: bool = false

@onready var open_shop_button: Button = $Shop/ShopConceptArea/OpenShopButton

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	resume_game()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("close_game"):
		if is_close_menu_open == false:
			pause_game()

func pause_game() -> void:
	$CanvasLayer/CloseGamePanel.visible = true
	is_close_menu_open = true
	get_tree().paused = true
	
func resume_game() -> void:
	$CanvasLayer/CloseGamePanel.visible = false
	is_close_menu_open = false
	get_tree().paused = false

func _on_save_and_quit_button_pressed() -> void:
	GameManager.save_game()
	get_tree().quit()

func _on_resume_button_pressed() -> void:
	resume_game()
	
func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		pause_game()

func _on_shop_concept_area_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		open_shop_button.visible = true
func _on_shop_concept_area_body_exited(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		open_shop_button.visible = false

func _on_open_shop_button_pressed() -> void:
	$Shop/ShopUI.visible = true
	get_tree().paused = true
