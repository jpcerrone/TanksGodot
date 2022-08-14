extends "res://scripts/StationaryTank.gd"

func _physics_process(delta):
	$Cannon.rotation += delta * rotationDirection * cannonRotSpeed
	if(okToShoot):
		if Debug.SHOW_BULLET_RAYCASTS: BULLET_RAYCAST_LIST.clear()
		var firstRaycastResult = castBullet(getCannonTipPosition(), Vector2(1,0).rotated($Cannon.rotation))
		if Debug.SHOW_BULLET_RAYCASTS: DEBUG_BOUNCE_SPOT = firstRaycastResult.position
		#A non normalized result indicates the collision happened inside the collider, so we ignore those
		if (firstRaycastResult && firstRaycastResult.normal.is_normalized() && firstRaycastResult.collider.is_in_group('walls')):
				var newDirVector = Vector2(1,0).rotated($Cannon.rotation)
				# newOrigin will substract bullets size to better allign with bounce
				var newOrigin = firstRaycastResult.position - newDirVector.normalized()*bulletInstance.getCollisionShapeExtents().x
				var secondRaycastResult = castBullet(newOrigin, newDirVector.bounce(firstRaycastResult.normal))
				if(secondRaycastResult && secondRaycastResult.normal.is_normalized() && secondRaycastResult.collider.is_in_group('walls')):
					var secondDirVector = newDirVector.bounce(firstRaycastResult.normal)
					var secondOrigin = secondRaycastResult.position - secondDirVector.normalized()*bulletInstance.getCollisionShapeExtents().x
					var thirdRaycastResult = castBullet(secondOrigin, secondDirVector.bounce(secondRaycastResult.normal))
					if(thirdRaycastResult && thirdRaycastResult.collider.is_in_group('player')):
						tryToShoot()
						okToShoot = false
		if Debug.SHOW_BULLET_RAYCASTS: update()
