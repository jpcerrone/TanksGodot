extends KinematicBody2D


const speed = 250.0
const maxRebounds = 1
var currentRebounds
var velocity = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup(initialPosition: Vector2, initialVelocity: Vector2):
	position = initialPosition
	self.velocity = initialVelocity
	currentRebounds = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(velocity*delta*speed)
	if (collision):
		if (collision.collider.get_groups().has("bulletBouncers")):
			velocity = velocity.bounce(collision.normal)
			currentRebounds += 1;
			if (currentRebounds > maxRebounds):
				Global.currentBullets -= 1
				queue_free()
		else:
			Global.currentBullets -= 1
			queue_free()
