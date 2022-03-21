extends Area2D

func _ready():
	$AnimationPlayer.play("default")

func _draw():
	pass
	#draw_circle(Vector2(), radius, Color.red)

func _on_Blast_body_entered(body):
	if body.get_groups().has("destroyable"):
		body.destroy()


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
