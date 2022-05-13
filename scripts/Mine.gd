extends Node2D

var Blast = preload("res://scenes/fx/Blast.tscn")

var exploding = false

func setup(position: Vector2):
	self.position = position

func createBlast():
	var blast = Blast.instance()
	blast.position = position
	get_node("/root/Main").add_child(blast)

func destroy():
	call_deferred("createBlast")
	queue_free()

func _on_ExpireTimer_timeout():
	$BlastTimer.start()
	$AnimationPlayer.play("tick")

func _on_BlastTimer_timeout():
	destroy()
