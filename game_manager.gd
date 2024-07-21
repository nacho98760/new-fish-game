extends Node

signal updated
signal sell_fish_actual_inv_stuff
signal update_coins
signal update_rod
signal show_item_info
signal set_arrow_speed_AND_target_size
signal player_won_minigame

var fish_array: Array[String] = ["clown_fish"]


func _ready():
	GameManager.update_rod.connect(handle_rod_types)

func handle_rod_types(rod) -> void:
	match rod:
		"default":
			fish_array = ["clown_fish"]
		"red_rod":
			fish_array = ["rare_fish"]
		"blue_rod":
			fish_array = ["blue_tang_fish"]
		"turquoise_rod":
			fish_array = ["clown_fish", "rare_fish", "blue_tang_fish"]

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
