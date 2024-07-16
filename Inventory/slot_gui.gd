extends Panel

@onready var item_sprite = $CenterContainer/MainPanel/Item
@onready var item_amount: Label = $CenterContainer/MainPanel/Label

@onready var item_info = $ItemInfo
@onready var item_name = $ItemInfo/MarginContainer/VBoxContainer/NinePatchRect/VBoxContainer/ItemName
@onready var item_rarity = $ItemInfo/MarginContainer/VBoxContainer/NinePatchRect/VBoxContainer/ItemRarity
@onready var item_description = $ItemInfo/MarginContainer/VBoxContainer/NinePatchRect2/ItemDescription
@onready var item_value = $ItemInfo/MarginContainer/VBoxContainer/NinePatchRect2/ItemValue

@onready var sell_button = $SellButton

func update(slot: InventorySlot):
	if slot.item == null:
		item_sprite.visible = false
		item_amount.visible = false
	else:
		item_sprite.visible = true
		item_sprite.texture = slot.item.texture
		item_amount.visible = true
		item_amount.text = str(slot.amount)

func _on_mouse_exited():
	$ItemInfo.visible = false
	
func get_sell_button():
	return sell_button

func get_item_info():
	return item_info

func get_item_name():
	return item_name

func get_item_rarity():
	return item_rarity

func get_item_description():
	return item_description

func get_item_value():
	return item_value
