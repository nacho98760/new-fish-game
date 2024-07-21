extends Node2D
class_name FishingSystem

@export var action_being_performed: String = "not fishing stuff"
@export var is_able_to_fish: bool = false
@export var is_there_a_fish: bool = false
@export var is_already_fishing: bool = false
@export var is_already_catching_a_fish: bool = false

var time_when_there_is_no_fish
var time_when_there_is_a_fish
var hooked_fish

func handle_inventory_items(parent, direction, player_sprite):
	if Input.is_action_just_pressed("equipRod") && is_able_to_fish:
		if not parent.is_on_floor() or player_sprite.flip_h or is_already_fishing: 
			return
		
		if action_being_performed == "equipping rod":
			action_being_performed = "not fishing stuff"
		else:
			action_being_performed = "equipping rod"


func fishing_system(parent, end_of_fishing_rod, exclamation_mark_sprite, fish_catch_UI, fishing_minigame):
	if Input.is_action_just_pressed("leftclick") && is_able_to_fish && fish_catch_UI.visible == false:
		if is_already_fishing && is_there_a_fish:
			handle_hooking(parent, end_of_fishing_rod, exclamation_mark_sprite, fishing_minigame)
			is_there_a_fish = false
		
		if action_being_performed == "equipping rod" && !is_already_fishing:
			handle_casting(parent, exclamation_mark_sprite)


func handle_casting(parent, exclamation_mark_sprite):
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


func handle_hooking(parent, end_of_fishing_rod, exclamation_mark_sprite, fishing_minigame):
	
	var fishing_minigame_container = fishing_minigame.get_node("MainPanel").get_node("NinePatchRect")
	
	if is_already_catching_a_fish == false:
		is_already_catching_a_fish = true
		time_when_there_is_no_fish.stop()
		time_when_there_is_a_fish.stop()
		
		var fish_scene = preload("res://fishing/fish/fish.tscn")
		hooked_fish = fish_scene.instantiate()
		
		parent.add_child(hooked_fish)
		hooked_fish.randomize_fish()
		hooked_fish.position = Vector2(1000, 1000)
		exclamation_mark_sprite.visible = false
		fishing_minigame.visible = true
		
		fishing_minigame.spawn_target()
		fishing_minigame.move_arrow()
	else:
		fishing_minigame.visible = false
		action_being_performed = "hooking"
		hooked_fish.position = end_of_fishing_rod.position
		hooked_fish.being_hooked()
		is_already_catching_a_fish = false
		
		if fishing_minigame_container.get_child_count() >= 1:
			fishing_minigame_container.get_child(1).queue_free()
