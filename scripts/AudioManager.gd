extends Node

var num_players = 8
var available = []  # The available players.
var queue = []  # The queue of sounds to play.

enum SOUNDS {
	SMOKE,
	SHOT,
	BOUNCE,
	TANK_MOVE,
	MINE,
	BLAST,
	TANK_DEATH,
	BULLET_SHOT,
	MINE_CANT,
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
			

func _process(_delta):
	# Play a queued sound if any players are available.
	if not queue.empty() and not available.empty():
		var sound = queue.pop_front()
		match(sound):
			SOUNDS.SMOKE:
				available[0].stream = load("res://sfx/smoke.wav")
				available[0].volume_db = -10
			SOUNDS.SHOT:
				available[0].stream = load("res://sfx/shot.wav")
				available[0].volume_db = -10
			SOUNDS.BOUNCE:
				available[0].stream = load("res://sfx/bounce.wav")
				available[0].volume_db = -5
			SOUNDS.TANK_MOVE:
				available[0].stream = load("res://sfx/tank_move.wav")
				available[0].volume_db = -10
			SOUNDS.MINE:
				available[0].stream = load("res://sfx/mine.wav")
				available[0].volume_db = -10
			SOUNDS.BLAST:
				available[0].stream = load("res://sfx/bomb.wav")
				available[0].stream.loop_mode = 0
				available[0].volume_db = -15
			SOUNDS.TANK_DEATH:
				available[0].stream = load("res://sfx/tank_death.wav")
				available[0].stream.loop_mode = 0
				available[0].volume_db = -15
			SOUNDS.BULLET_SHOT:
				available[0].stream = load("res://sfx/bullet_shot.wav")
				available[0].stream.loop_mode = 0
				available[0].volume_db = -15
			SOUNDS.MINE_CANT:
				available[0].stream = load("res://sfx/mine_cant.wav")
				available[0].stream.loop_mode = 0
				available[0].volume_db = -5
		available[0].play()
		available.pop_front()
