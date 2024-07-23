extends CharacterBody2D

@export var inventory_item: InventoryItem
@export var hook_force_x: int = 40
@export var hook_force_y: int = 205
@export var is_being_hooked: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var arrow_speed: Dictionary = {
	"RARE": 3,
	"SUPER_RARE": 2,
	"EPIC": 1,
	"LEGENDARY": 0.5,
}

var target_height: Dictionary = {
	"RARE": 40,
	"SUPER_RARE": 30,
	"EPIC": 20,
	"LEGENDARY": 10,
}

@onready var fish_sprite = $Sprite2D

func _physics_process(_delta: float) -> void:
	if !(is_on_floor() and is_being_hooked):
		velocity.y += gravity
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func being_hooked(end_of_rod: Marker2D) -> void:
	is_being_hooked = true
	position = end_of_rod.position
	velocity = Vector2(-hook_force_x, -hook_force_y)

func _on_area_2d_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		body.inventory.insert(inventory_item)
		
		var fish_catch_UI = body.get_node("FishCatchUI")
		fish_catch_UI.visible = true
		
		var fish_frame = fish_catch_UI.get_fish_frame()
		var fish_name = fish_catch_UI.get_fish_name()
		var fish_rarity = fish_catch_UI.get_fish_rarity()
		var fish_value = fish_catch_UI.get_fish_value()
		var fish_width = fish_catch_UI.get_fish_width()
		var fish_weight = fish_catch_UI.get_fish_weight()
		
		fish_frame.texture = inventory_item.texture
		fish_name.text = inventory_item.name
		fish_rarity.text = "(" + inventory_item.rarity + ")"
		fish_rarity.self_modulate = inventory_item.rarity_color
		fish_value.text = "$" + str(inventory_item.value)
		fish_width.text = str(inventory_item.width) + "cm"
		fish_weight.text = str(inventory_item.weight) + "kg"
		
		queue_free() 


func randomize_fish() -> void:
	var selected_fish = GameManager.fish_array[randi_range(0, GameManager.fish_array.size() - 1)]
	
	match selected_fish:
		"clown_fish":
			fish_sprite.texture = load("res://fishing/fish/fish_textures/clown_fish.png")
			inventory_item = preload("res://Inventory/items/clown_fish.tres")
		"rare_fish":
			fish_sprite.texture = load("res://fishing/fish/fish_textures/rare_fish.png")
			inventory_item = preload("res://Inventory/items/rare_fish.tres")
		"blue_tang_fish":
			fish_sprite.texture = load("res://fishing/fish/fish_textures/blue_tang_fish.png")
			inventory_item = preload("res://Inventory/items/blue_tang_fish.tres")
	
	match inventory_item.rarity:
		"Rare":
			GameManager.set_arrow_speed_AND_target_size.emit(arrow_speed["RARE"], target_height["RARE"])
		"Super Rare":
			GameManager.set_arrow_speed_AND_target_size.emit(arrow_speed["SUPER_RARE"], target_height["SUPER_RARE"])
		"Epic":
			GameManager.set_arrow_speed_AND_target_size.emit(arrow_speed["EPIC"], target_height["EPIC"])
