extends Label

var total_coins: int

func _ready():
	GameManager.update_coins.connect(handle_coins_update)
	text = str(total_coins)

func get_coins():
	return total_coins

func handle_coins_update(value):
	total_coins += value
	text = str(total_coins)

func save_data(save: PlayerData):
	save.player_coins = total_coins

func load_data(save: PlayerData):
	if save == null:
		total_coins = 0
		return
		
	total_coins = save.player_coins
