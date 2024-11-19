extends CharacterBody2D

@onready var talk_to_npc_UI = $TalkToNPC
@onready var talk_to_npc_button = $TalkToNPC/TalkToNPCBackground/TalkToNPCButton

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var quest_dialog: Control = get_tree().get_first_node_in_group("QuestDialog")
@onready var quest_dialog_text: Label = get_tree().get_first_node_in_group("QuestDialogText")


var random_quests: Array = [
	"Hello, bring me 5 common fish and I will reward you with 100 coins.",
	"Howdy, get me 3 rare fish and ill reward you with 150 coins.",
	"Get me 2 legendary fish and ill give you 500 coins."
]


func _on_area_2d_body_entered(body: PhysicsBody2D):
	if body is Player:
		talk_to_npc_UI.visible = true


func _on_area_2d_body_exited(body):
	if body is Player:
		talk_to_npc_UI.visible = false


func _on_talk_to_npc_button_pressed():
	talk_to_npc_UI.visible = false
	quest_dialog.visible = true
	var random_quest = random_quests.pick_random()
	quest_dialog_text.text = random_quest
	
