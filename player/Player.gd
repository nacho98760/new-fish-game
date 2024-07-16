extends CharacterBody2D
class_name Player

var inventory: Inventory
var amount_of_inv_slots = 9

var speed: int = 100
var jump_force: int = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var entered_area_to_transition: bool = false
var area_name: String

var fishing_system_script = FishingSystem.new()

@onready var animation_player = $AnimationPlayer
@onready var player_sprite = $PlayerStructure
@onready var fishing_rod_handle_sprite = $PlayerFishingRodColor
@onready var fishing_rod_end_part_sprite = $PlayerEndOfFishingRodColor
@onready var end_of_rod = $EndOfFishingRod
@onready var exclamation_mark_sprite = $FishAlert
@onready var fish_catch_ui = $FishCatchUI

func _ready() -> void:
	GameManager.load_game()
	GameManager.updated.emit(inventory)
	GameManager.sell_fish_actual_inv_stuff.connect(handle_selling)
	GameManager.show_item_info.connect(show_actual_info)

func _process(delta):
	var direction = Input.get_axis("left", "right")
	handle_most_player_animations(direction)
	check_fishing_rod_visibility()
	fishing_system_script.handle_inventory_items(self, direction, player_sprite)
	fishing_system_script.fishing_system(self, end_of_rod, exclamation_mark_sprite, fish_catch_ui)
	
func _physics_process(delta):
	handle_player_physics()
	move_and_slide()
	
func handle_player_physics():
	var direction = Input.get_axis("left", "right")
	
	if fishing_system_script.action_being_performed != "not fishing stuff":
		velocity = Vector2.ZERO
	else:
		velocity.x = direction * speed
		
		if !is_on_floor():
			velocity.y += gravity
		
		if Input.is_action_just_pressed("jump") && is_on_floor():
			velocity.y -= jump_force


func handle_most_player_animations(direction):
	match fishing_system_script.action_being_performed:
		"equipping rod":
			animation_player.play("equipping_rod")
		"casting":
			animation_player.play("cast")
		"fishing":
			animation_player.play("fish_idle")
		"hooking":
			animation_player.play("hook")
		"not fishing stuff":
			if direction != 0:
				player_sprite.flip_h = (direction == -1)
				animation_player.play("walk")
			else:
				animation_player.play("idle")
			
	if !is_on_floor():
		animation_player.play("idle")


func check_fishing_rod_visibility():
	$PlayerFishingRodColor.visible = (fishing_system_script.action_being_performed != "not fishing stuff")
	$PlayerEndOfFishingRodColor.visible = (fishing_system_script.action_being_performed != "not fishing stuff")

func _on_actual_spot_body_entered(body: PhysicsBody2D):
	if body.name == "Player":
		fishing_system_script.is_able_to_fish = true

func _on_actual_spot_body_exited(body: PhysicsBody2D):
	if body.name == "Player":
		fishing_system_script.is_able_to_fish = false
		fishing_system_script.action_being_performed = "not fishing stuff"

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"cast":
			fishing_system_script.action_being_performed = "fishing"
		"hook":
			fishing_system_script.action_being_performed = "equipping rod"
			fishing_system_script.is_already_fishing = false


func handle_selling(slot):
	if inventory.slots[slot].item == null:
		return
	
	if inventory.slots[slot].amount == 1:
		GameManager.update_coins.emit(inventory.slots[slot].item.value)
		inventory.slots[slot].item = null
		inventory.slots[slot].amount = 0
		$InventoryGUI.update(inventory)
		
	if inventory.slots[slot].amount > 1:
		GameManager.update_coins.emit(inventory.slots[slot].item.value)
		inventory.slots[slot].amount -= 1
		$InventoryGUI.update(inventory)


func show_actual_info(slot, item_info, item_name, item_rarity, item_description, item_value):
	if inventory.slots[slot].item == null:
		item_info.visible = false
		return
	
	item_info.visible = true
	item_name.text = inventory.slots[slot].item.name
	item_rarity.text = "(" + str(inventory.slots[slot].item.rarity) + ")"
	item_rarity.self_modulate = inventory.slots[slot].item.rarity_color
	item_description.text = inventory.slots[slot].item.description
	item_value.text = str(inventory.slots[slot].item.value)


func save_data(save: PlayerData):
	save.player_inventory = inventory
	save.player_position = global_position

func load_data(save: PlayerData):
	if save == null:
		inventory = Inventory.new()
		for i in range(amount_of_inv_slots):
			inventory.slots.append(InventorySlot.new())
		return
		
	if save.player_inventory == null:
		return
	
	inventory = save.player_inventory
	global_position = save.player_position
