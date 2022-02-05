extends KinematicBody2D


var speed = 250.0
var velocity = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(initialPosition: Vector2, initialVelocity: Vector2):
	position = initialPosition
	self.velocity = initialVelocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_collide(velocity*delta*speed)
	pass
