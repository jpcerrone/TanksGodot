extends KinematicBody2D

var Explosion = preload("res://scenes/fx/Explosion.tscn")
var Ricochet = preload("res://scenes/fx/Ricochet.tscn")
var Smoke = preload("res://scenes/fx/Smoke.tscn")

export var speed = 150.0
export var maxRebounds = 1
var currentRebounds
var velocity = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play(AudioManager.SOUNDS.SHOT)

func setup(initialPosition: Vector2, initialVelocity: Vector2):
	position = initialPosition
	self.velocity = initialVelocity.normalized()
	currentRebounds = 0
	self.rotation = initialVelocity.angle()

func destroy():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(velocity*delta*speed)
	if (collision):
		if (collision.collider.get_groups().has("destroyable")):
			if (!collision.collider.get_groups().has("no_explosion")):
				createExplosion(collision.collider.position)
			collision.collider.destroy()
			AudioManager.play(AudioManager.SOUNDS.BULLET_SHOT)
			self.destroy()
		else:
			if (currentRebounds >= maxRebounds):
				#Smoke
				var smoke = Smoke.instance()
				smoke.position = position
				get_parent().add_child(smoke)
				queue_free()
			else: 
				#position = collision.position + velocity.bounce(collision.normal)*10
				#print_debug("preVel",velocity)
				velocity = velocity.bounce(collision.normal)
				#print_debug("postvel",velocity)
				#print_debug("postPos",position)
				self.rotation = velocity.angle()
				currentRebounds += 1;
				
				#Ricochet
				var ricochet = Ricochet.instance()
				ricochet.position = position - collision.normal*$CollisionShape2D.shape.extents.x
				ricochet.rotate(collision.normal.angle())
				get_parent().add_child(ricochet)
				AudioManager.play(AudioManager.SOUNDS.BOUNCE)
				update()
func _draw():
	draw_circle(Vector2(0,0), 1, Color(255, 255, 0))


func createExplosion(colliderPosition):
	var explosion = Explosion.instance()
	explosion.position = colliderPosition
	get_parent().add_child(explosion)

func getCollisionShapeExtents():
	return $CollisionShape2D.shape.extents
	
func getCollisionShape() -> Shape:
	return $CollisionShape2D.shape
