extends Node2D

const maxBullets = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$PlayerTank.rotateCannon(get_global_mouse_position().angle_to_point($PlayerTank.position))
	
	var tankDirection
	if (Input.is_action_pressed("move_up") && Input.is_action_pressed("move_right")):
		tankDirection = $PlayerTank.Direction.UP_RIGHT
	elif (Input.is_action_pressed("move_down") && Input.is_action_pressed("move_left")):
		tankDirection = $PlayerTank.Direction.DOWN_LEFT
	elif (Input.is_action_pressed("move_up") && Input.is_action_pressed("move_left")):
		tankDirection = $PlayerTank.Direction.UP_LEFT
	elif Input.is_action_pressed("move_down") && Input.is_action_pressed("move_right"):
		tankDirection = $PlayerTank.Direction.DOWN_RIGHT
	elif Input.is_action_pressed("move_up") :
		tankDirection = $PlayerTank.Direction.UP
	elif Input.is_action_pressed("move_down"):
		tankDirection = $PlayerTank.Direction.DOWN
	elif Input.is_action_pressed("move_left"):
		tankDirection = $PlayerTank.Direction.LEFT
	elif Input.is_action_pressed("move_right"):
		tankDirection = $PlayerTank.Direction.RIGHT
	$PlayerTank.move(delta, tankDirection)

	if (get_tree().get_nodes_in_group("playerBullets").size() < maxBullets) && Input.is_action_just_pressed("shoot"):
		$PlayerTank.shoot()
