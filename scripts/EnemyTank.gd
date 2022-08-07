extends "res://scripts/Tank.gd"

var RayCastUtils = preload("res://scripts/RayCastUtils.gd")

var rotationDirection = 1
var cannonRotSpeed = 1.5
export var bulletsPerSecond = 0.5
var rng = RandomNumberGenerator.new()
var fireRate
var okToShoot

var DEBUG_LINES = []
var DEBUG_BULL_COLLISION = Vector2(0,0)
var DEBUG_BOUNCE_SPOT = Vector2(0,0)
# Called when the node enters the scene tree for the first time.

func _ready():
	fireRate = rng.randf_range((1/bulletsPerSecond) -(1/bulletsPerSecond)/5, (1/bulletsPerSecond) -(1/bulletsPerSecond)/5)
	okToShoot = false
	rng.randomize()
	$ShootingTimer.wait_time = fireRate

	# Point cannon towards player, but add a +-PI/4 offset so that we arent pointing directly towards him but rather close to him instead
	var orientation = [-1,1]
	var vecToPlayer = position.direction_to((Global.p1Position))
	rotationDirection = orientation[rng.randi_range(0,1)]
	$Cannon.rotation = vecToPlayer.rotated(rotationDirection*PI/4).angle()

func _physics_process(delta):

	$Cannon.rotation += delta * rotationDirection * cannonRotSpeed
	if(okToShoot):
		DEBUG_LINES.clear()
		#Replace 1000 with bounds for resolution
		var result = castBullet(getCannonTipPosition(), Vector2(1,0).rotated($Cannon.rotation))
		update()
		#A non normalized result indicates the collision happened inside the collider
		if (result && result.normal.is_normalized()):
			DEBUG_BOUNCE_SPOT = result.position
			if(result.collider.is_in_group('player')):
				tryToShoot()
				okToShoot = false
			elif(result.collider.is_in_group('walls') && bulletInstance.maxRebounds == 1):
				var dirVector = Vector2(1,0).rotated($Cannon.rotation)
				# newOrigin will substract bullets size to better allign with bounce
				var newOrigin = result.position - dirVector.normalized()*bulletInstance.getCollisionShapeExtents().x
				var newResult = castBullet(newOrigin, dirVector.bounce(result.normal))
				if(newResult && newResult.collider.is_in_group('player')):
					tryToShoot()
					okToShoot = false

func _on_ShootingTimer_timeout():
	if (!okToShoot):
		okToShoot = true
	$ShootingTimer.wait_time = fireRate
	
func _draw():
	#for i in DEBUG_LINES:
		#draw_line(i[0] - position, i[1] - position, Color(255, 0, 0), 1)
		#draw_circle(DEBUG_BULL_COLLISION - position, 1, Color(255, 255, 0))
		#draw_circle(DEBUG_BOUNCE_SPOT - position, 1, Color(0, 0, 250))
	pass

func castBullet(origin: Vector2, bulletDir):
	var blastMask = 0b01111 # Blast detection occurs on layer 3 (value 4 0b0100), we want to ignore them when casting bullets, so we zero that bit
	return RayCastUtils.castShape(origin, bulletInstance.getCollisionShape(), bulletDir, get_world_2d().direct_space_state, 1000, [], [self], blastMask)

