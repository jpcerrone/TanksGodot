extends "res://scripts/Tank.gd"
var rotSpeed = 0.4
var direction
var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	direction = directions.values()[(rng.randi_range(0, directions.size() - 1))]
	$ChangeDirTimer.wait_time = rng.randf_range(1.5, 3.0)


func _physics_process(delta):
	var selfToP1Vector = Global.p1Position - position
	if ($Cannon.rotation < selfToP1Vector.angle()):
		$Cannon.rotation += delta * rotSpeed
	else:
		$Cannon.rotation -= delta * rotSpeed
		
	self.move(delta, direction)


func _on_ChangeDirTimer_timeout():
	var spaceState = get_world_2d().direct_space_state
	#Summing the array size to be able to get the currentDirectionIndex-1 in case of using the fist direction
	var currentDirectionIndex = directions.values().find(currentDirection) + directions.values().size()
	var posibleDirections = []
	for i in range(currentDirectionIndex-1, currentDirectionIndex+2):
		var result = spaceState.intersect_ray(position, position + directions.values()[i%directions.size()]*40, [self])
		#$Sprite.position = directions.values()[i%directions.size()]*40
		if (!result):
			posibleDirections.append(directions.values()[i%directions.size()])

	if (posibleDirections != []):
		direction = posibleDirections[(rng.randi_range(0, posibleDirections.size()-1))]
	$ChangeDirTimer.wait_time = rng.randf_range(1.5, 3.0)


func _on_CollisionCheckTimer_timeout():
	var spaceState = get_world_2d().direct_space_state
	#Summing the array size to be able to get the currentDirectionIndex-1 in case of using the fist direction
	var currentDirectionIndex = directions.values().find(currentDirection) + directions.values().size()
	var result = spaceState.intersect_ray(position, position + directions.values()[currentDirectionIndex%directions.size()]*20, [self])

	if result:
		var posibleDirections = []
		for i in range(currentDirectionIndex-2, currentDirectionIndex+3):
			var result2 = spaceState.intersect_ray(position, position + directions.values()[i%directions.size()]*40, [self])

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
