extends KinematicBody2D

export (int) var speed = 175
export (float) var rotation_speed = 5.0
var velocity = Vector2()
var rotation_dir = 0
var tankRotation = 0.0

const Bullet = preload("res://Bullet.tscn")
enum Direction {UP, DOWN, LEFT, RIGHT, DOWN_LEFT, DOWN_RIGHT, UP_LEFT, UP_RIGHT}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func isRotationWithinDeltaForDirections(direction1, direction2, rotDelta):
	var isWithinDeltaFirstDirection = (tankRotation > direction1 - rotDelta) && (tankRotation < direction1 + rotDelta)
	if (isWithinDeltaFirstDirection):
		tankRotation = direction1
	var isWithinDeltaSecondDirection = (tankRotation > direction2 - rotDelta) && (tankRotation < direction2 + rotDelta)
	if (isWithinDeltaSecondDirection):
		tankRotation = direction2
	return isWithinDeltaFirstDirection || isWithinDeltaSecondDirection

func get_dir_to_allign_diagonal_up():
	if (tankRotation < PI/4) || (tankRotation >= 7*PI/4):
		return 1
	elif (tankRotation < 3*PI/4):
		return -1
	elif (tankRotation < 5*PI/4):
		return 1
	elif (tankRotation < 7*PI/4):
		return -1

func get_dir_to_allign_diagonal_down():
	return -get_dir_to_allign_diagonal_up()

func get_dir_to_allign_vertical():
	if (tankRotation < PI/2):
		return -1
	elif (tankRotation < PI):
		return 1
	elif (tankRotation < 3*PI/2):
		return -1
	elif (tankRotation < 2*PI):
		return 1

func get_dir_to_allign_horizontal():
	return -get_dir_to_allign_vertical()

func move(delta, direction):
	#delete previous rotation and movement values
	rotation_dir = 0
	velocity = Vector2(0, 0)
	
	var rotDelta = rotation_speed * delta
	
	match(direction):
		Direction.RIGHT:
			if !isRotationWithinDeltaForDirections(PI/2, 3*PI/2, rotDelta):
				rotation_dir = get_dir_to_allign_horizontal()
			else:
				velocity = Vector2(1,0)
		Direction.LEFT:
			if !isRotationWithinDeltaForDirections(PI/2, 3*PI/2, rotDelta):
				rotation_dir = get_dir_to_allign_horizontal()
			else:
				velocity = Vector2(-1,0)
		Direction.UP:
			if !isRotationWithinDeltaForDirections(0, PI, rotDelta):
				rotation_dir = get_dir_to_allign_vertical()
			else:
				velocity = Vector2(0,-1)
		Direction.DOWN:
			if !isRotationWithinDeltaForDirections(0, PI, rotDelta):
				rotation_dir = get_dir_to_allign_vertical()
			else:
				velocity = Vector2(0,1)
		Direction.DOWN_LEFT:
			if !isRotationWithinDeltaForDirections(PI/4, 5*PI/4, rotDelta):
				rotation_dir = get_dir_to_allign_diagonal_up()
			else:
				velocity = Vector2(-1,1)
		Direction.DOWN_RIGHT:
			if !isRotationWithinDeltaForDirections(3*PI/4, 7*PI/4, rotDelta):
				rotation_dir = get_dir_to_allign_diagonal_down()
			else:
				velocity = Vector2(1,1)
		Direction.UP_LEFT:
			if !isRotationWithinDeltaForDirections(3*PI/4, 7*PI/4, rotDelta):
				rotation_dir = get_dir_to_allign_diagonal_down()
			else:
				velocity = Vector2(-1,-1)
		Direction.UP_RIGHT:
			if !isRotationWithinDeltaForDirections(PI/4, 5*PI/4, rotDelta):
				rotation_dir = get_dir_to_allign_diagonal_up()
			else:
				velocity = Vector2(1,-1)	
	
	tankRotation += rotation_dir * rotDelta
	#Only one tankRotation is counted
	if (tankRotation > 2*PI):
		tankRotation = tankRotation - 2*PI
	if (tankRotation < 0):
		tankRotation = tankRotation + 2*PI

	updateRotationAnimation()
	
	if (velocity != Vector2(0,0)):
		velocity = velocity.normalized() * speed
		velocity = move_and_slide(velocity)

func updateRotationAnimation():
	if (tankRotation <= PI/8) || (tankRotation > 7*PI/4) :
		$AnimationPlayer.current_animation = "vertical"
	elif (tankRotation <= 3*PI/8):
		$AnimationPlayer.current_animation = "diagonal_up"
	elif (tankRotation <= 5*PI/8):
		$AnimationPlayer.current_animation = "horizontal"
	elif (tankRotation <= 7*PI/8):
		$AnimationPlayer.current_animation = "diagonal_down"
	elif (tankRotation <= PI):
		$AnimationPlayer.current_animation = "vertical"
	elif (tankRotation <= 10*PI/8):
		$AnimationPlayer.current_animation = "diagonal_up"
	elif (tankRotation <= 12*PI/8):
		$AnimationPlayer.current_animation = "horizontal"
	elif (tankRotation <= 14*PI/8):
		$AnimationPlayer.current_animation = "diagonal_down"

func rotateCannon(angle):
	$Cannon.rotation = angle

func shoot(target):
	var bullet
	bullet = Bullet.instance()
	var canonTipPosition = position + Vector2(50, 1).rotated($Cannon.rotation)
	bullet.setup(canonTipPosition, (target - position).normalized())
	get_node("/root/Main").add_child(bullet)
	
func destroy():
	queue_free()
