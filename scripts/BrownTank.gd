extends "res://scripts/Tank.gd"

var rotationDirection = 1
var rng
var okToShoot = false


# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()

func _physics_process(delta):
	$Cannon.rotation += delta * rotationDirection
	if(okToShoot):
		var cannonTipPos = position + Vector2(50, 0).rotated($Cannon.rotation)
		var spaceState = get_world_2d().direct_space_state
		#Replace 1000 with bounds for resolution
		var result = spaceState.intersect_ray(cannonTipPos, cannonTipPos + Vector2(1,0).rotated($Cannon.rotation)*1000)
		if (result):
			if(result.collider.is_in_group('player')):
				shoot()
				okToShoot = false
			if(result.collider.is_in_group('walls')):
				var dirVector = Vector2(1,0).rotated($Cannon.rotation)
				var newResult = spaceState.intersect_ray(result.position, result.position + dirVector.bounce(result.normal)*1000)
				if(newResult && newResult.collider.is_in_group('player')):
					shoot()
					okToShoot = false
func _on_ChangeDirectionTimer_timeout():
	rotationDirection = -rotationDirection
	$ChangeDirectionTimer.wait_time = rng.randf_range(0, 5.0)

func _on_ShootingTimer_timeout():
	if (!okToShoot):
		okToShoot = true
	$ShootingTimer.wait_time = rng.randf_range(0, 5.0)
