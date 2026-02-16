extends Node2D
var is_game_over = false
var asteroid = preload("res://asteroid.tscn")
var SCREEN_WIDTH= 320
var SCREEN_HEIGHT= 180
var score= 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	get_node("player").destroyed.connect(_on_player_destroyed)
	#$player.connect("destroyed", _on_player_destroyed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE): #game quits
		get_tree().quit()
	if is_game_over and Input.is_key_pressed(KEY_ENTER): #game over, so starts a new game
		get_tree().change_scene_to_file("res://stage.tscn")
		
	
func _on_player_destroyed():
	get_node("ui/retry").show()
	is_game_over = true


func _on_spawn_timer_timeout() -> void:
	var asteroid_instance = asteroid.instantiate()
	var side = randi() % 4
	#when a side is picked it spawns an asteroid at random
	match side:
		0: 
			asteroid_instance.position = Vector2(SCREEN_WIDTH + 8, randf_range(0, SCREEN_HEIGHT))
		1:
			asteroid_instance.position = Vector2(SCREEN_WIDTH - 8, randf_range(0, SCREEN_HEIGHT))
		2: 
			asteroid_instance.position = Vector2(SCREEN_HEIGHT + 8, randf_range(0, SCREEN_WIDTH)) 
		3:
			asteroid_instance.position = Vector2(SCREEN_HEIGHT - 8, randf_range(0, SCREEN_WIDTH))
	asteroid_instance.score.connect(_on_player_score)
	add_child(asteroid_instance)
	
func _on_player_score():
	score += 1
	get_node("ui/score").text = "score: " + str(score)
