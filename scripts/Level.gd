extends TileMap
const Straw = preload("res://scenes/Straw.tscn")

var enemies

signal player_died
signal enemies_killed

# Called when the node enters the scene tree for the first time.
func _ready():
	enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		e.connect("tree_exiting", self, "checkEnemies") 
	# Replace straw tiles with straw scenes
	var straws_h = get_used_cells_by_id(23)
	for straw in straws_h:
		set_cellv(straw,-1)
		var sceneStraw = Straw.instance()
		sceneStraw.position = straw*16 + Vector2(8,8)
		sceneStraw.vertical = false
		add_child(sceneStraw)
	var straws_v = get_used_cells_by_id(24)
	for straw in straws_v:
		set_cellv(straw,-1)
		var sceneStraw = Straw.instance()
		sceneStraw.position = straw*16 + Vector2(8,8)
		sceneStraw.vertical = true
		add_child(sceneStraw)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (get_node_or_null("PlayerTank")):
		$PlayerTank.rotateCannon(get_global_mouse_position().angle_to_point($PlayerTank.position))
		
		var tankDirection
		if (Input.is_action_pressed("move_up") && Input.is_action_pressed("move_right")):
			tankDirection = $PlayerTank.directions.UP_RIGHT
		elif (Input.is_action_pressed("move_down") && Input.is_action_pressed("move_left")):
			tankDirection = $PlayerTank.directions.DOWN_LEFT
		elif (Input.is_action_pressed("move_up") && Input.is_action_pressed("move_left")):
			tankDirection = $PlayerTank.directions.UP_LEFT
		elif Input.is_action_pressed("move_down") && Input.is_action_pressed("move_right"):
			tankDirection = $PlayerTank.directions.DOWN_RIGHT
		elif Input.is_action_pressed("move_up") :
			tankDirection = $PlayerTank.directions.UP
		elif Input.is_action_pressed("move_down"):
			tankDirection = $PlayerTank.directions.DOWN
		elif Input.is_action_pressed("move_left"):
			tankDirection = $PlayerTank.directions.LEFT
		elif Input.is_action_pressed("move_right"):
			tankDirection = $PlayerTank.directions.RIGHT

		if tankDirection:
			if (!$PlayerTank/MovingSound.playing):
				$PlayerTank/MovingSound.playing = true
			$PlayerTank.move(delta, tankDirection)
		else:
			$PlayerTank/MovingSound.playing = false
			
		if Input.is_action_just_pressed("shoot"):
			$PlayerTank.shoot()
			
		if Input.is_action_just_pressed("plant_mine"):
			$PlayerTank.plantMine()

func checkEnemies():
	enemies = get_tree().get_nodes_in_group("enemy").size()
	if (enemies == 1):
		if (get_parent().name == "Main"):
			emit_signal("enemies_killed")
		else:
			get_tree().quit()

func quitLevel():
	var death_timer = Timer.new()
	death_timer.wait_time = 2
	death_timer.autostart = true
	death_timer.connect("timeout", self, "_on_death_timer_timeout") 
	add_child(death_timer)

func _on_death_timer_timeout():
	if (get_parent().name == "Main"):
		emit_signal("player_died")
	else:
		get_tree().quit()



func _on_PlayerTank_player_dies():
	quitLevel()
