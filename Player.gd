extends KinematicBody2D

export (int) var speed = 150
export (float) var rotation_speed = 4.0
var velocity = Vector2()
var rotation_dir = 0
var tankRotation = 0

const Bullet = preload("res://Bullet.tscn")
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

func _physics_process(delta):
	rotation_dir = 0
	var rotDelta = rotation_speed * delta
	velocity = Vector2(0, 0)
	#Only one tankRotation is counted
	if (tankRotation > 2*PI):
		tankRotation = tankRotation - 2*PI
	if (tankRotation < 0):
		tankRotation = tankRotation + 2*PI

	if (Input.is_action_pressed("move_up") && Input.is_action_pressed("move_right")) || Input.is_action_pressed("move_down") && Input.is_action_pressed("move_left"):
		if !isRotationWithinDeltaForDirections(PI/4, 5*PI/4, rotDelta):
			if (tankRotation < PI/4) || (tankRotation > 7*PI/4):
				rotation_dir = 1
			elif (tankRotation < 3*PI/4):
				rotation_dir = -1
			elif (tankRotation < 5*PI/4):
				rotation_dir = 1
			elif (tankRotation < 7*PI/4):
				rotation_dir = -1
		else:
			if Input.is_action_pressed("move_up"):
				velocity = Vector2(1,-1)
			if Input.is_action_pressed("move_down"):
				velocity = Vector2(-1,1)
	elif (Input.is_action_pressed("move_up") && Input.is_action_pressed("move_left")) || Input.is_action_pressed("move_down") && Input.is_action_pressed("move_right"):
		if !isRotationWithinDeltaForDirections(3*PI/4, 7*PI/4, rotDelta):
			if (tankRotation < PI/4) || (tankRotation > 7*PI/4):
				rotation_dir = -1
			elif (tankRotation < 3*PI/4):
				rotation_dir = 1
			elif (tankRotation < 5*PI/4):
				rotation_dir = -1
			elif (tankRotation < 7*PI/4):
				rotation_dir = 1
		else:
			if Input.is_action_pressed("move_up"):
				velocity = Vector2(-1,-1)
			if Input.is_action_pressed("move_down"):
				velocity = Vector2(1,1)
	elif Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down"):
		if !isRotationWithinDeltaForDirections(0, PI, rotDelta):
			if (tankRotation < PI/2):
				rotation_dir = -1
			elif (tankRotation < PI):
				rotation_dir = 1
			elif (tankRotation < 3*PI/2):
				rotation_dir = -1
			elif (tankRotation < 2*PI):
				rotation_dir = 1
		else:
			if Input.is_action_pressed("move_up"):
				velocity = Vector2(0,-1)
			if Input.is_action_pressed("move_down"):
				velocity = Vector2(0,1)
	elif Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
		if !isRotationWithinDeltaForDirections(PI/2, 3*PI/2, rotDelta):
			if (tankRotation < PI/2):
				rotation_dir = 1
			elif (tankRotation < PI):
				rotation_dir = -1
			elif (tankRotation < 3*PI/2):
				rotation_dir = 1
			elif (tankRotation < 2*PI):
				rotation_dir = -1
		else:
			if Input.is_action_pressed("move_right"):
				velocity = Vector2(1,0)
			if Input.is_action_pressed("move_left"):
				velocity = Vector2(-1,0)

	if (tankRotation <= PI/8) || (tankRotation > 7*PI/4) :
		$Sprite.animation = 'vertical'
	elif (tankRotation <= 3*PI/8):
		$Sprite.animation = 'diagonal_up'
	elif (tankRotation <= 5*PI/8):
		$Sprite.animation = 'horizontal'
	elif (tankRotation <= 7*PI/8):
		$Sprite.animation = 'diagonal_down'
	elif (tankRotation <= PI):
		$Sprite.animation = 'vertical'
	elif (tankRotation <= 10*PI/8):
		$Sprite.animation = 'diagonal_up'
	elif (tankRotation <= 12*PI/8):
		$Sprite.animation = 'horizontal'
	elif (tankRotation <= 14*PI/8):
		$Sprite.animation = 'diagonal_down'
	$Cannon.rotation = get_global_mouse_position().angle_to_point(position)
	#$Cannon.look_at(get_global_mouse_position())
	
	#print_debug($Cannon.rotation)
	var bullet

	if Input.is_action_just_pressed("shoot"):
		bullet = Bullet.instance()
		bullet.setup(position, (get_global_mouse_position() - position).normalized())
		get_node("/root/Main").add_child(bullet)
	tankRotation += rotation_dir * rotDelta
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)

