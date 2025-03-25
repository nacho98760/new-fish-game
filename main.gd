extends Node2D

var is_close_menu_open: bool = false

var is_tutorialUI_open: bool = false

@onready var bg_music = $BackgroundMusic
@onready var sound_sprite = $CanvasLayer/SoundPanel/NinePatchRect/NinePatchRect/SoundSprite

@onready var shop_UI = get_tree().get_first_node_in_group("ShopUI")
@onready var settings_UI = $CanvasLayer/SettingsUI

@onready var open_shop_button: Button = $Shop/ShopConceptArea/OpenShopButton
@onready var anim_player = $AnimationPlayer

@onready var player = $Player
@onready var fish_index_UI: Control = get_tree().get_first_node_in_group("FishIndexUI")
@onready var game_tutorial_UI: Control = get_tree().get_first_node_in_group("GameTutorial")

@onready var main_menu_ui = $CanvasLayer/MainMenuUI


func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	resume_game()
	anim_player.play("water")
	
	


func _process(delta):
	if main_menu_ui.visible:
		get_tree().paused = true

func _input(event) -> void:
	if event.is_action_pressed("close_game") and main_menu_ui.visible == false:
		if is_close_menu_open == false:
			pause_game()
		else:
			resume_game()


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
	if body.name == "Player" and fish_index_UI.visible == false:
		open_shop_button.visible = true
func _on_shop_concept_area_body_exited(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		open_shop_button.visible = false

func _on_open_shop_button_pressed() -> void:
	shop_UI.position = Vector2(player.position.x - shop_UI.pivot_offset.x, player.position.y - 130)
	shop_UI.visible = true
	get_tree().paused = true


func _on_settings_button_pressed():
	if settings_UI.visible:
		settings_UI.visible = false
		get_tree().paused = false
	else:
		settings_UI.visible = true
		get_tree().paused = true



