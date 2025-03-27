extends Control

var is_fish_index_open: bool = false

@export var player_has_gray_fish: bool = false
@export var player_has_clown_fish: bool = false
@export var player_has_blue_fish: bool = false
@export var player_has_yellowtail_kingfish: bool = false
@export var player_has_green_widow_fish: bool = false
@export var player_has_brown_fish: bool = false
@export var player_has_blue_tang_fish: bool = false
@export var player_has_shiny_fish: bool = false
@export var player_has_striped_tigerbarb_fish: bool = false

@export var fish_types_the_player_has: Array = []
@export var amount_of_fish_types_in_game = 9

@onready var inventoryGUI: Control = get_tree().get_first_node_in_group("InventoryGUI")
@onready var main_menu_UI = get_tree().get_first_node_in_group("MainMenuUI")
@onready var sellUI: Control = get_tree().get_first_node_in_group("SELLUI")
@onready var shopUI: Control = get_tree().get_first_node_in_group("ShopUI")

@onready var fish_found_label = $NinePatchRect/Label

@onready var gray_fish_frame = $NinePatchRect/GridContainer/GrayFishFrame
@onready var clown_fish_frame = $NinePatchRect/GridContainer/ClownFishFrame
@onready var blue_fish_frame = $NinePatchRect/GridContainer/BlueFishFrame
@onready var yellow_tail_king_fish_frame = $NinePatchRect/GridContainer/YellowTailKingFishFrame
@onready var green_widow_fish_frame = $NinePatchRect/GridContainer/GreenWidowFishFrame
@onready var brown_fish_frame = $NinePatchRect/GridContainer/BrownFishFrame
@onready var blue_tang_fish_frame = $NinePatchRect/GridContainer/BlueTangFishFrame
@onready var shiny_fish_frame = $NinePatchRect/GridContainer/ShinyFishFrame
@onready var striped_tigerbarb_fish_frame = $NinePatchRect/GridContainer/StripedTigerbarbFishFrame

@onready var detailed_fish_sprite = $NinePatchRect/DetailedFishInfoPanel/NinePatchRect/DetailedFishSprite
@onready var detailed_fish_name = $NinePatchRect/DetailedFishInfoPanel/NinePatchRect/VBoxContainer/VBoxContainer/DetailedFishName
@onready var detailed_fish_rarity = $NinePatchRect/DetailedFishInfoPanel/NinePatchRect/VBoxContainer/VBoxContainer/DetailedFishRarity
@onready var detailed_fish_description = $NinePatchRect/DetailedFishInfoPanel/NinePatchRect/VBoxContainer/DetailedFishDescription
@onready var detailed_fish_value = $NinePatchRect/DetailedFishInfoPanel/NinePatchRect/VBoxContainer/DetailedFishValue/Label

@onready var detailed_fish_info_panel = $NinePatchRect/DetailedFishInfoPanel
@onready var no_fish_selected_text = $NinePatchRect/NoFishSelectedText


func _process(delta):
	
	if Input.is_action_just_pressed("open_fish_index"):
		if inventoryGUI.visible or sellUI.visible or shopUI.visible or main_menu_UI.visible:
			return
			
		if is_fish_index_open:
			self.visible = false
			is_fish_index_open = false
			get_tree().paused = false
			show_no_fish_selected_text()
		else:
			self.visible = true
			is_fish_index_open = true
			get_tree().paused = true
	
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
	
	if player_has_blue_fish:
		blue_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/blue_fish.png")
		blue_fish_frame.get_node("Label").visible = false
	else:
		blue_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/unknown_fish.png")
		blue_fish_frame.get_node("Label").visible = true
	
	if player_has_yellowtail_kingfish:
		yellow_tail_king_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/yellowtail_kingfish.png")
		yellow_tail_king_fish_frame.get_node("Label").visible = false
	else:
		yellow_tail_king_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/unknown_fish.png")
		yellow_tail_king_fish_frame.get_node("Label").visible = true
	
	if player_has_green_widow_fish:
		green_widow_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/green_widow_fish.png")
		green_widow_fish_frame.get_node("Label").visible = false
	else:
		green_widow_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/unknown_fish.png")
		green_widow_fish_frame.get_node("Label").visible = true
	
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
		

func show_no_fish_selected_text():
	detailed_fish_info_panel.visible = false
	no_fish_selected_text.visible = true

func hide_no_fish_selected_text():
	detailed_fish_info_panel.visible = true
	no_fish_selected_text.visible = false

func fish_not_discovered():
	detailed_fish_sprite.texture = preload("res://fishing/fish/fish_textures/unknown_fish.png")
	detailed_fish_name.text = "???"
	detailed_fish_rarity.text = "(??)"
	detailed_fish_description.text = "Fish not discovered"


func _on_close_shop_panel_button_pressed():
	self.visible = false
	get_tree().paused = false


func _on_gray_fish_detailed_button_pressed():
	hide_no_fish_selected_text()
	
	var fish_resource: Resource = preload("res://Inventory/items/gray_fish.tres")
	
	if player_has_gray_fish == false:
		fish_not_discovered()
		return
	
	detailed_fish_sprite.texture = fish_resource.texture
	detailed_fish_name.text = fish_resource.name
	detailed_fish_rarity.text = "(" + str(fish_resource.rarity) + ")"
	detailed_fish_rarity.self_modulate = fish_resource.rarity_color
	detailed_fish_description.text = fish_resource.description
	detailed_fish_value.text = str(fish_resource.value)
		
func _on_clown_fish_detailed_button_pressed():
	hide_no_fish_selected_text()
	
	var fish_resource: Resource = preload("res://Inventory/items/clown_fish.tres")
	
	if player_has_clown_fish == false:
		fish_not_discovered()
		return
	
	detailed_fish_sprite.texture = fish_resource.texture
	detailed_fish_name.text = fish_resource.name
	detailed_fish_rarity.text = "(" + str(fish_resource.rarity) + ")"
	detailed_fish_rarity.self_modulate = fish_resource.rarity_color
	detailed_fish_description.text = fish_resource.description
	detailed_fish_value.text = str(fish_resource.value)


func _on_blue_fish_detailed_button_pressed():
	hide_no_fish_selected_text()
	
	var fish_resource: Resource = preload("res://Inventory/items/blue_fish.tres")
	
	if player_has_blue_fish == false:
		fish_not_discovered()
		return
	
	detailed_fish_sprite.texture = fish_resource.texture
	detailed_fish_name.text = fish_resource.name
	detailed_fish_rarity.text = "(" + str(fish_resource.rarity) + ")"
	detailed_fish_rarity.self_modulate = fish_resource.rarity_color
	detailed_fish_description.text = fish_resource.description
	detailed_fish_value.text = str(fish_resource.value)

func _on_yellow_tail_king_fish_detailed_button_pressed():
	hide_no_fish_selected_text()
	
	var fish_resource: Resource = preload("res://Inventory/items/yellowtail_kingfish.tres")
	
	if player_has_yellowtail_kingfish == false:
		fish_not_discovered()
		return
	
	detailed_fish_sprite.texture = fish_resource.texture
	detailed_fish_name.text = fish_resource.name
	detailed_fish_rarity.text = "(" + str(fish_resource.rarity) + ")"
	detailed_fish_rarity.self_modulate = fish_resource.rarity_color
	detailed_fish_description.text = fish_resource.description
	detailed_fish_value.text = str(fish_resource.value)

func _on_green_widow_fish_detailed_button_pressed():
	hide_no_fish_selected_text()
	
	var fish_resource: Resource = preload("res://Inventory/items/green_widow_fish.tres")
	
	if player_has_green_widow_fish == false:
		fish_not_discovered()
		return
	
	detailed_fish_sprite.texture = fish_resource.texture
	detailed_fish_name.text = fish_resource.name
	detailed_fish_rarity.text = "(" + str(fish_resource.rarity) + ")"
	detailed_fish_rarity.self_modulate = fish_resource.rarity_color
	detailed_fish_description.text = fish_resource.description
	detailed_fish_value.text = str(fish_resource.value)


func _on_brown_fish_detailed_button_pressed():
	hide_no_fish_selected_text()
	
	var fish_resource: Resource = preload("res://Inventory/items/brown_fish.tres")
	
	if player_has_brown_fish == false:
		fish_not_discovered()
		return
	
	detailed_fish_sprite.texture = fish_resource.texture
	detailed_fish_name.text = fish_resource.name
	detailed_fish_rarity.text = "(" + str(fish_resource.rarity) + ")"
	detailed_fish_rarity.self_modulate = fish_resource.rarity_color
	detailed_fish_description.text = fish_resource.description
	detailed_fish_value.text = str(fish_resource.value)


func _on_blue_tang_fish_detailed_button_pressed():
	hide_no_fish_selected_text()
	
	var fish_resource: Resource = preload("res://Inventory/items/blue_tang_fish.tres")
	
	if player_has_blue_tang_fish == false:
		fish_not_discovered()
		return
	
	detailed_fish_sprite.texture = fish_resource.texture
	detailed_fish_name.text = fish_resource.name
	detailed_fish_rarity.text = "(" + str(fish_resource.rarity) + ")"
	detailed_fish_rarity.self_modulate = fish_resource.rarity_color
	detailed_fish_description.text = fish_resource.description
	detailed_fish_value.text = str(fish_resource.value)


func _on_shiny_fish_detailed_button_pressed():
	hide_no_fish_selected_text()
	
	var fish_resource: Resource = preload("res://Inventory/items/shiny_fish.tres")
	
	if player_has_shiny_fish == false:
		fish_not_discovered()
		return
	
	detailed_fish_sprite.texture = fish_resource.texture
	detailed_fish_name.text = fish_resource.name
	detailed_fish_rarity.text = "(" + str(fish_resource.rarity) + ")"
	detailed_fish_rarity.self_modulate = fish_resource.rarity_color
	detailed_fish_description.text = fish_resource.description
	detailed_fish_value.text = str(fish_resource.value)


func _on_striped_tiger_barb_fish_detailed_button_pressed():
	hide_no_fish_selected_text()
	
	var fish_resource: Resource = preload("res://Inventory/items/striped_tigerbarb_fish.tres")
	
	if player_has_striped_tigerbarb_fish == false:
		fish_not_discovered()
		return
	
	detailed_fish_sprite.texture = fish_resource.texture
	detailed_fish_name.text = fish_resource.name
	detailed_fish_rarity.text = "(" + str(fish_resource.rarity) + ")"
	detailed_fish_rarity.self_modulate = fish_resource.rarity_color
	detailed_fish_description.text = fish_resource.description
	detailed_fish_value.text = str(fish_resource.value)



func save_data(save: PlayerData):
	save.fish_types_the_player_has = fish_types_the_player_has
	save.player_has_gray_fish = player_has_gray_fish
	save.player_has_clown_fish = player_has_clown_fish
	save.player_has_blue_fish = player_has_blue_fish
	save.player_has_yellowtail_kingfish = player_has_yellowtail_kingfish
	save.player_has_green_widow_fish = player_has_green_widow_fish
	save.player_has_brown_fish = player_has_brown_fish
	save.player_has_blue_tang_fish = player_has_blue_tang_fish
	save.player_has_shiny_fish = player_has_shiny_fish
	save.player_has_striped_tigerbarb_fish = player_has_striped_tigerbarb_fish

func load_data(save: PlayerData):
	if save == null:
		fish_types_the_player_has = []
		player_has_gray_fish = false
		player_has_clown_fish = false
		player_has_blue_fish = false
		player_has_yellowtail_kingfish = false
		player_has_green_widow_fish = false
		player_has_brown_fish = false
		player_has_blue_tang_fish = false
		player_has_shiny_fish = false
		player_has_striped_tigerbarb_fish = false
		return
	
	fish_types_the_player_has = save.fish_types_the_player_has
	player_has_gray_fish = save.player_has_gray_fish
	player_has_clown_fish = save.player_has_clown_fish
	player_has_blue_fish = save.player_has_blue_fish
	player_has_yellowtail_kingfish = save.player_has_yellowtail_kingfish
	player_has_green_widow_fish = save.player_has_green_widow_fish
	player_has_brown_fish = save.player_has_brown_fish
	player_has_blue_tang_fish = save.player_has_blue_tang_fish
	player_has_shiny_fish = save.player_has_shiny_fish
	player_has_striped_tigerbarb_fish = save.player_has_striped_tigerbarb_fish
