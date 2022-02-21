extends "res://scripts/Tank.gd"

var rotationDirection = 1
var rng = RandomNumberGenerator.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	$Cannon.rotation += delta * rotationDirection
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	shoot()

func _on_ChangeDirectionTimer_timeout():
	rotationDirection = -rotationDirection
	$ChangeDirectionTimer.wait_time = rng.randf_range(0, 5.0)
