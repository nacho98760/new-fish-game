extends Node

signal updated
signal sell_fish_actual_inv_stuff
signal sell_all_fish
signal update_coins
signal update_rod
signal show_item_info
signal set_arrow_speed_AND_target_size
signal player_won_minigame
signal player_lost_minigame

var fish_array: Array[String] = ["clown_fish"]


func _ready():
	GameManager.update_rod.connect(handle_rod_types)


func handle_rod_types(rod) -> void:
	match rod:
		"default":
			fish_array = [
				"gray_fish", "gray_fish", "gray_fish", 
				"clown_fish", "clown_fish", "clown_fish",
				"blue_fish", "blue_fish", 
				"yellowtail_kingfish", "yellowtail_kingfish",
			]
		
		"red_rod":
			fish_array = [
				"blue_fish", "blue_fish", "blue_fish",
				"yellowtail_kingfish", "yellowtail_kingfish", "yellowtail_kingfish",
				"brown_fish", "brown_fish",
			]
		
		"blue_rod":
			fish_array = [
				"brown_fish", "brown_fish", "brown_fish",
				"blue_tang_fish", "blue_tang_fish",
			]
		
		"turquoise_rod":
			fish_array = [
			"blue_tang_fish", "blue_tang_fish", "blue_tang_fish",
			"shiny_fish", "shiny_fish",
			"striped_tigerbarb_fish", "striped_tigerbarb_fish",
			]



# -------------------------------- UTIL FUNCTIONS -----------------------------------------

func create_timer(wait_time, does_auto_start: bool, does_it_fire_once: bool) -> Timer:
	var timer = Timer.new()
	timer.set_wait_time(wait_time)
	timer.set_autostart(does_auto_start)
	timer.set_one_shot(does_it_fire_once)
	
	return timer



# -------------------------------- SAVING AND LOADING DATA --------------------------------

func save_game() -> void:
	var save = PlayerData.new()
	var saved_nodes = get_tree().get_nodes_in_group("ThingsToSave")
	
	for node in saved_nodes:
		node.save_data(save)
	
	ResourceSaver.save(save, "user://savefile.tres")

func load_game() -> void:
	var save = null
	var saved_nodes = get_tree().get_nodes_in_group("ThingsToSave")
	
	if ResourceLoader.exists("user://savefile.tres"):
		save = PlayerData.new()
		save = ResourceLoader.load("user://savefile.tres", "", ResourceLoader.CACHE_MODE_REPLACE)
		for node in saved_nodes:
			node.load_data(save)
	else:
		for node in saved_nodes:
			node.load_data(save)
