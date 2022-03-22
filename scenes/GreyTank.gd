extends "res://scripts/Tank.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	$Cannon.look_at(Global.p1Position)
