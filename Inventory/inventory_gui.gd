extends Control

var isOpen: bool = false

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	for slot in slots.size():
		var item_info = slots[slot].get_item_info()
		var item_name = slots[slot].get_item_name()
		var item_rarity = slots[slot].get_item_rarity()
		var item_description = slots[slot].get_item_description()
		var item_value =  slots[slot].get_item_value()
		var sell_button = slots[slot].get_sell_button()
		
		slots[slot].connect(
			"mouse_entered", 
			show_info.bind(slot, item_info, item_name, item_rarity, item_description, item_value, sell_button)
		)
		
		sell_button.connect(
			"pressed", 
			sell_fish.bind(slot, item_info, sell_button)
		)
	
	GameManager.updated.connect(update)
	close()

func _process(delta):
	if Input.is_action_just_pressed("openInv"):
		if isOpen:
			close()
		else:
			open()

func update(inventory):
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func sell_fish(slot, item_info, sell_button):
	GameManager.sell_fish_actual_inv_stuff.emit(slot, item_info, sell_button)

func show_info(slot, item_info, item_name, item_rarity, item_description, item_value, sell_button):
	GameManager.show_item_info.emit(slot, item_info, item_name, item_rarity, item_description, item_value, sell_button)

func open():
	visible = true
	isOpen = true
	get_tree().paused = true

func close():
	visible = false
	isOpen = false
	get_tree().paused = false
