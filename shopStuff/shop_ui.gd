extends Control

signal item_equipped

var shop_item_panel_1
var buy_button_1
var sprite_1

var shop_item_panel_2
var buy_button_2
var sprite_2

var shop_item_panel_3
var buy_button_3
var sprite_3


func _ready():
	shop_item_panel_1 = $NinePatchRect/ScrollContainer/MarginContainer/CenterContainer/HBoxContainer/ShopItemPanel
	shop_item_panel_2 = $NinePatchRect/ScrollContainer/MarginContainer/CenterContainer/HBoxContainer/ShopItemPanel2
	shop_item_panel_3 = $NinePatchRect/ScrollContainer/MarginContainer/CenterContainer/HBoxContainer/ShopItemPanel3
	
	sprite_1 = shop_item_panel_1.get_node("NinePatchRect").get_node("CenterContainer").get_node("Panel").get_node("CenterContainer").get_node("Panel").get_node("BuyButton").get_node("Sprite2D")
	sprite_2 = shop_item_panel_2.get_node("NinePatchRect").get_node("CenterContainer").get_node("Panel").get_node("CenterContainer").get_node("Panel").get_node("BuyButton").get_node("Sprite2D")
	sprite_3 = shop_item_panel_3.get_node("NinePatchRect").get_node("CenterContainer").get_node("Panel").get_node("CenterContainer").get_node("Panel").get_node("BuyButton").get_node("Sprite2D")
	
	buy_button_1 = sprite_1.get_node("Label")
	buy_button_2 = sprite_2.get_node("Label")
	buy_button_3 = sprite_3.get_node("Label")
	
	check_if_button_is_equipped("Button1Equipped", buy_button_1, sprite_1)
	check_if_button_is_equipped("Button2Equipped", buy_button_2, sprite_2)
	check_if_button_is_equipped("Button3Equipped", buy_button_3, sprite_3)


var buttons: Dictionary = {
	"Button1Equipped": false,
	"Button2Equipped": false,
	"Button3Equipped": false
}

func check_if_button_is_equipped(button_index, buy_button_index, sprite_index):
	if buttons[button_index] == false:
		sprite_index.self_modulate = Color(0.286, 0.784, 0.31, 1)
		return
	buy_button_index.text = "Equip"
	sprite_index.self_modulate = Color(0.882, 0.412, 0.282, 1)

func _on_shop_item_panel_buy_button_pressed():
	buttons["Button1Equipped"] = true
	buy_button_1.text = "Equipped"
	sprite_1.self_modulate = Color(0.845, 0.173, 0.246, 1)
	
	
	check_if_button_is_equipped("Button2Equipped", buy_button_2, sprite_2)
	check_if_button_is_equipped("Button3Equipped", buy_button_3, sprite_3)
		
func _on_shop_item_panel_2_buy_button_pressed():
	buttons["Button2Equipped"] = true
	buy_button_2.text = "Equipped"
	sprite_2.self_modulate = Color(0.845, 0.173, 0.246, 1)
	
	check_if_button_is_equipped("Button1Equipped", buy_button_1, sprite_1)
	check_if_button_is_equipped("Button3Equipped", buy_button_3, sprite_3)
	
func _on_shop_item_panel_3_buy_button_pressed():
	buttons["Button3Equipped"] = true
	buy_button_3.text = "Equipped"
	sprite_3.self_modulate = Color(0.845, 0.173, 0.246, 1)
	
	check_if_button_is_equipped("Button1Equipped", buy_button_1, sprite_1)
	check_if_button_is_equipped("Button2Equipped", buy_button_2, sprite_2)


func _on_close_shop_panel_button_pressed():
	self.visible = false
	get_tree().paused = false
