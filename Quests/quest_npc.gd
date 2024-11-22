extends CharacterBody2D

@onready var talk_to_npc_UI = $TalkToNPC
@onready var talk_to_npc_button = $TalkToNPC/TalkToNPCBackground/TalkToNPCButton

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var quest_dialog: Control = get_tree().get_first_node_in_group("QuestDialog")
@onready var quest_dialog_text: Label = get_tree().get_first_node_in_group("QuestDialogText")
@onready var quest_active_UI: Control = get_tree().get_first_node_in_group("QuestActiveUI")
@onready var quest_progress: Label = get_tree().get_first_node_in_group("QuestProgress")

var already_has_a_quest: bool = false

func _process(delta):
	print(GameManager.fish_type_chosen)
	print(GameManager.quest_progress_number)

func _on_area_2d_body_entered(body: PhysicsBody2D):
	if body is Player:
		talk_to_npc_UI.visible = true


func _on_area_2d_body_exited(body):
	if body is Player:
		talk_to_npc_UI.visible = false


func _on_talk_to_npc_button_pressed():
	talk_to_npc_UI.visible = false
	
	if already_has_a_quest:
		if GameManager.quest_progress_number >= GameManager.quantity_needed_to_finish:
			GameManager.update_coins.emit(30)
			quest_progress.text = str(0) + "/" + str(GameManager.quantity_needed_to_finish)
			quest_active_UI.visible = false
			already_has_a_quest = false
		else:
			quest_dialog_text.text = "Come back when you finish your current quest."
			return
	
	else:
		GameManager.fish_type_chosen = GameManager.fish_types_for_quests.pick_random()
		quest_active_UI.visible = true
		already_has_a_quest = true
