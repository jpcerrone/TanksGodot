extends Area2D

func _ready():
	$AnimationPlayer.play("default")
	AudioManager.play(AudioManager.SOUNDS.BLAST)

func _on_Blast_body_entered(body):
	if body.get_groups().has("destroyable"):
		body.destroy()
	# Nodes that can be blasted play an animation before getting destroyed
	if body.get_groups().has("can_be_blasted"):
		body.blast()

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
