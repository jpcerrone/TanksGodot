extends "res://scripts/Tank.gd"
var rotSpeed = 0.2
var direction
var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	direction = directions.values()[(rng.randi_range(0, directions.size() - 1))]
	pass # Replace with function body.


func _physics_process(delta):
	var selfToP1Vector = Global.p1Position - position
	if ($Cannon.rotation < selfToP1Vector.angle()):
		$Cannon.rotation += delta * rotSpeed
	else:
		$Cannon.rotation -= delta * rotSpeed
		
	self.move(delta, direction)


func _on_ChangeDirTimer_timeout():
	#for i in range [4]:
		#pass
	direction = directions.values()[(rng.randi_range(0, directions.size() - 1))]
	#var spaceState = get_world_2d().direct_space_state
	#Replace 1000 with bounds for resolution
	#var result = spaceState.intersect_ray(position, position + Vector2(1,0).rotated(self.tankRotation)*30)
	#$Sprite.position = Vector2(1,0).rotated(self.tankRotation)*30
	#if (result):
		#print_debug(result)
	#direction = direction + rng.randi_range(-1, 1) % Direction.size()
