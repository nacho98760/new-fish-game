extends CharacterBody2D
class_name Player

var inventory: Inventory
var amount_of_inv_slots: int = 9

var speed: int = 100
var jump_force: int = 100
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var entered_area_to_transition: bool = false
var area_name: String

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_sprite: Sprite2D = $PlayerStructure
@onready var fishing_rod_handle_sprite: Sprite2D = $PlayerFishingRodColor
@onready var fishing_rod_end_part_sprite: Sprite2D = $PlayerEndOfFishingRodColor
@onready var end_of_rod: Marker2D = $EndOfFishingRod
@onready var exclamation_mark_sprite: Sprite2D = $FishAlert
@onready var fish_catch_ui: Control = $FishCatchUI
@onready var fishing_minigame: Control = $FishCatchingMinigameUI

func _ready() -> void:
	GameManager.load_game()
	GameManager.updated.emit(inventory)
	GameManager.sell_fish_actual_inv_stuff.connect(handle_selling)
	GameManager.show_item_info.connect(show_actual_info)
	
	GameManager.player_won_minigame.connect(
		func():
			FishingSystem.handle_hooking(self, end_of_rod, exclamation_mark_sprite, fishing_minigame)
	)

func _process(_delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	handle_most_player_animations(direction)
	check_fishing_rod_visibility()
	FishingSystem.handle_inventory_items(self, player_sprite)
	FishingSystem.fishing_system(self, end_of_rod, exclamation_mark_sprite, fish_catch_ui, fishing_minigame)

func _physics_process(_delta: float) -> void:
	handle_player_physics()
	move_and_slide()


func handle_player_physics() -> void:
	var direction: float = Input.get_axis("left", "right")
	
	if FishingSystem.action_being_performed != "not fishing stuff":
		velocity = Vector2.ZERO
	else:
		velocity.x = direction * speed

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_force
		
	if not is_on_floor():
		velocity.y += gravity


func handle_most_player_animations(direction: float) -> void:
	
	if not is_on_floor():
		animation_player.play("idle")

	match FishingSystem.action_being_performed:
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


func check_fishing_rod_visibility() -> void:
	$PlayerFishingRodColor.visible = (FishingSystem.action_being_performed != "not fishing stuff")
	$PlayerEndOfFishingRodColor.visible = (FishingSystem.action_being_performed != "not fishing stuff")

func _on_actual_spot_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		FishingSystem.is_able_to_fish = true

func _on_actual_spot_body_exited(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		FishingSystem.is_able_to_fish = false
		FishingSystem.action_being_performed = "not fishing stuff"

func _on_animation_player_animation_finished(anim_name) -> void:
	match anim_name:
		"cast":
			FishingSystem.action_being_performed = "fishing"
		"hook":
			FishingSystem.action_being_performed = "equipping rod"
			FishingSystem.is_already_fishing = false


func handle_selling(slot, item_info, sell_button):

	if inventory.slots[slot].item == null:
		return
	
	if inventory.slots[slot].amount == 1:
		GameManager.update_coins.emit(inventory.slots[slot].item.value)
		inventory.slots[slot].item = null
		inventory.slots[slot].amount = 0
		item_info.visible = false
		sell_button.set_default_cursor_shape(Input.CURSOR_ARROW)
		$InventoryGUI.update(inventory)
	
	if inventory.slots[slot].amount > 1:
		GameManager.update_coins.emit(inventory.slots[slot].item.value)
		inventory.slots[slot].amount -= 1
		$InventoryGUI.update(inventory)


func show_actual_info(slot, item_info, item_name, item_rarity, item_description, item_value, sell_button):
	
	if inventory.slots[slot].item == null:
		item_info.visible = false
		sell_button.set_default_cursor_shape(Input.CURSOR_ARROW)
		return
	
	item_info.visible = true
	item_name.text = inventory.slots[slot].item.name
	item_rarity.text = "(" + str(inventory.slots[slot].item.rarity) + ")"
	item_rarity.self_modulate = inventory.slots[slot].item.rarity_color
	item_description.text = inventory.slots[slot].item.description
	item_value.text = str(inventory.slots[slot].item.value)
	sell_button.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func save_data(save: PlayerData) -> void:
	save.player_inventory = inventory
	save.player_position = global_position

func load_data(save: PlayerData) -> void:
	if save == null:
		inventory = Inventory.new()
		for i in range(amount_of_inv_slots):
			inventory.slots.append(InventorySlot.new())
		return
	
	if save.player_inventory == null:
		return
	
	inventory = save.player_inventory
	global_position = save.player_position
