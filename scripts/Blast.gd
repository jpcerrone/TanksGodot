extends Area2D

func _draw():
	pass
	#draw_circle(Vector2(), radius, Color.red)

func _on_ExplosionTimer_timeout():
	queue_free()

func _on_Blast_body_entered(body):
	if body.get_groups().has("destroyable"):
		body.destroy()
