extends KinematicBody2D

export (int) var speed = 100
export (float) var rotation_speed = 2.0
var velocity = Vector2()
var rotation_dir = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func isRotationWithinDeltaForDirections(direction1, direction2, rotDelta):
	var isWithinDeltaFirstDirection = (rotation > direction1 - rotDelta) && (rotation < direction1 + rotDelta)
	if (isWithinDeltaFirstDirection):
		rotation = direction1
	var isWithinDeltaSecondDirection = (rotation > direction2 - rotDelta) && (rotation < direction2 + rotDelta)
	if (isWithinDeltaSecondDirection):
		rotation = direction2
	return isWithinDeltaFirstDirection || isWithinDeltaSecondDirection

func _physics_process(delta):
	rotation_dir = 0
	var rotDelta = rotation_speed * delta
	velocity = Vector2(0, 0)
	#Only one rotation is counted
	if (rotation > 2*PI):
		rotation = rotation - 2*PI
	if (rotation < 0):
		rotation = rotation + 2*PI

	if (Input.is_action_pressed("move_up") && Input.is_action_pressed("move_right")) || Input.is_action_pressed("move_down") && Input.is_action_pressed("move_left"):
		if !isRotationWithinDeltaForDirections(PI/4, 5*PI/4, rotDelta):
			if (rotation < PI/4) || (rotation > 7*PI/4):
				rotation_dir = 1
			elif (rotation < 3*PI/4):
				rotation_dir = -1
			elif (rotation < 5*PI/4):
				rotation_dir = 1
			elif (rotation < 7*PI/4):
				rotation_dir = -1
		else:
			if Input.is_action_pressed("move_up"):
				velocity = Vector2(1,-1)
			if Input.is_action_pressed("move_down"):
				velocity = Vector2(-1,1)
	elif (Input.is_action_pressed("move_up") && Input.is_action_pressed("move_left")) || Input.is_action_pressed("move_down") && Input.is_action_pressed("move_right"):
		if !isRotationWithinDeltaForDirections(3*PI/4, 7*PI/4, rotDelta):
			if (rotation < PI/4) || (rotation > 7*PI/4):
				rotation_dir = -1
			elif (rotation < 3*PI/4):
				rotation_dir = 1
			elif (rotation < 5*PI/4):
				rotation_dir = -1
			elif (rotation < 7*PI/4):
				rotation_dir = 1
		else:
			if Input.is_action_pressed("move_up"):
				velocity = Vector2(-1,-1)
			if Input.is_action_pressed("move_down"):
				velocity = Vector2(1,1)
	elif Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down"):
		if !isRotationWithinDeltaForDirections(0, PI, rotDelta):
			if (rotation < PI/2):
				rotation_dir = -1
			elif (rotation < PI):
				rotation_dir = 1
			elif (rotation < 3*PI/2):
				rotation_dir = -1
			elif (rotation < 2*PI):
				rotation_dir = 1
		else:
			if Input.is_action_pressed("move_up"):
				velocity = Vector2(0,-1)
			if Input.is_action_pressed("move_down"):
				velocity = Vector2(0,1)
	elif Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
		if !isRotationWithinDeltaForDirections(PI/2, 3*PI/2, rotDelta):
			if (rotation < PI/2):
				rotation_dir = 1
			elif (rotation < PI):
				rotation_dir = -1
			elif (rotation < 3*PI/2):
				rotation_dir = 1
			elif (rotation < 2*PI):
				rotation_dir = -1
		else:
			if Input.is_action_pressed("move_right"):
				velocity = Vector2(1,0)
			if Input.is_action_pressed("move_left"):
				velocity = Vector2(-1,0)

	#print_debug(rotation)
	rotation += rotation_dir * rotDelta
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)

