extends CharacterBody2D
class_name Player

var inventory: Inventory
var amount_of_inv_slots: int = 9

var is_fish_index_open: bool = false
var is_able_to_sell: bool = true

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
@onready var fish_index_UI = get_tree().get_first_node_in_group("FishIndexUI")
@onready var key_to_equip_rod_UI: Control = get_tree().get_first_node_in_group("KeyToEquipRodUI")
@onready var fishing_minigame_container = fishing_minigame.get_node("MainPanel").get_node("NinePatchRect")


func _ready() -> void:
	GameManager.load_game()
	GameManager.updated.emit(inventory)
	GameManager.sell_fish_actual_inv_stuff.connect(handle_selling)
	GameManager.sell_all_fish.connect(handle_selling_all)
	GameManager.show_item_info.connect(show_actual_info)
	
	GameManager.player_won_minigame.connect(
		func():
			FishingSystem.handle_hooking(self, end_of_rod, exclamation_mark_sprite, fishing_minigame)
	)
	
	GameManager.player_lost_minigame.connect(
		func():
			if fishing_minigame.visible:
				fishing_minigame.visible = false
				FishingSystem.is_already_fishing = false
				FishingSystem.is_already_catching_a_fish = false
				
				FishingSystem.hooked_fish.queue_free()
				
				if fishing_minigame_container.get_child_count() > 1:
					fishing_minigame_container.get_child(1).queue_free()
				
				FishingSystem.action_being_performed = FishingSystem.ACTIONS.NOT_FISHING_STUFF
	)

func _process(_delta: float) -> void:
	
	visible = true
	player_sprite.visible = true
	fishing_rod_handle_sprite.visible = true
	fishing_rod_end_part_sprite.visible = true
	
	var direction = Input.get_axis("left", "right")
	handle_most_player_animations(direction)
	check_fishing_rod_visibility()
	FishingSystem.handle_inventory_items(self, player_sprite)
	FishingSystem.fishing_system(self, end_of_rod, exclamation_mark_sprite, fish_catch_ui, fishing_minigame)
	
	if Input.is_action_just_pressed("open_fish_index"):
		
		if is_fish_index_open:
			fish_index_UI.visible = false
			is_fish_index_open = false
		else:
			fish_index_UI.visible = true
			is_fish_index_open = true


func _physics_process(_delta: float) -> void:
	handle_player_physics()
	move_and_slide()


func handle_player_physics() -> void:
	var direction: float = Input.get_axis("left", "right")
	
	if FishingSystem.action_being_performed != FishingSystem.ACTIONS.NOT_FISHING_STUFF:
		velocity = Vector2.ZERO
	else:
		velocity.x = direction * speed

	if Input.is_action_just_pressed("jump") and FishingSystem.action_being_performed == FishingSystem.ACTIONS.NOT_FISHING_STUFF and is_on_floor():
		velocity.y -= jump_force
	
	if not is_on_floor():
		velocity.y += gravity


func handle_most_player_animations(direction: float) -> void:

	match FishingSystem.action_being_performed:
		FishingSystem.ACTIONS.EQUIPPING_ROD:
			animation_player.play("equipping_rod")
		FishingSystem.ACTIONS.CASTING:
			animation_player.play("cast")
		FishingSystem.ACTIONS.FISHING:
			animation_player.play("fish_idle")
		FishingSystem.ACTIONS.HOOKING:
			animation_player.play("hook")
		FishingSystem.ACTIONS.NOT_FISHING_STUFF:
			if direction != 0:
				player_sprite.flip_h = (direction == -1)
				animation_player.play("walk")
			else:
				animation_player.play("idle")

	if not is_on_floor():
		animation_player.play("idle")


func check_fishing_rod_visibility() -> void:
	if FishingSystem.action_being_performed == FishingSystem.ACTIONS.NOT_FISHING_STUFF:
		fishing_rod_handle_sprite.visible = false
		fishing_rod_end_part_sprite.visible = false
	else:
		fishing_rod_handle_sprite.visible = true
		fishing_rod_end_part_sprite.visible = true


func _on_actual_spot_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		FishingSystem.is_able_to_fish = true
		if FishingSystem.action_being_performed == FishingSystem.ACTIONS.NOT_FISHING_STUFF:
			key_to_equip_rod_UI.visible = true
		else:
			key_to_equip_rod_UI.visible = false

func _on_actual_spot_body_exited(body: PhysicsBody2D) -> void:
	if body is Player:
		FishingSystem.is_able_to_fish = false
		FishingSystem.action_being_performed = FishingSystem.ACTIONS.NOT_FISHING_STUFF
		key_to_equip_rod_UI.visible = false

func _on_animation_player_animation_finished(anim_name) -> void:
	match anim_name:
		"cast":
			FishingSystem.action_being_performed = FishingSystem.ACTIONS.FISHING
		"hook":
			FishingSystem.action_being_performed = FishingSystem.ACTIONS.EQUIPPING_ROD
			FishingSystem.is_already_fishing = false


func handle_selling(slot, item_info, sell_button) -> void:
	
	if is_able_to_sell:
		if inventory.slots[slot].item == null:
			return
		
		if inventory.slots[slot].amount == 1:
			GameManager.update_coins.emit(inventory.slots[slot].item.value)
			inventory.slots[slot].item = null
			inventory.slots[slot].amount = 0
			item_info.visible = false
			sell_button.set_default_cursor_shape(Input.CURSOR_ARROW)
			$InventoryGUI.update(inventory)
			is_able_to_sell = false
			await get_tree().create_timer(2).timeout
			is_able_to_sell = true
		
		if inventory.slots[slot].amount > 1:
			GameManager.update_coins.emit(inventory.slots[slot].item.value)
			inventory.slots[slot].amount -= 1
			$InventoryGUI.update(inventory)
			is_able_to_sell = false
			await get_tree().create_timer(2).timeout
			is_able_to_sell = true
	else:
		return  


func handle_selling_all(slot, item_info, sell_button) -> void:
	if is_able_to_sell:
		if inventory.slots[slot].amount >= 1:
			GameManager.update_coins.emit(inventory.slots[slot].amount * inventory.slots[slot].item.value)
			inventory.slots[slot].item = null
			inventory.slots[slot].amount = 0
			item_info.visible = false
			sell_button.set_default_cursor_shape(Input.CURSOR_ARROW)
			$InventoryGUI.update(inventory)
			is_able_to_sell = false
			await get_tree().create_timer(2).timeout
			is_able_to_sell = true
		else: 
			return


func show_actual_info(slot, item_info, item_name, item_rarity, item_description, item_value, sell_button) -> void:
	
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
