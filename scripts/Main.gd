extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$PlayerTank.rotateCannon(get_global_mouse_position().angle_to_point($PlayerTank.position))
	
	var tankDirection
	if (Input.is_action_pressed("move_up") && Input.is_action_pressed("move_right")):
		tankDirection = $PlayerTank.directions.UP_RIGHT
	elif (Input.is_action_pressed("move_down") && Input.is_action_pressed("move_left")):
		tankDirection = $PlayerTank.directions.DOWN_LEFT
	elif (Input.is_action_pressed("move_up") && Input.is_action_pressed("move_left")):
		tankDirection = $PlayerTank.directions.UP_LEFT
	elif Input.is_action_pressed("move_down") && Input.is_action_pressed("move_right"):
		tankDirection = $PlayerTank.directions.DOWN_RIGHT
	elif Input.is_action_pressed("move_up") :
		tankDirection = $PlayerTank.directions.UP
	elif Input.is_action_pressed("move_down"):
		tankDirection = $PlayerTank.directions.DOWN
	elif Input.is_action_pressed("move_left"):
		tankDirection = $PlayerTank.directions.LEFT
	elif Input.is_action_pressed("move_right"):
		tankDirection = $PlayerTank.directions.RIGHT
	if tankDirection:
		$PlayerTank.move(delta, tankDirection)

	if Input.is_action_just_pressed("shoot"):
		$PlayerTank.shoot()
		
	if Input.is_action_just_pressed("plant_mine"):
		$PlayerTank.plantMine()

