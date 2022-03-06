extends "res://scripts/Tank.gd"
# Called when the node enters the scene tree for the first time.
func _init():
	maxBullets = 5

func _ready():
	pass # Replace with function body.

func destroy(): #redefines destroy
	get_tree().quit()
