extends KinematicBody2D



export (int) var speed = 100
export (float) var rotation_speed = 1.5
var velocity = Vector2()
var rotation_dir = 0
var directions = [0, PI/4, PI/2, PI/2, 3*PI/4]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	rotation_dir = 0
	var rotDiff = rotation_speed * delta
	velocity = Vector2(0, 0)
	#Only one rotation is counted
	if (rotation > 2*PI):
		rotation = rotation - 2*PI
	if (rotation < 0):
		rotation = rotation + 2*PI

	if (Input.is_action_pressed("move_up") && Input.is_action_pressed("move_right")) || Input.is_action_pressed("move_down") && Input.is_action_pressed("move_left"):
		var isWithinOriginalClamp = (rotation > PI/4 - rotDiff) && (rotation < PI/4 + rotDiff)
		if (isWithinOriginalClamp):
			rotation = PI/4
		var isWithinAlternateClamp = (rotation > 5*PI/4 - rotDiff) && (rotation < 5*PI/4 + rotDiff)
		if (isWithinAlternateClamp):
			rotation = 5*PI/4
		if !isWithinOriginalClamp && !isWithinAlternateClamp:
			if (rotation < PI/4) || (rotation > 7*PI/4):
				rotation_dir = 1
			elif (rotation < 3*PI/4):
				rotation_dir = -1
			elif (rotation < 5*PI/4):
				rotation_dir = 1
			elif (rotation < 7*PI/4):
				rotation_dir = -1
				
	elif (Input.is_action_pressed("move_up") && Input.is_action_pressed("move_left")) || Input.is_action_pressed("move_down") && Input.is_action_pressed("move_right"):
		var isWithinOriginalClamp = (rotation > 3*PI/4 - rotDiff) && (rotation < 3*PI/4 + rotDiff)
		if (isWithinOriginalClamp):
			rotation = 3*PI/4
		var isWithinAlternateClamp = (rotation > 7*PI/4 - rotDiff) && (rotation < 7*PI/4 + rotDiff)
		if (isWithinAlternateClamp):
			rotation = 7*PI/4
		if !isWithinOriginalClamp && !isWithinAlternateClamp:
			if (rotation < PI/4) || (rotation > 7*PI/4):
				rotation_dir = -1
			elif (rotation < 3*PI/4):
				rotation_dir = 1
			elif (rotation < 5*PI/4):
				rotation_dir = -1
			elif (rotation < 7*PI/4):
				rotation_dir = 1

	elif Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down"):
		var isWithinOriginalClamp = (rotation > 0 - rotDiff) && (rotation < 0 + rotDiff)
		if (isWithinOriginalClamp):
			rotation = 0
		var isWithinAlternateClamp = (rotation > PI - rotDiff) && (rotation < PI + rotDiff)
		if (isWithinAlternateClamp):
			rotation = PI
		if !isWithinOriginalClamp && !isWithinAlternateClamp:
			if (rotation < PI/2):
				rotation_dir = -1
			elif (rotation < PI):
				rotation_dir = 1
			elif (rotation < 3*PI/2):
				rotation_dir = -1
			elif (rotation < 2*PI):
				rotation_dir = 1
	elif Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
		var isWithinOriginalClamp = (rotation > PI/2 - rotDiff) && (rotation < PI/2 + rotDiff)
		if (isWithinOriginalClamp):
			rotation = PI/2
		var isWithinAlternateClamp = (rotation > 3*PI/2 - rotDiff) && (rotation < 3*PI/2 + rotDiff)
		if (isWithinAlternateClamp):
			rotation = 3*PI/2
		if !isWithinOriginalClamp && !isWithinAlternateClamp:
			if (rotation < PI/2):
				rotation_dir = 1
			elif (rotation < PI):
				rotation_dir = -1
			elif (rotation < 3*PI/2):
				rotation_dir = 1
			elif (rotation < 2*PI):
				rotation_dir = -1

	#print_debug(rotation)
	rotation += rotation_dir * rotDiff
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)

