extends CharacterBody2D
class_name Fish

@export var inventory_item: InventoryItem
@export var hook_force_x: int = 40
@export var hook_force_y: int = 205
@export var is_being_hooked: bool = false
@onready var fish_sprite = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var selected_fish


func _physics_process(delta):
	if not(is_on_floor() and is_being_hooked):
		velocity.y += gravity
		
	move_and_slide()

func being_hooked():
	is_being_hooked = true
	velocity = Vector2(-hook_force_x, -hook_force_y)

func _on_area_2d_body_entered(body: PhysicsBody2D):
	if body.name == "Player":
		body.inventory.insert(inventory_item)
		queue_free()


func randomize_fish():
	selected_fish = GameManager.fish_array[randi_range(0, GameManager.fish_array.size() - 1)]
	
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
