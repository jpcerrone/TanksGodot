extends KinematicBody2D

export (int) var speed = 40
export (float) var rotation_speed = 5.0

var currentDirection: Vector2
var tankRotation = 0.0

export var maxBullets = 1
export var maxMines = 0

var liveBullets = []
var liveMines = []

const Mine = preload("res://scenes/Mine.tscn")
export var Bullet = preload("res://scenes/Bullet.tscn")
var bulletInstance = Bullet.instance() # A bullet instance to acces some of ithe Bullet class properties
# TODO CHANGE FOR GAST BULLET ON GREENT TANK AND OTHERS
var directions = {
	"UP": Vector2(0,-1),
	"UP_RIGHT": Vector2(1,-1),
	"RIGHT": Vector2(1,0),
	"DOWN_RIGHT": Vector2(1,1),
	"DOWN": Vector2(0,1),
	"DOWN_LEFT": Vector2(-1,1),
	"LEFT": Vector2(-1,0),
	"UP_LEFT": Vector2(-1,-1),
}

func isRotationWithinDeltaForDirection(direction, rotDelta):
	return (tankRotation > direction - rotDelta) && (tankRotation < direction + rotDelta)
	 
func move(delta, direction):
	var rotation_dir = 0
	var rotDelta = rotation_speed * delta

	# Find best direction to rotate towards (direction / -direction)
	var angleToDirection = abs(Vector2(1,0).rotated(tankRotation).angle_to(direction))
	var angleToOppositeDirection = abs(Vector2(1,0).rotated(tankRotation).angle_to(-direction))
	var closerDirection = direction
	if !(min(angleToDirection, angleToOppositeDirection) == angleToDirection):
		closerDirection = -direction	
	
	# Rotate tank towards desired direction if it's not already alligned with it
	# If it is, move towards that direction
	if (!isRotationWithinDeltaForDirection(closerDirection.angle(), rotDelta)):
		if (tankRotation > closerDirection.angle()):
			rotation_dir = -1
		else:
			rotation_dir = 1
		
		# Only one tankRotation is counted
		if (tankRotation > PI):
			tankRotation = -PI + (tankRotation - PI)
		if (tankRotation < -PI):
			tankRotation = PI - (tankRotation + PI)
		
		tankRotation += rotation_dir * rotDelta
		updateRotationAnimation()
	else:
		currentDirection = direction
		# warning-ignore:return_value_discarded
		move_and_slide(direction.normalized() * speed)


func updateRotationAnimation():
	if (tankRotation <= -(directions.LEFT.angle()) + PI/8):
		$AnimationPlayer.current_animation = "horizontal"
	elif (tankRotation <= directions.UP_LEFT.angle() + PI/8) :
		$AnimationPlayer.current_animation = "diagonal_down"
	elif (tankRotation <= directions.UP.angle() + PI/8):
		$AnimationPlayer.current_animation = "vertical"
	elif (tankRotation <= directions.UP_RIGHT.angle() + PI/8):
		$AnimationPlayer.current_animation = "diagonal_up"
	elif (tankRotation <= directions.RIGHT.angle() + PI/8):
		$AnimationPlayer.current_animation = "horizontal"
	elif (tankRotation <= directions.DOWN_RIGHT.angle() + PI/8):
		$AnimationPlayer.current_animation = "diagonal_down"
	elif (tankRotation <= directions.DOWN.angle() + PI/8):
		$AnimationPlayer.current_animation = "vertical"
	elif (tankRotation <= directions.DOWN_LEFT.angle() + PI/8):
		$AnimationPlayer.current_animation = "diagonal_up"
	elif (tankRotation <= directions.LEFT.angle() + PI/8):
		$AnimationPlayer.current_animation = "horizontal"

func rotateCannon(angle):
	$Cannon.rotation = angle

func shoot():
	var bullet = Bullet.instance()
	bullet.setup(getCannonTipPosition(), Vector2(1,0).rotated($Cannon.rotation))
	get_parent().add_child(bullet)
	liveBullets.append(bullet)

func tryToShoot():
	if ($Cannon.get_overlapping_bodies().empty()): # Validate cannon isn't within a wall
		if (Utils.getNumberOfActiveObjects(liveBullets) < maxBullets):
			shoot()
	
func tryToPlantMine():
	if (Utils.getNumberOfActiveObjects(liveMines) < maxMines):
		plantMine()

func plantMine():
	var mine = Mine.instance()
	mine.position = position
	get_parent().add_child(mine)
	liveMines.append(mine)

func getCannonTipPosition():
	return position + $Cannon.position + Vector2(15,0).rotated($Cannon.rotation)

func destroy():
	AudioManager.play(AudioManager.SOUNDS.TANK_DEATH)
	queue_free()

func _exit_tree():
	bulletInstance.queue_free()
