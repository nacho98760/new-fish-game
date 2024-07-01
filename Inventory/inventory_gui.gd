extends Control

var isOpen: bool = false

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
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

func open():
	visible = true
	isOpen = true
	get_tree().paused = true
	
func close():
	visible = false
	isOpen = false
	get_tree().paused = false


func _on_slot_sell_fish_ui_stuff():
	GameManager.sell_fish_actual_inv_stuff.emit(0)
func _on_slot_2_sell_fish_ui_stuff():
	GameManager.sell_fish_actual_inv_stuff.emit(1)
func _on_slot_3_sell_fish_ui_stuff():
	GameManager.sell_fish_actual_inv_stuff.emit(2)
func _on_slot_4_sell_fish_ui_stuff():
	GameManager.sell_fish_actual_inv_stuff.emit(3)
func _on_slot_5_sell_fish_ui_stuff():
	GameManager.sell_fish_actual_inv_stuff.emit(4)
func _on_slot_6_sell_fish_ui_stuff():
	GameManager.sell_fish_actual_inv_stuff.emit(5)
func _on_slot_7_sell_fish_ui_stuff():
	GameManager.sell_fish_actual_inv_stuff.emit(6)
func _on_slot_8_sell_fish_ui_stuff():
	GameManager.sell_fish_actual_inv_stuff.emit(7)
func _on_slot_9_sell_fish_ui_stuff():
	GameManager.sell_fish_actual_inv_stuff.emit(8)
