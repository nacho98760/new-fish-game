extends Node

signal updated

func save_game():
	var save = PlayerData.new()
	var saved_nodes = get_tree().get_nodes_in_group("ThingsToSave")

	for node in saved_nodes:
		node.save_data(save)

	ResourceSaver.save(save, "user://savefile.tres")
