extends "res://scripts/StationaryTank.gd"

func _physics_process(delta):
	$Cannon.rotation += delta * rotationDirection * cannonRotSpeed
	if(okToShoot):
		if Debug.SHOW_BULLET_RAYCASTS: BULLET_RAYCAST_LIST.clear()
		#Replace 1000 with bounds for resolution
		var result = castBullet(getCannonTipPosition(), Vector2(1,0).rotated($Cannon.rotation))
		if Debug.SHOW_BULLET_RAYCASTS: DEBUG_BOUNCE_SPOT = result.position
		#A non normalized result indicates the collision happened inside the collider
		if (result && result.normal.is_normalized() && result.collider.is_in_group('walls')):
				var dirVector = Vector2(1,0).rotated($Cannon.rotation)
				# newOrigin will substract bullets size to better allign with bounce
				var newOrigin = result.position - dirVector.normalized()*bulletInstance.getCollisionShapeExtents().x
				var newResult = castBullet(newOrigin, dirVector.bounce(result.normal))
				if(newResult && newResult.normal.is_normalized() && newResult.collider.is_in_group('walls')):
					var secondDirVector = dirVector.bounce(result.normal)
					var secondOrigin = newResult.position - secondDirVector.normalized()*bulletInstance.getCollisionShapeExtents().x
					var secondResult = castBullet(secondOrigin, secondDirVector.bounce(newResult.normal))
					if(secondResult && secondResult.collider.is_in_group('player')):
						tryToShoot()
						okToShoot = false
		if Debug.SHOW_BULLET_RAYCASTS: update()
