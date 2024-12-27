extends Control

@export var player_has_gray_fish: bool = false
@export var player_has_clown_fish: bool = false
@export var player_has_yellowtail_kingfish: bool = false
@export var player_has_brown_fish: bool = false
@export var player_has_blue_tang_fish: bool = false
@export var player_has_shiny_fish: bool = false
@export var player_has_striped_tigerbarb_fish: bool = false

@export var fish_types_the_player_has: Array = []
@export var amount_of_fish_types_in_game = 7

@onready var fish_found_label = $NinePatchRect/Label

@onready var gray_fish_frame = $NinePatchRect/GridContainer/GrayFishFrame
@onready var clown_fish_frame = $NinePatchRect/GridContainer/ClownFishFrame
@onready var yellow_tail_king_fish_frame = $NinePatchRect/GridContainer/YellowTailKingFishFrame
@onready var brown_fish_frame = $NinePatchRect/GridContainer/BrownFishFrame
@onready var blue_tang_fish_frame = $NinePatchRect/GridContainer/BlueTangFishFrame
@onready var shiny_fish_frame = $NinePatchRect/GridContainer/ShinyFishFrame
@onready var striped_tigerbarb_fish_frame = $NinePatchRect/GridContainer/StripedTigerbarbFishFrame

func _process(delta):
	
	fish_found_label.text = str(fish_types_the_player_has.size()) + "/" + str(amount_of_fish_types_in_game) + " species found"
	
	if player_has_gray_fish:
		gray_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/gray_fish.png")
		gray_fish_frame.get_node("Label").visible = false
	else:
		gray_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/unknown_fish.png")
		gray_fish_frame.get_node("Label").visible = true
	
	if player_has_clown_fish:
		clown_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/clown_fish.png")
		clown_fish_frame.get_node("Label").visible = false
	else:
		clown_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/unknown_fish.png")
		clown_fish_frame.get_node("Label").visible = true
	
	if player_has_yellowtail_kingfish:
		yellow_tail_king_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/yellowtail_kingfish.png")
		yellow_tail_king_fish_frame.get_node("Label").visible = false
	else:
		yellow_tail_king_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/unknown_fish.png")
		yellow_tail_king_fish_frame.get_node("Label").visible = true
	
	if player_has_brown_fish:
		brown_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/rare_fish.png")
		brown_fish_frame.get_node("Label").visible = false
	else:
		brown_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/unknown_fish.png")
		brown_fish_frame.get_node("Label").visible = true
	
	if player_has_blue_tang_fish:
		blue_tang_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/blue_tang_fish.png")
		blue_tang_fish_frame.get_node("Label").visible = false
	else:
		blue_tang_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/unknown_fish.png")
		blue_tang_fish_frame.get_node("Label").visible = true
	
	if player_has_shiny_fish:
		shiny_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/shiny_fish.png")
		shiny_fish_frame.get_node("Label").visible = false
	else:
		shiny_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/unknown_fish.png")
		shiny_fish_frame.get_node("Label").visible = true
	
	if player_has_striped_tigerbarb_fish:
		striped_tigerbarb_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/striped_tigerbarb_fish.png")
		striped_tigerbarb_fish_frame.get_node("Label").visible = false
	else:
		striped_tigerbarb_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/unknown_fish.png")
		striped_tigerbarb_fish_frame.get_node("Label").visible = true

func save_data(save: PlayerData):
	save.fish_types_the_player_has = fish_types_the_player_has
	save.player_has_gray_fish = player_has_gray_fish
	save.player_has_clown_fish = player_has_clown_fish
	save.player_has_yellowtail_kingfish = player_has_yellowtail_kingfish
	save.player_has_brown_fish = player_has_brown_fish
	save.player_has_blue_tang_fish = player_has_blue_tang_fish
	save.player_has_shiny_fish = player_has_shiny_fish
	save.player_has_striped_tigerbarb_fish = player_has_striped_tigerbarb_fish

func load_data(save: PlayerData):
	if save == null:
		fish_types_the_player_has = []
		player_has_gray_fish = false
		player_has_clown_fish = false
		player_has_yellowtail_kingfish = false
		player_has_brown_fish = false
		player_has_blue_tang_fish = false
		player_has_shiny_fish = false
		player_has_striped_tigerbarb_fish = false
		return
	
	fish_types_the_player_has = save.fish_types_the_player_has
	player_has_gray_fish = save.player_has_gray_fish
	player_has_clown_fish = save.player_has_clown_fish
	player_has_yellowtail_kingfish = save.player_has_yellowtail_kingfish
	player_has_brown_fish = save.player_has_brown_fish
	player_has_blue_tang_fish = save.player_has_blue_tang_fish
	player_has_shiny_fish = save.player_has_shiny_fish
	player_has_striped_tigerbarb_fish = save.player_has_striped_tigerbarb_fish
	

