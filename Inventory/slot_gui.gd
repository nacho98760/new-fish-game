extends Panel

@onready var item_sprite = $CenterContainer/Panel/Item
@onready var item_amount: Label = $CenterContainer/Panel/Label


func update(slot: InventorySlot):
	if slot.item == null:
		item_sprite.visible = false
		item_amount.visible = false
	else:
		item_sprite.visible = true
		item_sprite.texture = slot.item.texture
		item_amount.visible = true
		item_amount.text = str(slot.amount)


func _on_button_pressed():
	pass 
