extends CharacterBody2D

@onready var talk_to_npc_UI: Control = $TalkToNPC
@onready var talk_to_npc_button: Button = $TalkToNPC/TalkToNPCBackground/TalkToNPCButton

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var quest_dialog: Control = get_tree().get_first_node_in_group("QuestDialog")
@onready var quest_dialog_text: Label = get_tree().get_first_node_in_group("QuestDialogText")
@onready var quest_active_UI: Control = get_tree().get_first_node_in_group("QuestActiveUI")
@onready var quest_progress: Label = get_tree().get_first_node_in_group("QuestProgress")

var already_has_a_quest: bool = false

var fish_type_coin_multiplier: Dictionary = {
	"Rare": 1.2,
	"Super Rare": 1.5,
	"Epic": 2,
	"Legendary": 2.5,
}

func _process(delta):
	print(GameManager.fish_type_chosen)


func choose_random_rarity_for_quest():
	GameManager.fish_type_chosen = GameManager.fish_types_for_quests.pick_random()
	quest_active_UI.visible = true
	already_has_a_quest = true


func check_if_player_finished_quest():
	var fish_rarity_chosen = GameManager.current_fish_rarity_values[GameManager.fish_type_chosen]
	var coin_multiplier = fish_type_coin_multiplier[GameManager.fish_type_chosen]
	
	# If player completed quest, give the amount of coins depending on the fish's rarity and hide quest UI.
	if GameManager.quest_progress_number >= GameManager.quantity_needed_to_finish_quest:
		GameManager.update_coins.emit(fish_rarity_chosen * GameManager.quantity_needed_to_finish_quest * coin_multiplier)
		GameManager.quest_progress_number = 0
		
		quest_progress.text = str(GameManager.quest_progress_number) + "/" + str(GameManager.quantity_needed_to_finish_quest)
		quest_active_UI.visible = false
		already_has_a_quest = false
	
	# Else, make the NPC say the quest isn't finished yet.
	else:
		quest_dialog_text.text = "Come back when you finish your current quest."


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
