extends "res://scripts/Tank.gd"
signal player_dies
# Called when the node enters the scene tree for the first time.
func _init():
	pass

func _ready():
	collision_layer = 2 # Need to set it here as the UI seems to be buggy on 3.4, it always sets it to 1 no mather what you choose

func _physics_process(_delta):
	Global.p1Position = position
	rotateCannon(get_global_mouse_position().angle_to_point(position))

func destroy():
	emit_signal("player_dies")
	.destroy()
