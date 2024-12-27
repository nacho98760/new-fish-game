extends CharacterBody2D

@export var inventory_item: InventoryItem
@export var hook_force_x: int = 40
@export var hook_force_y: int = 205
@export var is_being_hooked: bool = false

@onready var fish_index_UI = get_tree().get_first_node_in_group("FishIndexUI")
@onready var fish_index_label = fish_index_UI.get_node("NinePatchRect").get_node("Label")
@onready var gray_fish_frame = fish_index_UI.get_node("NinePatchRect").get_node("GridContainer").get_node("GrayFishFrame")
@onready var clown_fish_frame = fish_index_UI.get_node("NinePatchRect").get_node("GridContainer").get_node("ClownFishFrame")
@onready var yellowtail_kingfish_frame = fish_index_UI.get_node("NinePatchRect").get_node("GridContainer").get_node("YellowTailKingFishFrame")
@onready var brown_fish_frame = fish_index_UI.get_node("NinePatchRect").get_node("GridContainer").get_node("BrownFishFrame")
@onready var blue_tang_fish_frame = fish_index_UI.get_node("NinePatchRect").get_node("GridContainer").get_node("BlueTangFishFrame")
@onready var shiny_fish_frame = fish_index_UI.get_node("NinePatchRect").get_node("GridContainer").get_node("ShinyFishFrame")
@onready var striped_tigerbarb_fish_frame = fish_index_UI.get_node("NinePatchRect").get_node("GridContainer").get_node("StripedTigerbarbFishFrame")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var arrow_speed: Dictionary = {
	"COMMON": 2.5,
	"UNCOMMON": 2.1,
	"RARE": 1.75,
	"EPIC": 1.3,
	"LEGENDARY": 0.9,
}

var target_height: Dictionary = {
	"COMMON": 50,
	"UNCOMMON": 45,
	"RARE": 35,
	"EPIC": 25,
	"LEGENDARY": 15,
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
	if body is Player:
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
		
		
		add_fish_to_index(inventory_item)
		
		queue_free() 


func randomize_fish() -> void:
	var selected_fish = GameManager.fish_array[randi_range(0, GameManager.fish_array.size() - 1)]
	
	match selected_fish:
		"gray_fish":
			fish_sprite.texture = load("res://fishing/fish/fish_textures/gray_fish.png")
			inventory_item = preload("res://Inventory/items/gray_fish.tres")
		"clown_fish":
			fish_sprite.texture = load("res://fishing/fish/fish_textures/clown_fish.png")
			inventory_item = preload("res://Inventory/items/clown_fish.tres")
		"yellowtail_kingfish":
			fish_sprite.texture = load("res://fishing/fish/fish_textures/yellowtail_kingfish.png")
			inventory_item = preload("res://Inventory/items/yellowtail_kingfish.tres")
		"brown_fish":
			fish_sprite.texture = load("res://fishing/fish/fish_textures/rare_fish.png")
			inventory_item = preload("res://Inventory/items/brown_fish.tres")
		"blue_tang_fish":
			fish_sprite.texture = load("res://fishing/fish/fish_textures/blue_tang_fish.png")
			inventory_item = preload("res://Inventory/items/blue_tang_fish.tres")
		"shiny_fish":
			fish_sprite.texture = load("res://fishing/fish/fish_textures/shiny_fish.png")
			inventory_item = preload("res://Inventory/items/shiny_fish.tres")
		"striped_tigerbarb_fish":
			fish_sprite.texture = load("res://fishing/fish/fish_textures/striped_tigerbarb_fish.png")
			inventory_item = preload("res://Inventory/items/striped_tigerbarb_fish.tres")
	
	match inventory_item.rarity:
		"Common":
			GameManager.set_arrow_speed_AND_target_size.emit(arrow_speed["COMMON"], target_height["COMMON"])
		"Uncommon":
			GameManager.set_arrow_speed_AND_target_size.emit(arrow_speed["UNCOMMON"], target_height["UNCOMMON"])
		"Rare":
			GameManager.set_arrow_speed_AND_target_size.emit(arrow_speed["RARE"], target_height["RARE"])
		"Epic":
			GameManager.set_arrow_speed_AND_target_size.emit(arrow_speed["EPIC"], target_height["EPIC"])
		"Legendary":
			GameManager.set_arrow_speed_AND_target_size.emit(arrow_speed["LEGENDARY"], target_height["LEGENDARY"])



func add_fish_to_index(inventory_item):
	
	match inventory_item.name:
		"Gray Fish":
			if fish_index_UI.player_has_gray_fish == false:
				fish_index_UI.fish_types_the_player_has.append("gray_fish")
				fish_index_label.text = str(fish_index_UI.fish_types_the_player_has.size()) + "/" + str(fish_index_UI.amount_of_fish_types_in_game) + " species found"
			
			fish_index_UI.player_has_gray_fish = true
			gray_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/gray_fish.png")
		
		"Clown Fish":
			if fish_index_UI.player_has_clown_fish == false:
				fish_index_UI.fish_types_the_player_has.append("clown_fish")
				fish_index_label.text = str(fish_index_UI.fish_types_the_player_has.size()) + "/" + str(fish_index_UI.amount_of_fish_types_in_game) + " species found"
			
			fish_index_UI.player_has_clown_fish = true
			clown_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/clown_fish.png")
		
		"Yellowtail Kingfish":
			if fish_index_UI.player_has_yellowtail_kingfish == false:
				fish_index_UI.fish_types_the_player_has.append("yellowtail_kingfish")
				fish_index_label.text = str(fish_index_UI.fish_types_the_player_has.size()) + "/" + str(fish_index_UI.amount_of_fish_types_in_game) + " species found"
			
			fish_index_UI.player_has_yellowtail_kingfish = true
			yellowtail_kingfish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/yellowtail_kingfish.png")
		
		"Brown Fish":
			if fish_index_UI.player_has_brown_fish == false:
				fish_index_UI.fish_types_the_player_has.append("brown_fish")
				fish_index_label.text = str(fish_index_UI.fish_types_the_player_has.size()) + "/" + str(fish_index_UI.amount_of_fish_types_in_game) + " species found"
			
			fish_index_UI.player_has_brown_fish = true
			brown_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/rare_fish.png")
		
		"Blue Tang Fish":
			if fish_index_UI.player_has_blue_tang_fish == false:
				fish_index_UI.fish_types_the_player_has.append("blue_tang_fish")
				fish_index_label.text = str(fish_index_UI.fish_types_the_player_has.size()) + "/" + str(fish_index_UI.amount_of_fish_types_in_game) + " species found"
			
			fish_index_UI.player_has_blue_tang_fish = true
			blue_tang_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/blue_tang_fish.png")
		
		"Shiny Fish":
			if fish_index_UI.player_has_shiny_fish == false:
				fish_index_UI.fish_types_the_player_has.append("shiny_fish")
				fish_index_label.text = str(fish_index_UI.fish_types_the_player_has.size()) + "/" + str(fish_index_UI.amount_of_fish_types_in_game) + " species found"
			
			fish_index_UI.player_has_shiny_fish = true
			shiny_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/shiny_fish.png")
		
		"Tigerbarb Fish":
			if fish_index_UI.player_has_striped_tigerbarb_fish == false:
				fish_index_UI.fish_types_the_player_has.append("striped_tigerbarb_fish")
				fish_index_label.text = str(fish_index_UI.fish_types_the_player_has.size()) + "/" + str(fish_index_UI.amount_of_fish_types_in_game) + " species found"
			
			fish_index_UI.player_has_striped_tigerbarb_fish = true
			striped_tigerbarb_fish_frame.get_node("Sprite2D").texture = preload("res://fishing/fish/fish_textures/striped_tigerbarb_fish.png")
