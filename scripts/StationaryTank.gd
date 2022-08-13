extends "res://scripts/EnemyTank.gd"

const maxChangeDirectionTime = 5.0

func _ready():
	$ChangeDirectionTimer.wait_time = rng.randf_range(0, maxChangeDirectionTime)

func _on_ChangeDirectionTimer_timeout():
	rotationDirection = -rotationDirection
	$ChangeDirectionTimer.wait_time = rng.randf_range(0, maxChangeDirectionTime)
