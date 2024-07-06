extends Panel

@onready var item_sprite = $CenterContainer/MainPanel/Item
@onready var item_amount: Label = $CenterContainer/MainPanel/Label
@onready var item_price_texture = $CenterContainer/MainPanel/PricePanel/TextureRect
@onready var item_price = $CenterContainer/MainPanel/PricePanel/Label

signal sell_fish_UI_stuff 

func update(slot: InventorySlot):
	if slot.item == null:
		item_sprite.visible = false
		item_amount.visible = false
		item_price_texture.visible = false
		item_price.visible = false
	else:
		item_sprite.visible = true
		item_sprite.texture = slot.item.texture
		item_amount.visible = true
		item_amount.text = str(slot.amount)
		item_price_texture.visible = true
		item_price.visible = true
		item_price.text = str(slot.item.value)

func _on_sell_button_pressed():
	sell_fish_UI_stuff.emit()
