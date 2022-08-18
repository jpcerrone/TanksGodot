extends KinematicBody2D

var Explosion = preload("res://scenes/fx/Explosion.tscn")
var Ricochet = preload("res://scenes/fx/Ricochet.tscn")
var Smoke = preload("res://scenes/fx/Smoke.tscn")

export var speed = 150.0
export var maxRebounds = 1
var currentRebounds
var velocity = Vector2()

class_name Bullet

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
		else: # Collision with walls
			if (currentRebounds >= maxRebounds):
				instanceSmoke(true)
				queue_free()
			else: 
				velocity = velocity.bounce(collision.normal)
				self.rotation = velocity.angle()
				currentRebounds += 1;
				
				# Ricochet
				var ricochet = Ricochet.instance()
				ricochet.position = position - collision.normal*$CollisionShape2D.shape.extents.x
				ricochet.rotate(collision.normal.angle())
				get_parent().add_child(ricochet)
				AudioManager.play(AudioManager.SOUNDS.BOUNCE)

func createExplosion(colliderPosition):
	var explosion = Explosion.instance()
	explosion.position = colliderPosition
	get_parent().add_child(explosion)

func getCollisionShapeExtents():
	return $CollisionShape2D.shape.extents
	
func getCollisionShape() -> Shape:
	return $CollisionShape2D.shape

func instanceSmoke(sound):
	var smoke = Smoke.instance()
	smoke.position = position
	smoke.withSound = sound
	get_parent().add_child(smoke)
