extends Control

var arrow_speed: float
var target_height: int
var default_target_width: int = 16
var arrow_minimum_range: int = 0
var arrow_maximum_range: int = 220

var cooldown_timer: Timer
var on_cooldown: bool = false

var target_scene: PackedScene = preload("res://fishing/fishing_minigame/target.tscn")

@onready var arrow: Panel = $MainPanel/NinePatchRect/Arrow
@onready var nine_patch_rect: NinePatchRect = $MainPanel/NinePatchRect
@onready var progress_bar: ProgressBar = $MainPanel/ProgressBar


func _ready() -> void:
	
	progress_bar.value = 1
	
	GameManager.set_arrow_speed_AND_target_size.connect(set_speed_and_size)

	cooldown_timer = GameManager.create_timer(1, false, true)

	cooldown_timer.connect("timeout", func(): on_cooldown = false)

	self.add_child(cooldown_timer)



func _process(_delta: float) -> void:
	check_progress_bar_value()

func _input(event) -> void:
	if event.is_action_pressed("fishing_minigame_key") and self.visible == true:

		if on_cooldown:
			return

		on_cooldown = true
		cooldown_timer.start()

		var target = nine_patch_rect.get_child(1)

		if ((arrow.position.y + arrow.size.y / 2) > target.position.y) and ((arrow.position.y - arrow.size.y / 2) < target.position.y + target.size.y):
			target.queue_free()
			progress_bar.value += 20
			spawn_target()
		else:
			progress_bar.value -= 20


func set_speed_and_size(SPEED, HEIGHT) -> void:
	arrow_speed = SPEED
	target_height = HEIGHT

func spawn_target() -> void:
	var new_target = target_scene.instantiate()
	nine_patch_rect.add_child(new_target)
	new_target.size = Vector2(default_target_width, target_height)
	new_target.position = Vector2(2, randf_range(1, nine_patch_rect.size.y - target_height))

func move_arrow() -> void:
	var tween1 = create_tween()
	tween1.tween_property(arrow, "position", Vector2(20, arrow_minimum_range), arrow_speed)
	tween1.tween_property(arrow, "position", Vector2(20, arrow_maximum_range), arrow_speed)
	tween1.set_loops(0)

func check_progress_bar_value() -> void:
	if progress_bar.value >= 100:
		GameManager.player_won_minigame.emit()
		progress_bar.value = 1
		
	if progress_bar.value <= 0:
		GameManager.player_lost_minigame.emit()
		progress_bar.value = 1
