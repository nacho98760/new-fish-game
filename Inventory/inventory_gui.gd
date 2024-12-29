extends Control

var isOpen: bool = false

var button_cooldown: Timer = GameManager.create_timer(2, false, true)

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var shopUI: Control = get_tree().get_first_node_in_group("ShopUI")
@onready var sellUI_node: Control = player.get_node("SellUI")
@onready var sell_one_button: Button = sellUI_node.get_node("Background").get_node("InnerBackground").get_node("HBoxContainer").get_node("SellOne")
@onready var sell_all_button: Button = sellUI_node.get_node("Background").get_node("InnerBackground").get_node("HBoxContainer").get_node("SellAll")


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

		if sellUI_node.visible or shopUI.visible:
			return

		if isOpen:
			close()
		else:
			open()


func update(inventory: Inventory) -> void:
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func sell_fish(slot, item_info, sell_button) -> void:

	if player.inventory.slots[slot].item == null:
		return

	close()
	get_tree().paused = true
	sellUI_node.visible = true

	sell_one_button.connect(
		"pressed",
		func():
			print("Sold one")
			GameManager.sell_fish_actual_inv_stuff.emit(slot, item_info, sell_button)
			sellUI_node.visible = false
			get_tree().paused = false
			sell_one_button.disabled = true
			
			button_cooldown.connect(
				"timeout",
				func cooldown_function():
					sell_one_button.disabled = false
			)
			
			add_child(button_cooldown)
			button_cooldown.start()
	)

	sell_all_button.connect(
		"pressed",
		func():
			print("Sold all")
			GameManager.sell_all_fish.emit(slot, item_info, sell_button)
			sellUI_node.visible = false
			get_tree().paused = false
	)

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
