extends Label
class_name Coins

var total_coins: int

func _ready() -> void:
	GameManager.update_coins.connect(handle_coins_update)
	text = str(total_coins)

func get_coins() -> int:
	return total_coins

func handle_coins_update(value: int) -> void:
	total_coins += value
	text = str(total_coins)

func save_data(save: PlayerData) -> void:
	save.player_coins = total_coins

func load_data(save: PlayerData) -> void:
	if save == null:
		total_coins = 0
		return
		
	total_coins = save.player_coins
