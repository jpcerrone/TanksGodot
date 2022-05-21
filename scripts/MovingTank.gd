extends "res://scripts/EnemyTank.gd"


var rotSpeed = 0.4
var direction

#var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	direction = directions.values()[(rng.randi_range(0, directions.size() - 1))]
	$ChangeDirTimer.wait_time = rng.randf_range(1.5, 3.0)
	cannonRotSpeed = 0.3
	if (maxMines > 0):
		$MineTimer.wait_time = rng.randf_range(2.0, 4.0)
		$MineTimer.start()
func _physics_process(delta):
	var selfToP1Vector = Global.p1Position - position
	var angleToPlayer = Vector2(1,0).rotated($Cannon.rotation).angle_to(selfToP1Vector)
	if (angleToPlayer > 0):
		rotationDirection = 1
	else:
		rotationDirection = -1
		
	self.move(delta, direction)
	
func _draw():
	#for i in DEBUG_LINES:
		#draw_line(i[0] - position, i[1] - position, Color(255, 0, 0), 1)
	pass
func _on_ChangeDirTimer_timeout():
	var spaceState = get_world_2d().direct_space_state
	#Summing the array size to be able to get the currentDirectionIndex-1 in case of using the fist direction
	var currentDirectionIndex = directions.values().find(currentDirection) + directions.values().size()
	var posibleDirections = []
	DEBUG_LINES.clear()
	for i in range(currentDirectionIndex-1, currentDirectionIndex+2):
		#var result = spaceState.intersect_ray(position, position + directions.values()[i%directions.size()]*40, [self])
		#DEBUG_LINES.clear()
		var result = RayCastUtils.castShape(position, $CollisionShape2D.shape, directions.values()[i%directions.size()], spaceState, 40, DEBUG_LINES, self)

		if (!result):
			posibleDirections.append(directions.values()[i%directions.size()])
	update()
	if (posibleDirections != []):
		direction = posibleDirections[(rng.randi_range(0, posibleDirections.size()-1))]
	$ChangeDirTimer.wait_time = rng.randf_range(1.5, 3.0)


func _on_CollisionCheckTimer_timeout():
	var spaceState = get_world_2d().direct_space_state
	#Summing the array size to be able to get the currentDirectionIndex-1 in case of using the fist direction
	var currentDirectionIndex = directions.values().find(currentDirection) + directions.values().size()
	#var result = spaceState.intersect_ray(position, position + directions.values()[currentDirectionIndex%directions.size()]*20, [self])
	#var result = RayCastUtils.castShape(position, $CollisionShape2D.shape, directions.values()[currentDirectionIndex%directions.size()], spaceState, 20, [], self)
	var result = RayCastUtils.castShape(position, $CollisionShape2D.shape, directions.values()[currentDirectionIndex%directions.size()], spaceState, 20, DEBUG_LINES, self)
	update()
	if result:
		var posibleDirections = []
		for i in range(currentDirectionIndex-2, currentDirectionIndex+3):
			#var result2 = spaceState.intersect_ray(position, position + directions.values()[i%directions.size()]*40, [self])
			var result2 = RayCastUtils.castShape(position, $CollisionShape2D.shape, directions.values()[i%directions.size()], spaceState, 20, DEBUG_LINES, self)
			if (!result2):
				posibleDirections.append(directions.values()[i%directions.size()])
		#if all 3 directions result in a collision, consider 2 more directions
		if (posibleDirections.empty()):
			var alternativeDirecttions = []
			alternativeDirecttions.append(directions.values()[(currentDirectionIndex-3)%directions.size()])
			alternativeDirecttions.append(directions.values()[(currentDirectionIndex+3)%directions.size()])
			for i in alternativeDirecttions:
				var result2 = spaceState.intersect_ray(position, position + i*40, [self])
				if (!result2):
					posibleDirections.append(i)
		if (posibleDirections != []):
			direction = posibleDirections[(rng.randi_range(0, posibleDirections.size()-1))]


func _on_MineTimer_timeout():
	plantMine()
	$MineTimer.wait_time = rng.randf_range(2.0, 4.0)
