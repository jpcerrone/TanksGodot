extends Node
var levels = []
var currentLevelIndex = -1
var currentLevel
# Called when the node enters the scene tree for the first time.
func _ready():
	# Get levels
	var levelsdir = Directory.new()
	levelsdir.open("res://scenes//levels")
	levelsdir.list_dir_begin(true, true)
	var levelStringFormat = levelsdir.get_current_dir() + "/%s"
	var level = levelsdir.get_next() # Getting first file
	level = levelsdir.get_next() # Ignoring "Level.tscn"

	#Level start hack
	#for i in 12: level = levelsdir.get_next() # Ignoring Levels

	while(level != ""):
		var levelString = levelStringFormat % level
		var loadedLevel = load(levelString)
		levels.append(loadedLevel)
		level = levelsdir.get_next()
	
	AudioManager.connect("intro_finished", self, "unpause")
	nextLevel()

func nextLevel():
	currentLevelIndex += 1
	if currentLevelIndex < levels.size():
		if currentLevel: currentLevel.queue_free()
		get_tree().paused = true
		AudioManager.startBGMusic(AudioManager.TRACKS.INTRO)
		_addCurrentLevel()
	else:
		get_tree().quit()

func restartLevel():
	currentLevel.queue_free()
	get_tree().paused = true
	AudioManager.startBGMusic(AudioManager.TRACKS.REPLAY)
	_addCurrentLevel()


func _addCurrentLevel():
	currentLevel = levels[currentLevelIndex].instance()
	currentLevel.connect("enemies_killed", self, 'nextLevel')
	currentLevel.connect("player_died", self, 'restartLevel')
	add_child(currentLevel)

func unpause():
	get_tree().paused = false

