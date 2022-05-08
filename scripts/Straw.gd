extends StaticBody2D

export var vertical = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if !vertical:
		$AnimationPlayer.play("default_h")
	else:
		$AnimationPlayer.play("default_v")

func blast():
	if !vertical:
		$AnimationPlayer.play("blow_h")
	else:
		$AnimationPlayer.play("blow_v")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimatedSprite_animation_finished():
	queue_free()
