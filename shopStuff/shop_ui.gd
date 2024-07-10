extends Control

var player
var type_of_rod
var fish_array

@onready var shop_item_panel_1 = $NinePatchRect/ScrollContainer/MarginContainer/CenterContainer/HBoxContainer/ShopItemPanel
@onready var shop_item_panel_2 = $NinePatchRect/ScrollContainer/MarginContainer/CenterContainer/HBoxContainer/ShopItemPanel2 
@onready var shop_item_panel_3 = $NinePatchRect/ScrollContainer/MarginContainer/CenterContainer/HBoxContainer/ShopItemPanel3

var buy_button_1
var buy_button_2
var buy_button_3

var sprite_1
var sprite_2
var sprite_3

func _on_close_shop_panel_button_pressed():
	self.visible = false
	get_tree().paused = false

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
	match type_of_rod:
		"default":
			fish_array = ["clown_fish"]
			player.get_node("PlayerEndOfFishingRodColor").self_modulate = Color(1, 1, 1, 1)
			GameManager.update_rod.emit("default")
		"red_rod":
			fish_array = ["rare_fish"]
			player.get_node("PlayerEndOfFishingRodColor").self_modulate = Color(0.845, 0.173, 0.246, 1)
			GameManager.update_rod.emit("red_rod")
		"blue_rod":
			fish_array = ["blue_tang_fish"]
			player.get_node("PlayerEndOfFishingRodColor").self_modulate = Color(0.369, 0.427, 0.835, 1)
			GameManager.update_rod.emit("blue_rod")
		"turquoise_rod":
			fish_array = ["clown_fish", "rare_fish", "blue_tang_fish"]
			player.get_node("PlayerEndOfFishingRodColor").self_modulate = Color(0.154, 0.564, 0.472, 1)
			GameManager.update_rod.emit("turquoise_rod")
	
	sprite_1 = shop_item_panel_1.get_node("NinePatchRect").get_node("CenterContainer").get_node("Panel").get_node("CenterContainer").get_node("Panel").get_node("BuyButton").get_node("Sprite2D")
	sprite_2 = shop_item_panel_2.get_node("NinePatchRect").get_node("CenterContainer").get_node("Panel").get_node("CenterContainer").get_node("Panel").get_node("BuyButton").get_node("Sprite2D")
	sprite_3 = shop_item_panel_3.get_node("NinePatchRect").get_node("CenterContainer").get_node("Panel").get_node("CenterContainer").get_node("Panel").get_node("BuyButton").get_node("Sprite2D")
	
	buy_button_1 = sprite_1.get_node("Label")
	buy_button_2 = sprite_2.get_node("Label")
	buy_button_3 = sprite_3.get_node("Label")
	
	check_if_button_was_bought("Button1Bought", "Button1Equipped", buy_button_1, sprite_1)
	check_if_button_was_bought("Button2Bought", "Button2Equipped", buy_button_2, sprite_2)
	check_if_button_was_bought("Button3Bought", "Button3Equipped", buy_button_3, sprite_3)


var buttons: Dictionary = {
	"Button1Bought": false,
	"Button2Bought": false,
	"Button3Bought": false,
	
	"Button1Equipped": false,
	"Button2Equipped": false,
	"Button3Equipped": false
}

func check_if_button_was_bought(button_index_bought, button_index_equipped, buy_button_index, sprite_index):
	if buttons[button_index_bought] == false:
		buy_button_index.text = "Buy"
		sprite_index.self_modulate = Color(0.286, 0.784, 0.31, 1)
		return
	
	if buttons[button_index_equipped] == false:
		buy_button_index.text = "Equip"
		sprite_index.self_modulate = Color(0.882, 0.412, 0.282, 1)
		return
	
	buy_button_index.text = "Equipped"
	sprite_index.self_modulate = Color(0.845, 0.173, 0.246, 1)
	

func change_rod_color_and_emit_signal(rod, color):
	player.get_node("PlayerEndOfFishingRodColor").self_modulate = color
	type_of_rod = rod
	GameManager.update_rod.emit(rod)

func _on_shop_item_panel_buy_button_pressed():
	buttons["Button1Bought"] = true
	buttons["Button1Equipped"] = true
	
	buttons["Button2Equipped"] = false
	buttons["Button3Equipped"] = false
	
	change_rod_color_and_emit_signal("red_rod", Color(0.845, 0.173, 0.246, 1))
	
	check_if_button_was_bought("Button1Bought", "Button1Equipped", buy_button_1, sprite_1)
	check_if_button_was_bought("Button2Bought", "Button2Equipped", buy_button_2, sprite_2)
	check_if_button_was_bought("Button3Bought", "Button3Equipped", buy_button_3, sprite_3)


func _on_shop_item_panel_2_buy_button_pressed():
	buttons["Button2Bought"] = true
	buttons["Button2Equipped"] = true
	
	buttons["Button1Equipped"] = false
	buttons["Button3Equipped"] = false
	
	change_rod_color_and_emit_signal("blue_rod", Color(0.369, 0.427, 0.835, 1))
	
	check_if_button_was_bought("Button1Bought", "Button1Equipped", buy_button_1, sprite_1)
	check_if_button_was_bought("Button2Bought", "Button2Equipped", buy_button_2, sprite_2)
	check_if_button_was_bought("Button3Bought", "Button3Equipped", buy_button_3, sprite_3)


func _on_shop_item_panel_3_buy_button_pressed():
	buttons["Button3Bought"] = true
	buttons["Button3Equipped"] = true
	
	buttons["Button1Equipped"] = false
	buttons["Button2Equipped"] = false
	
	change_rod_color_and_emit_signal("turquoise_rod", Color(0.154, 0.564, 0.472, 1))
	
	check_if_button_was_bought("Button1Bought", "Button1Equipped", buy_button_1, sprite_1)
	check_if_button_was_bought("Button2Bought", "Button2Equipped", buy_button_2, sprite_2)
	check_if_button_was_bought("Button3Bought", "Button3Equipped", buy_button_3, sprite_3)


func save_data(save: PlayerData):
	save.player_type_of_rod = type_of_rod
	
	save.button_1_bought = buttons["Button1Bought"]
	save.button_2_bought = buttons["Button2Bought"]
	save.button_3_bought = buttons["Button3Bought"]
	
	save.button_1_equipped = buttons["Button1Equipped"]
	save.button_2_equipped = buttons["Button2Equipped"]
	save.button_3_equipped = buttons["Button3Equipped"]
	
func load_data(save: PlayerData):
	if save == null:
		type_of_rod = "default"
		buttons["Button1Bought"] = false
		buttons["Button2Bought"] = false
		buttons["Button3Bought"] = false
		
		buttons["Button1Equipped"] = false
		buttons["Button2Equipped"] = false
		buttons["Button3Equipped"] = false
		return
	
	type_of_rod = save.player_type_of_rod
	
	buttons["Button1Bought"] = save.button_1_bought
	buttons["Button2Bought"] = save.button_2_bought
	buttons["Button3Bought"] = save.button_3_bought
	
	buttons["Button1Equipped"] = save.button_1_equipped
	buttons["Button2Equipped"] = save.button_2_equipped
	buttons["Button3Equipped"] = save.button_3_equipped
