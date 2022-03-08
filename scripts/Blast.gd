extends Area2D

var radius = 80


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionPolygon2D.shape.radius = radius

func _draw():
	draw_circle(Vector2(), radius, Color.red)

func _on_ExplosionTimer_timeout():
	queue_free()

func _on_Blast_body_entered(body):
	if body.get_groups().has("destroyable"):
		body.destroy()
