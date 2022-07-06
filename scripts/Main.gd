extends Node
var level1 = preload("res://scenes/levels/Level1.tscn")
var level2 = preload("res://scenes/levels/Level2.tscn")
var level4 = preload("res://scenes/levels/Level4.tscn")
var levels = [level4, level1, level2]
var currentLevelIndex = -1
var currentLevel
# Called when the node enters the scene tree for the first time.
func _ready():
	nextLevel()

func nextLevel():
	currentLevelIndex += 1
	if currentLevelIndex < levels.size():
		if currentLevel: currentLevel.queue_free()
		_addCurrentLevel()
	else:
		get_tree().quit()

func restartLevel():
	currentLevel.queue_free()
	_addCurrentLevel()

func _addCurrentLevel():
	currentLevel = levels[currentLevelIndex].instance()
	currentLevel.connect("enemies_killed", self, 'nextLevel')
	currentLevel.connect("player_died", self, 'restartLevel')
	add_child(currentLevel)
	AudioManager.startBGMusic(AudioManager.TRACKS.MAIN)

