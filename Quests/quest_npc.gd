extends CharacterBody2D

@onready var talk_to_npc_UI: Control = $TalkToNPC
@onready var talk_to_npc_button: Button = $TalkToNPC/TalkToNPCBackground/TalkToNPCButton

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var quest_dialog: Control = get_tree().get_first_node_in_group("QuestDialog")
@onready var quest_dialog_text: Label = get_tree().get_first_node_in_group("QuestDialogText")
@onready var quest_active_UI: Control = get_tree().get_first_node_in_group("QuestActiveUI")
@onready var quest_progress: Label = get_tree().get_first_node_in_group("QuestProgress")

var already_has_a_quest: bool = false

var final_coin_reward: int

var fish_type_coin_multiplier: float = 1.3

func _process(delta):
	print(GameManager.fish_type_chosen)
	

func calculate_quest_reward():
	var fish_rarity_chosen = GameManager.current_fish_rarity_values[GameManager.fish_type_chosen]
	
	final_coin_reward = fish_rarity_chosen * GameManager.quantity_needed_to_finish_quest * fish_type_coin_multiplier
	print(fish_type_coin_multiplier)
	

func set_dialog_text(text: String):
	quest_dialog_text.text = text


func choose_random_rarity_for_quest():
	GameManager.fish_type_chosen = GameManager.fish_types_for_quests.pick_random()
	calculate_quest_reward()
	quest_active_UI.visible = true
	quest_dialog.visible = true
	already_has_a_quest = true
	
	set_dialog_text("Hello, could you bring me " + str(GameManager.quantity_needed_to_finish_quest) + " " + str(GameManager.fish_type_chosen) + " fish? I'll give you " + str(final_coin_reward) + " coins")
	


func check_if_player_finished_quest():
	
	# If player completed quest, give the amount of coins depending on the fish's rarity and hide quest UI.
	if GameManager.quest_progress_number >= GameManager.quantity_needed_to_finish_quest:
		GameManager.update_coins.emit(final_coin_reward)
		GameManager.quest_progress_number = 0
		
		quest_progress.text = str(GameManager.quest_progress_number) + "/" + str(GameManager.quantity_needed_to_finish_quest)
		quest_active_UI.visible = false
		already_has_a_quest = false
	
	# Else, make the NPC say the quest isn't finished yet.
	else:
		quest_dialog.visible = true
		set_dialog_text("Come back when you finish your current quest.")


func _on_area_2d_body_entered(body: PhysicsBody2D):
	if body is Player:
		talk_to_npc_UI.visible = true


func _on_area_2d_body_exited(body):
	if body is Player:
		talk_to_npc_UI.visible = false


func _on_talk_to_npc_button_pressed():
	talk_to_npc_UI.visible = false
	
	if !already_has_a_quest:
		choose_random_rarity_for_quest()
		return
		
	check_if_player_finished_quest()
