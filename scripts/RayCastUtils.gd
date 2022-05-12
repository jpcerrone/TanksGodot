extends CanvasItem

static func castShape(origin: Vector2, shape, direction: Vector2, spaceState, rayLength, debugLines, objRef):
	
	var shapeYExtent = shape.extents.y
	var rayPositions = [-shapeYExtent, 0, shapeYExtent]

	var closestRayCollisionDistance = Global.MAX_INT
	var closestRayCollision
	var closestRayOffest = 0
	for p in rayPositions:
		var initPoint = origin + Vector2(0,p).rotated(direction.angle())
		var endPoint = initPoint + direction*rayLength
		var raycast = spaceState.intersect_ray(initPoint, endPoint, [objRef])
		debugLines.append([initPoint, endPoint])
		if raycast:
			if (raycast.position.distance_to(origin) < closestRayCollisionDistance):
				closestRayCollisionDistance = abs(raycast.position.distance_to(origin))
				closestRayCollision = raycast
				closestRayOffest = raycast.position.distance_to(initPoint)
	if closestRayCollision:
		closestRayCollision.position = origin + Vector2(1,0).rotated(direction.angle())*closestRayOffest
	return closestRayCollision
