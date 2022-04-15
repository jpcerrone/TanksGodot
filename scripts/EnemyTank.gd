extends "res://scripts/Tank.gd"

var rotationDirection = 1
var rng
var okToShoot

var DEBUG_LINES = []
var DEBUG_BULL_COLLISION = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	okToShoot = false
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var directions = [-1,1]
	rotationDirection = directions[rng.randi_range(0,1)]

func _physics_process(delta):

	$Cannon.rotation += delta * rotationDirection
	if(okToShoot):
		var cannonTipPos = getCannonTipPosition()
		DEBUG_LINES.clear()
		castBullet(cannonTipPos, Vector2(1,0).rotated($Cannon.rotation))
		var spaceState = get_world_2d().direct_space_state
		#Replace 1000 with bounds for resolution
		var result = spaceState.intersect_ray(cannonTipPos, cannonTipPos + Vector2(1,0).rotated($Cannon.rotation)*1000, [self])
		#A non normalized result indicates the collision happened inside the collider
		if (result && result.normal.is_normalized()):
			if(result.collider.is_in_group('player')):
				shoot()
				okToShoot = false
			elif(result.collider.is_in_group('walls')):

				var dirVector = Vector2(1,0).rotated($Cannon.rotation)
				var newResult = spaceState.intersect_ray(result.position, result.position + dirVector.bounce(result.normal)*1000, [self])

				if(newResult && newResult.collider.is_in_group('player')):
					#DEBUG_LINES.clear()
					castBullet(result.position, dirVector.bounce(result.normal))
					shoot()
					okToShoot = false

func _on_ShootingTimer_timeout():
	if (!okToShoot):
		okToShoot = true
	$ShootingTimer.wait_time = rng.randf_range(0, 5.0)
	
func _draw():
	for i in DEBUG_LINES:
		draw_line(i[0], i[1], Color(255, 0, 0), 1)
	draw_circle(getCannonTipPosition() - position, 1, Color(255, 255, 0))

func castBullet(origin: Vector2, bulletDir):
	var spaceState = get_world_2d().direct_space_state
	var bulletYExtent = Bullet.instance().getCollisionShapeExtents().y
	var rayPositions = [-bulletYExtent, 0, bulletYExtent]
	var raycasts = []

	for p in rayPositions:
		var initPoint = origin + Vector2(0,p).rotated(bulletDir.angle()) - position
		var endPoint = initPoint + bulletDir*1000
		var raycast = spaceState.intersect_ray(initPoint, endPoint, [self])
		DEBUG_LINES.append([initPoint, endPoint])
		raycasts.append(raycast)

#	var closestRayCollisionDistance = 100000
#	var closestRayCollision
#	for ray in raycasts:
#		if (ray.position.distance_squared_to(origin) < closestRayCollisionDistance):
#			closestRayCollisionDistance = ray.position.distance_squared_to(origin)
#			closestRayCollision = ray
#	print_debug(closestRayCollisionDistance)
	
	update()
