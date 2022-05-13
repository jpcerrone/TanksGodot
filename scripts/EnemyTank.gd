extends "res://scripts/Tank.gd"

var RayCastUtils = preload("res://scripts/RayCastUtils.gd")

var rotationDirection = 1
var cannonRotSpeed = 1.0
var rng
var okToShoot


var DEBUG_LINES = []
var DEBUG_BULL_COLLISION = Vector2(0,0)
var DEBUG_BOUNCE_SPOT = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	okToShoot = false
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var directions = [-1,1]
	rotationDirection = directions[rng.randi_range(0,1)]

func _physics_process(delta):

	$Cannon.rotation += delta * rotationDirection * cannonRotSpeed
	if(okToShoot):
		DEBUG_LINES.clear()
		#Replace 1000 with bounds for resolution
		var result = castBullet(getCannonTipPosition(), Vector2(1,0).rotated($Cannon.rotation))
		update()
		DEBUG_BOUNCE_SPOT = result.position
		#A non normalized result indicates the collision happened inside the collider
		if (result && result.normal.is_normalized()):
			if(result.collider.is_in_group('player')):
				shoot()
				okToShoot = false
			elif(result.collider.is_in_group('walls') && Bullet.instance().maxRebounds > 0):
				var dirVector = Vector2(1,0).rotated($Cannon.rotation)
				# newOrigin will substract bullets size to better allign with bounce
				var newOrigin = result.position - dirVector.normalized()*Bullet.instance().getCollisionShapeExtents().x
				var newResult = castBullet(newOrigin, dirVector.bounce(result.normal))
				if(newResult && newResult.collider.is_in_group('player')):
					shoot()
					okToShoot = false

func _on_ShootingTimer_timeout():
	if (!okToShoot):
		okToShoot = true
	$ShootingTimer.wait_time = rng.randf_range(0, 5.0)
	
func _draw():
#	for i in DEBUG_LINES:
#		draw_line(i[0] - position, i[1] - position, Color(255, 0, 0), 1)
#	draw_circle(DEBUG_BULL_COLLISION - position, 1, Color(255, 255, 0))
#	draw_circle(DEBUG_BOUNCE_SPOT - position, 1, Color(0, 0, 250))
	pass

func castBullet(origin: Vector2, bulletDir):
	return RayCastUtils.castShape(origin, Bullet.instance().getCollisionShape(), bulletDir, get_world_2d().direct_space_state, 1000, [], [self])

