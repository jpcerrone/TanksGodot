extends "res://scripts/EnemyTank.gd"


func _ready():
	$ChangeDirectionTimer.wait_time = rng.randf_range(0, 5.0)
	pass # Replace with function body.

func _on_ChangeDirectionTimer_timeout():
	rotationDirection = -rotationDirection
	$ChangeDirectionTimer.wait_time = rng.randf_range(0, 5.0)
