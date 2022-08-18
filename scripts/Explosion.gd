extends Node2D

export var withSound = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("default")
	if (withSound):
		AudioManager.play(AudioManager.SOUNDS.SMOKE)

func _on_AnimatedSprite_animation_finished():
	queue_free()
