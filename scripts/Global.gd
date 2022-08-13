extends Node

# Constants
const MAX_INT = 9223372036854775807 # 2^63 - 1

# Global variables
var p1Position: Vector2

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS # This node ignores pause so that we can quit anytime

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
