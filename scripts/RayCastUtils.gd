extends CanvasItem

var DEBUG_LINES = []
var DEBUG_BULL_COLLISION = Vector2(0,0)
var DEBUG_BOUNCE_SPOT = Vector2(0,0)

func _draw():
	for i in DEBUG_LINES:
		draw_line(i[0], i[1], Color(255, 0, 0), 1)
	draw_circle(DEBUG_BULL_COLLISION, 1, Color(255, 255, 0))
	draw_circle(DEBUG_BOUNCE_SPOT, 1, Color(0, 0, 250))
	pass

func castShape(origin: Vector2, shape: Shape2D, direction: Vector2):
	print_debug("Puto")
	var spaceState = get_world_2d().direct_space_state
	var shapeYExtent = shape.shape.extents.y
	var rayPositions = [-shapeYExtent, 0, shapeYExtent]

	var closestRayCollisionDistance = Global.MAX_INT
	var closestRayCollision
	var closestRayOffest = 0
	for p in rayPositions:
		var initPoint = origin + Vector2(0,p).rotated(direction.angle())
		var endPoint = initPoint + direction*1000
		var raycast = spaceState.intersect_ray(initPoint, endPoint)
		DEBUG_LINES.append([initPoint, endPoint])
		if raycast:
			if (raycast.position.distance_to(origin) < closestRayCollisionDistance):
				closestRayCollisionDistance = abs(raycast.position.distance_to(origin))
				closestRayCollision = raycast
				closestRayOffest = raycast.position.distance_to(initPoint)
	closestRayCollision.position = origin + Vector2(1,0).rotated(direction.angle())*closestRayOffest
	update() #(for debugging)
	return closestRayCollision
