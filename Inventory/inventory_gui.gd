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
