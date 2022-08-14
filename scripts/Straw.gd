extends StaticBody2D

export var vertical = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if !vertical:
		$AnimationPlayer.play("default_h")
	else:
		$AnimatedSprite.animation = "default_v" # To get the default vertical animation before the level begins (Freeze before start makes this necessary)
		$AnimationPlayer.play("default_v")

func blast():
	if !vertical:
		$AnimationPlayer.play("blow_h")
	else:
		$AnimationPlayer.play("blow_v")

func _on_AnimatedSprite_animation_finished():
	queue_free()
