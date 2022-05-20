extends "res://scripts/Tank.gd"
signal player_dies
# Called when the node enters the scene tree for the first time.
func _init():
	maxBullets = 5
	maxMines = 2

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	Global.p1Position = position

func destroy():
	emit_signal("player_dies")
	.destroy()
