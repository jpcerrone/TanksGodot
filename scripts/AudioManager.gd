extends Node

var num_players = 8
var available = []  # The available players.
var queue = []  # The queue of sounds to play.

enum SOUNDS {
	SMOKE,
}

func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = "master"


func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)

func play(sound):
	queue.append(sound)
			

func _process(delta):
	# Play a queued sound if any players are available.
	if not queue.empty() and not available.empty():
		var sound = queue.pop_front()
		match(sound):
			SOUNDS.SMOKE:
				available[0].stream = load("res://sfx/smoke.wav")
				available[0].volume_db = -10
		available[0].play()
		available.pop_front()
