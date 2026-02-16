extends Area2D
var explosion_scene = preload("res://explosion.tscn")
var velocity = Vector2.ZERO
var score_emitted = false
signal score #like a trigger to pick up the signal somewhere else



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	var speed = randf_range(50.0, 150.0)
	
	var direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	)
	
	velocity = direction * speed
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	#screen size 320 x 180
	#if the object is 40 pixels from any side of screen, we get rig of it using queuefree
	if position.x < -40 or position.x > 360 or position.y < -40 or position.y > 220:
		queue_free()
		

 
#fired anytime something moves into the asteroid area
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("shot") or area.is_in_group("player"):
		if not score_emitted == true: #if its false then do all code that proceeds
			score_emitted = true
			emit_signal("score")
			queue_free()	
			
			var stage_node = get_parent()
			var explosion_instance = explosion_scene.instantiate()
			explosion_instance.position = position
			stage_node.add_child(explosion_instance)
			 # Replace with function body.
