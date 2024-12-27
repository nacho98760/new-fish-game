extends Control

signal rod_color_changed

enum ROD_PRICES {
	DEFAULT = 0,
	RED = 15,
	BLUE = 40,
	TURQUOISE = 75
}

var type_of_rod: String
var coins: Coins

var default_rod_color := Color(1, 1, 1, 1)
var red_rod_color := Color(0.845, 0.173, 0.246, 1)
var blue_rod_color := Color(0.369, 0.427, 0.835, 1)
var turquoise_rod_color := Color(0.154, 0.564, 0.472, 1)

var buttons: Dictionary = {
	"1": {
		"Bought": true,
		"Equipped": true,
	},
	"2": {
		"Bought": false,
		"Equipped": false,
	},
	"3": {
		"Bought": false,
		"Equipped": false,
	},
	"4": {
		"Bought": false,
		"Equipped": false,
	},
}

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var rod_end_part: Sprite2D = player.get_node("PlayerEndOfFishingRodColor")

@onready var shop_item_panel_1: Panel = $NinePatchRect/ScrollContainer/MarginContainer/CenterContainer/HBoxContainer/ShopItemPanel
@onready var shop_item_panel_2: Panel = $NinePatchRect/ScrollContainer/MarginContainer/CenterContainer/HBoxContainer/ShopItemPanel2 
@onready var shop_item_panel_3: Panel = $NinePatchRect/ScrollContainer/MarginContainer/CenterContainer/HBoxContainer/ShopItemPanel3
@onready var shop_item_panel_4: Panel = $NinePatchRect/ScrollContainer/MarginContainer/CenterContainer/HBoxContainer/ShopItemPanel4

@onready var rod_model_color_1: Sprite2D = shop_item_panel_1.get_rod_model_color()
@onready var rod_model_color_2: Sprite2D = shop_item_panel_2.get_rod_model_color()
@onready var rod_model_color_3: Sprite2D = shop_item_panel_3.get_rod_model_color()
@onready var rod_model_color_4: Sprite2D = shop_item_panel_4.get_rod_model_color()

@onready var sprite_1: Sprite2D = shop_item_panel_1.get_sprite()
@onready var sprite_2: Sprite2D = shop_item_panel_2.get_sprite()
@onready var sprite_3: Sprite2D = shop_item_panel_3.get_sprite()
@onready var sprite_4: Sprite2D = shop_item_panel_4.get_sprite()

@onready var rod_price_label_1: Label = shop_item_panel_1.get_rod_price_label()
@onready var rod_price_label_2: Label = shop_item_panel_2.get_rod_price_label()
@onready var rod_price_label_3: Label = shop_item_panel_3.get_rod_price_label()
@onready var rod_price_label_4: Label = shop_item_panel_4.get_rod_price_label()

@onready var buy_button_1: Label = sprite_1.get_child(0) # <- button's name ("Buy", "Equip", or "Equipped")
@onready var buy_button_2: Label = sprite_2.get_child(0) # <- button's name ("Buy", "Equip", or "Equipped")
@onready var buy_button_3: Label = sprite_3.get_child(0) # <- button's name ("Buy", "Equip", or "Equipped")
@onready var buy_button_4: Label = sprite_4.get_child(0) # <- button's name ("Buy", "Equip", or "Equipped")



func _on_close_shop_panel_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false


func _ready() -> void:
	coins = get_tree().get_first_node_in_group("Coins")
	
	rod_model_color_1.self_modulate = default_rod_color
	rod_model_color_2.self_modulate = red_rod_color
	rod_model_color_3.self_modulate = blue_rod_color
	rod_model_color_4.self_modulate = turquoise_rod_color
	
	rod_price_label_1.text = str(ROD_PRICES.DEFAULT)
	rod_price_label_2.text = str(ROD_PRICES.RED)
	rod_price_label_3.text = str(ROD_PRICES.BLUE)
	rod_price_label_4.text = str(ROD_PRICES.TURQUOISE)
	
	match type_of_rod:
		"default":
			change_rod_color_and_emit_signal("default", default_rod_color)
		"red_rod":
			change_rod_color_and_emit_signal("red_rod", red_rod_color)
		"blue_rod":
			change_rod_color_and_emit_signal("blue_rod", blue_rod_color)
		"turquoise_rod":
			change_rod_color_and_emit_signal("turquoise_rod", turquoise_rod_color)
	
	check_all_buttons()


func change_rod_color_and_emit_signal(rod, color) -> void:
	rod_end_part.self_modulate = color
	GameManager.update_rod.emit(rod)

func equip_button(button_to_equip, other_button_1, other_button_2, other_button_3, rod, rod_color) -> void:
	buttons[button_to_equip]["Equipped"] = true
	buttons[other_button_1]["Equipped"] = false
	buttons[other_button_2]["Equipped"] = false
	buttons[other_button_3]["Equipped"] = false
	
	type_of_rod = rod
	change_rod_color_and_emit_signal(rod, rod_color)
	check_all_buttons()

func check_if_button_was_bought(button, buy_button, sprite) -> void:
	if buttons[button]["Bought"] == false:
		buy_button.text = "Buy"
		sprite.self_modulate = Color(0.286, 0.784, 0.31, 1)
		return
	
	if buttons[button]["Equipped"] == false:
		buy_button.text = "Equip"
		sprite.self_modulate = Color(0.882, 0.412, 0.282, 1)
		return
	
	buy_button.text = "Equipped"
	sprite.self_modulate = Color(0.845, 0.173, 0.246, 1)

func check_all_buttons() -> void:
	check_if_button_was_bought("1", buy_button_1, sprite_1)
	check_if_button_was_bought("2", buy_button_2, sprite_2)
	check_if_button_was_bought("3", buy_button_3, sprite_3)
	check_if_button_was_bought("4", buy_button_4, sprite_4)


func _on_shop_item_panel_buy_button_pressed() -> void:
	if buttons["1"]["Bought"] == false:
		
		var current_coins_amount = coins.get_coins()

		if current_coins_amount >= ROD_PRICES.DEFAULT:
			GameManager.update_coins.emit(-(ROD_PRICES.DEFAULT)) # <- rod's price
			buttons["1"]["Bought"] = true
			
			equip_button("1", "2", "3", "4", "default", default_rod_color)
	else:
		equip_button("1", "2", "3", "4", "red_rod", default_rod_color)


func _on_shop_item_panel_2_buy_button_pressed() -> void:
	if buttons["2"]["Bought"] == false:
		var current_coins_amount = coins.get_coins()
		if current_coins_amount >= ROD_PRICES.RED:
			GameManager.update_coins.emit(-(ROD_PRICES.RED)) # <- rod's price
			buttons["2"]["Bought"] = true
			
			equip_button("2", "1", "3", "4", "red_rod", red_rod_color)
	else:
		equip_button("2", "1", "3", "4", "red_rod", red_rod_color)


func _on_shop_item_panel_3_buy_button_pressed() -> void:
	if buttons["3"]["Bought"] == false:
		var current_coins_amount = coins.get_coins()
		if current_coins_amount >= ROD_PRICES.BLUE:
			GameManager.update_coins.emit(-(ROD_PRICES.BLUE)) # <- rod's price
			buttons["3"]["Bought"] = true
			
			equip_button("3", "1", "2", "4", "blue_rod", blue_rod_color)
	else:
		equip_button("3", "1", "2", "4", "blue_rod", blue_rod_color)


func _on_shop_item_panel_4_buy_button_pressed() -> void:
	if buttons["4"]["Bought"] == false:
		var current_coins_amount = coins.get_coins()
		if current_coins_amount >= ROD_PRICES.TURQUOISE:
			GameManager.update_coins.emit(-(ROD_PRICES.TURQUOISE)) # <- rod's price
			buttons["4"]["Bought"] = true
			
			equip_button("4", "1", "2", "3", "turquoise_rod", turquoise_rod_color)
	else:
		equip_button("4", "1", "2", "3", "turquoise_rod", turquoise_rod_color)



func save_data(save: PlayerData) -> void:
	save.player_type_of_rod = type_of_rod
	
	save.button_1_bought = buttons["1"]["Bought"]
	save.button_2_bought = buttons["2"]["Bought"]
	save.button_3_bought = buttons["3"]["Bought"]
	save.button_3_bought = buttons["4"]["Bought"]
	
	save.button_1_equipped = buttons["1"]["Equipped"]
	save.button_2_equipped = buttons["2"]["Equipped"]
	save.button_3_equipped = buttons["3"]["Equipped"]
	save.button_3_equipped = buttons["4"]["Equipped"]

func load_data(save: PlayerData) -> void:
	if save == null:
		type_of_rod = "default"
		buttons["1"]["Bought"] = true
		buttons["2"]["Bought"] = false
		buttons["3"]["Bought"] = false
		buttons["4"]["Bought"] = false
		
		buttons["1"]["Equipped"] = true
		buttons["2"]["Equipped"] = false
		buttons["3"]["Equipped"] = false
		buttons["4"]["Equipped"] = false
		return
	
	type_of_rod = save.player_type_of_rod
	
	buttons["1"]["Bought"] = save.button_1_bought
	buttons["2"]["Bought"] = save.button_2_bought
	buttons["3"]["Bought"] = save.button_3_bought
	buttons["4"]["Bought"] = save.button_3_bought
	
	buttons["1"]["Equipped"] = save.button_1_equipped
	buttons["2"]["Equipped"] = save.button_2_equipped
	buttons["3"]["Equipped"] = save.button_3_equipped
	buttons["4"]["Equipped"] = save.button_3_equipped
