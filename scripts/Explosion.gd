extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("default")
	AudioManager.play(AudioManager.SOUNDS.SMOKE)

func _on_AnimatedSprite_animation_finished():
	queue_free()
