extends "res://scripts/MovingTank.gd"

func fade_out():
	var tween = Tween.new()
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	add_child(tween)
	tween.start()

func fade_in():
	var tween = Tween.new()
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	add_child(tween)
	tween.start()

func shoot():
	var tween = Tween.new()
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_BOUNCE)
	add_child(tween)
	tween.start()
	.shoot()

func plantMine():
	var tween = Tween.new()
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_BOUNCE)
	add_child(tween)
	tween.start()
	.plantMine()
