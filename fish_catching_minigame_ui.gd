extends Control

@onready var arrow = $MainPanel/NinePatchRect/Arrow
@onready var target = $MainPanel/NinePatchRect/Target

func _ready():
	var tween1 = create_tween()
	
	tween1.tween_property(arrow, "position", Vector2(20, -6), 2)
	tween1.tween_property(arrow, "position", Vector2(20, 220), 2)
	tween1.set_loops(0)


func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		if arrow.position.y > (target.position.y) and arrow.position.y < (target.position.y + target.size.y - arrow.size.y / 2):
			target.queue_free()
