extends Node

signal updated
signal sell_fish_actual_inv_stuff
signal update_coins
signal update_rod

var fish_array: Array

func _ready():
	GameManager.update_rod.connect(handle_rod_types)

func handle_rod_types(rod):
	match rod:
		"default":
			fish_array = ["clown_fish"]
		"red_rod":
			fish_array = ["rare_fish"]
		"blue_rod":
			fish_array = ["blue_tang_fish"]
		"turquoise_rod":
			fish_array = ["clown_fish", "rare_fish", "blue_tang_fish"]

func save_game():
	var save = PlayerData.new()
	var saved_nodes = get_tree().get_nodes_in_group("ThingsToSave")
	
	for node in saved_nodes:
		node.save_data(save)
		
	ResourceSaver.save(save, "user://savefile.tres")

func load_game():
	var save = PlayerData.new()
	save = ResourceLoader.load("user://savefile.tres", "", ResourceLoader.CACHE_MODE_REPLACE)
	
	var saved_nodes = get_tree().get_nodes_in_group("ThingsToSave")
	
	for node in saved_nodes:
		node.load_data(save)
