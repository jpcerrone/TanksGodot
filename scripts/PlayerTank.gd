extends "res://scripts/Tank.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func destroy(): #redefines destroy
	get_tree().quit()

func shoot(): #redefines shoot
	var bullet = Bullet.instance()
	bullet.add_to_group("playerBullets")
	var canonTipPosition = position + Vector2(50, 1).rotated($Cannon.rotation)
	bullet.setup(canonTipPosition, Vector2(1,0).rotated($Cannon.rotation))
	get_node("/root/Main").add_child(bullet)
