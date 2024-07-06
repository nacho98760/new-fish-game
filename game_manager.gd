extends Node

signal updated

signal sell_fish_actual_inv_stuff
signal update_coins

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
