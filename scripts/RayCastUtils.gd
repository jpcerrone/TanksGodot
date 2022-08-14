extends CanvasItem
const NUMBER_OF_RAYS = 9

static func castShape(origin: Vector2, shape, direction: Vector2, spaceState, rayLength, debugLines: Array, exclude: Array, colmask = 0b11111111):
	
	# Creates an array to store each of the rays base y positions for the shape, based on the NUMBER_OF_RAYS we want
	var shapeYExtent = shape.extents.y
	var rayStep = 2*shapeYExtent/(NUMBER_OF_RAYS - 1)
	var rayPositions = []
	for i in range(NUMBER_OF_RAYS):
		rayPositions.append(-shapeYExtent + i*rayStep)	

	var closestRayCollisionDistance = Global.MAX_INT
	var closestRayCollision
	var closestRayOffest = 0
	for p in rayPositions:
		var initPoint = origin + Vector2(0,p).rotated(direction.angle())
		var endPoint = initPoint + direction*rayLength
		var rayCollision = spaceState.intersect_ray(initPoint, endPoint, exclude, colmask)
		if debugLines != null: debugLines.append([initPoint, endPoint])
		if rayCollision:
			if (rayCollision.position.distance_to(origin) < closestRayCollisionDistance):
				closestRayCollisionDistance = abs(rayCollision.position.distance_to(origin))
				closestRayCollision = rayCollision
				closestRayOffest = rayCollision.position.distance_to(initPoint)
	if closestRayCollision:
		closestRayCollision.position = origin + Vector2(1,0).rotated(direction.angle())*closestRayOffest 
	return closestRayCollision
