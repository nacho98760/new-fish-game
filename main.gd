extends Node2D

var is_close_menu_open: bool = false

var temp 
var music_position = 0
@onready var bg_music = $AudioStreamPlayer2D
@onready var sound_sprite = $CanvasLayer/SoundPanel/NinePatchRect/NinePatchRect/SoundSprite

@onready var open_shop_button: Button = $Shop/ShopConceptArea/OpenShopButton
@onready var anim_player = $AnimationPlayer

@onready var player = $Player
@onready var game_tutorial_UI: Control = get_tree().get_first_node_in_group("GameTutorial")


func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	resume_game()
	anim_player.play("water")


func _process(delta):
	if player.visible == false:
		player.visible = true

func _input(event) -> void:
	if event.is_action_pressed("close_game"):
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
	if body.name == "Player":
		open_shop_button.visible = true
func _on_shop_concept_area_body_exited(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		open_shop_button.visible = false

func _on_open_shop_button_pressed() -> void:
	$Shop/ShopUI.visible = true
	get_tree().paused = true


func _on_mute_button_pressed():
	if bg_music.playing:
		temp = bg_music.get_playback_position()
		bg_music.stop()
		sound_sprite.texture = preload("res://assets/icons/sound_off.png")
	else:
		bg_music.play()
		bg_music.seek(temp)
		sound_sprite.texture = preload("res://assets/icons/sound_on.png")


func _on_open_tutorial_menu_button_pressed():
	game_tutorial_UI.visible = true
	get_tree().paused = true
