extends "res://scripts/Tank.gd"

var rotationDirection = 1
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

	$Cannon.rotation += delta * rotationDirection
	if(okToShoot):
		DEBUG_LINES.clear()
		
		var spaceState = get_world_2d().direct_space_state
		#Replace 1000 with bounds for resolution
		#var result = spaceState.intersect_ray(cannonTipPos, cannonTipPos + Vector2(1,0).rotated($Cannon.rotation)*1000, [self])
		var result = castBullet(getCannonTipPosition(), Vector2(1,0).rotated($Cannon.rotation))
		DEBUG_BOUNCE_SPOT = result.position
		#A non normalized result indicates the collision happened inside the collider
		if (result && result.normal.is_normalized()):
			if(result.collider.is_in_group('player')):
				shoot()
				okToShoot = false
			elif(result.collider.is_in_group('walls')):
				var dirVector = Vector2(1,0).rotated($Cannon.rotation)
				# newOrigin will substract bullets size to better allign with bounce
				var newOrigin = result.position - dirVector.normalized()*Bullet.instance().getCollisionShapeExtents().x
				#DEBUG_BULL_COLLISION = newOrigin
				var newResult = castBullet(newOrigin, dirVector.bounce(result.normal))
				#var newResult = spaceState.intersect_ray(newOrigin, newOrigin + dirVector.bounce(result.normal)*1000, [self])

				if(newResult && newResult.collider.is_in_group('player')):
					#DEBUG_LINES.clear()

					shoot()
					okToShoot = false

func _on_ShootingTimer_timeout():
	if (!okToShoot):
		okToShoot = true
	$ShootingTimer.wait_time = rng.randf_range(0, 5.0)
	
func _draw():
	for i in DEBUG_LINES:
		draw_line(i[0], i[1], Color(255, 0, 0), 1)
	draw_circle(DEBUG_BULL_COLLISION - position, 1, Color(255, 255, 0))
	draw_circle(DEBUG_BOUNCE_SPOT - position, 1, Color(0, 0, 250))

func castBullet(origin: Vector2, bulletDir):
	var spaceState = get_world_2d().direct_space_state
	var bulletYExtent = Bullet.instance().getCollisionShapeExtents().y
	var rayPositions = [-bulletYExtent, 0, bulletYExtent]

	var closestRayCollisionDistance = Global.MAX_INT
	var closestRayCollision
	var closestRayOffest = 0
	for p in rayPositions:
		var initPoint = origin + Vector2(0,p).rotated(bulletDir.angle()) - position
		var endPoint = initPoint + bulletDir*1000
		var raycast = spaceState.intersect_ray(initPoint + position, endPoint + position)
		DEBUG_LINES.append([initPoint, endPoint])
		if raycast:
			if (raycast.position.distance_squared_to(origin) < closestRayCollisionDistance):
				closestRayCollisionDistance = abs(raycast.position.distance_to(origin))
				closestRayCollision = raycast
				closestRayOffest = raycast.position.distance_to(initPoint+position)
#	for i in range (raycasts.size()):
#		if (raycasts[i].position.distance_squared_to(origin) < closestRayCollisionDistance):
#			closestRayCollisionDistance = abs(raycasts[i].position.distance_to(origin))
#			closestRayCollision = raycasts[i]
#			closestRayOffest = raycasts[i].position - 
	#for ray in raycasts:
#		if (ray.position.distance_squared_to(origin) < closestRayCollisionDistance):
#			closestRayCollisionDistance = abs(ray.position.distance_to(origin))
#			closestRayCollision = ray
#			closestRayOffest = ray.position
	#print_debug(closestRayCollisionDistance)
	#closestRayCollision.position += closestRayOffest
	closestRayCollision.position = origin + Vector2(1,0).rotated(bulletDir.angle())*closestRayOffest
	update()
	#print_debug("RAY",closestRayOffest)
	return closestRayCollision

