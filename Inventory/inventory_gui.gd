extends Control

var isOpen: bool = false

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready() -> void:
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
		
		slots[slot].connect(
			"mouse_exited",
			func():
				item_info.visible = false
		)
		
		sell_button.connect(
			"pressed", 
			sell_fish.bind(slot, item_info, sell_button)
		)
	
	GameManager.updated.connect(update)
	close()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("openInv"):
		if isOpen:
			close()
		else:
			open()

func update(inventory: Inventory) -> void:
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func sell_fish(slot, item_info, sell_button) -> void:
	GameManager.sell_fish_actual_inv_stuff.emit(slot, item_info, sell_button)

func show_info(slot, item_info, item_name, item_rarity, item_description, item_value, sell_button) -> void:
	GameManager.show_item_info.emit(slot, item_info, item_name, item_rarity, item_description, item_value, sell_button)

func open() -> void:
	visible = true
	isOpen = true
	get_tree().paused = true

func close() -> void:
	visible = false
	isOpen = false
	get_tree().paused = false
