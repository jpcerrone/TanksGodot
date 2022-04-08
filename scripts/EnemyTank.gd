extends "res://scripts/Tank.gd"

var rotationDirection = 1
var rng
var okToShoot

var DEBUG_RAYCAST_VECTORS = [Vector2(0,0), Vector2(0,0), Vector2(0,0)]
var DEBUG_RAYCAST_OFFSET = [Vector2(0,0), Vector2(0,0), Vector2(0,0)]
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
		castBullet()
		var cannonTipPos = getCannonTipPosition()
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
					shoot()
					okToShoot = false

func _on_ShootingTimer_timeout():
	if (!okToShoot):
		okToShoot = true
	$ShootingTimer.wait_time = rng.randf_range(0, 5.0)
	
func _draw():
	draw_line(getCannonTipPosition() + Vector2(1,0).rotated(DEBUG_RAYCAST_OFFSET[0].angle()) - position, DEBUG_RAYCAST_VECTORS[0] - position, Color(255, 0, 0), 1)
	draw_line(getCannonTipPosition() + DEBUG_RAYCAST_OFFSET[1] - position, DEBUG_RAYCAST_VECTORS[1] - position, Color(255, 0, 0), 1)
	draw_line(getCannonTipPosition() + Vector2(1,0).rotated(DEBUG_RAYCAST_OFFSET[2].angle()) - position, DEBUG_RAYCAST_VECTORS[2] - position, Color(255, 0, 0), 1)
			
func castBullet():
	var spaceState = get_world_2d().direct_space_state
	var cannonTipPos = getCannonTipPosition()
	var bulletYExtent = Bullet.instance().getCollisionShapeExtents().y
	var rayPositions = [-bulletYExtent, 0, bulletYExtent]
	var raycasts = []
	DEBUG_RAYCAST_OFFSET[0] = Vector2(0,2.0)
	DEBUG_RAYCAST_VECTORS[0] = cannonTipPos + Vector2(1,0).rotated(DEBUG_RAYCAST_OFFSET[0].angle()) + (Vector2(1,0)).rotated($Cannon.rotation)*1000
	DEBUG_RAYCAST_VECTORS[1] = cannonTipPos + Vector2(1,0).rotated($Cannon.rotation)*1000
	DEBUG_RAYCAST_OFFSET[1] = Vector2(0,0)
	DEBUG_RAYCAST_OFFSET[2] = Vector2(0,-2.0)
	DEBUG_RAYCAST_VECTORS[2] = cannonTipPos + Vector2(1,0).rotated(DEBUG_RAYCAST_OFFSET[2].angle())+ Vector2(1,0).rotated($Cannon.rotation)*1000
	update()
	for p in rayPositions:
		raycasts.append(spaceState.intersect_ray(cannonTipPos + Vector2(0,p), cannonTipPos + Vector2(1,p).rotated($Cannon.rotation)*1000, [self]))

