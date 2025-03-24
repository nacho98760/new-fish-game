extends HSlider

@export var bus_name: String
var bus_index: int

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func save_data(save: PlayerData) -> void:
	save.music_volume = value

func load_data(save: PlayerData) -> void:
	if save == null:
		value = 1
		bus_index = AudioServer.get_bus_index(bus_name)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		return
	
	value = save.music_volume
	bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
