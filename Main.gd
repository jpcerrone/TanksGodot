extends Node2D

const maxBullets = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.currentBullets = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Global.currentBullets < maxBullets) && Input.is_action_just_pressed("shoot"):
		$PlayerTank.shoot()
		Global.currentBullets += 1
