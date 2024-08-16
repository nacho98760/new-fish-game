extends Node2D

enum ACTION_BEING_PERFORMED {
	NOT_FISHING_STUFF,
	EQUIPPING_ROD,
	CASTING,
	FISHING,
	HOOKING,
}

var x = 10
var y = 20
var z = 30

@export var action_being_performed: String = "not fishing stuff"
@export var is_able_to_fish: bool = false
@export var is_there_a_fish: bool = false
@export var is_already_fishing: bool = false
@export var is_already_catching_a_fish: bool = false

var random_fish_position := Vector2(1000, 1000)

var time_when_there_is_no_fish: Timer
var time_when_there_is_a_fish: Timer

var fish_scene: PackedScene = preload("res://fishing/fish/fish.tscn")
var hooked_fish: CharacterBody2D

func handle_inventory_items(parent: Player, player_sprite: Sprite2D) -> void:

	if Input.is_action_just_pressed("equipRod") and is_able_to_fish:

		if not parent.is_on_floor() or is_already_fishing or player_sprite.flip_h: 
			return
		
		if action_being_performed == "equipping rod":
			action_being_performed = "not fishing stuff"
		else:
			action_being_performed = "equipping rod"


func fishing_system(parent: Player, end_of_rod: Marker2D, exclamation_mark_sprite: Sprite2D, fish_catch_UI: Control, fishing_minigame: Control) -> void:

	if Input.is_action_just_pressed("leftclick") and is_able_to_fish and fish_catch_UI.visible == false:

		if is_already_fishing and is_there_a_fish:
			handle_hooking(parent, end_of_rod, exclamation_mark_sprite, fishing_minigame)
			is_there_a_fish = false
		
		if action_being_performed == "equipping rod" and is_already_fishing == false:
			handle_casting(parent, exclamation_mark_sprite)


func handle_casting(parent: Player, exclamation_mark_sprite: Sprite2D) -> void:
	
	action_being_performed = "casting"
	is_already_fishing = true
	
	time_when_there_is_no_fish = Timer.new()
	time_when_there_is_no_fish.set_one_shot(true)
	time_when_there_is_no_fish.set_wait_time(randi_range(3,7))
	time_when_there_is_no_fish.set_autostart(false)
	
	time_when_there_is_a_fish = Timer.new()
	time_when_there_is_a_fish.set_one_shot(true)
	time_when_there_is_a_fish.set_wait_time(randi_range(2,4))
	time_when_there_is_a_fish.set_autostart(false)
	
	time_when_there_is_no_fish.connect(
		"timeout", 
		func can_fish():
			is_there_a_fish = true
			exclamation_mark_sprite.visible = true
			time_when_there_is_a_fish.start()
	)
	
	time_when_there_is_a_fish.connect(
		"timeout", 
		func cannot_fish():
			is_there_a_fish = false
			exclamation_mark_sprite.visible = false
			time_when_there_is_no_fish.start()
	)
	
	parent.add_child(time_when_there_is_no_fish)
	parent.add_child(time_when_there_is_a_fish)
	
	time_when_there_is_no_fish.start()


func handle_hooking(parent: Player, end_of_rod: Marker2D, exclamation_mark_sprite: Sprite2D, fishing_minigame: Control) -> void:
	
	var fishing_minigame_container = fishing_minigame.get_node("MainPanel").get_node("NinePatchRect")
	
	if is_already_catching_a_fish == false:
		is_already_catching_a_fish = true
		time_when_there_is_no_fish.stop()
		time_when_there_is_a_fish.stop()
		
		hooked_fish = fish_scene.instantiate()
		parent.add_child(hooked_fish)
		hooked_fish.randomize_fish()
		hooked_fish.position = random_fish_position
		exclamation_mark_sprite.visible = false
		fishing_minigame.visible = true	

		fishing_minigame.spawn_target()
		fishing_minigame.move_arrow()
	else:
		action_being_performed = "hooking"
		hooked_fish.being_hooked(end_of_rod)
		fishing_minigame.visible = false
		is_already_catching_a_fish = false
		
		if fishing_minigame_container.get_child_count() > 1:
			fishing_minigame_container.get_child(1).queue_free()
