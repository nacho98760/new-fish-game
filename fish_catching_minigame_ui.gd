extends Control

@onready var arrow = $Panel/Arrow

func _ready():
	var tween1 = create_tween()
	
	tween1.tween_property(arrow, "position", Vector2(51, 232), 2)
	tween1.tween_property(arrow, "position", Vector2(51, 13), 2)
	tween1.set_loops()
