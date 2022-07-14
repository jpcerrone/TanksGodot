extends "res://scripts/Tank.gd"
signal player_dies
# Called when the node enters the scene tree for the first time.
func _init():
	pass

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	Global.p1Position = position
	rotateCannon(get_global_mouse_position().angle_to_point(position))

func destroy():
	emit_signal("player_dies")
	.destroy()
