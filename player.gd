extends Area2D
const MOVE_SPEED = 150.0
const SCREEN_WIDTH= 320.0
const SCREEN_HEIGHT= 180.0
#creating object called shot_scene (creating a laser), loading into memory
#must preload a scene if you want to create a version of a shot
var shot_scene = preload("res://shot.tscn")
var explosion_scene= preload ("res://explosion.tscn")
var can_shoot = true #boolean variable
var shot_speed =500.0
var rotation_speed = 6.0 #used for rotating the ship left or right
signal destroyed 
var velocity = Vector2.ZERO
var thrust_force = 250.0
var friction = 0.97 #adds friction to slow down ship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#cuts height and width in half to spawn ship in middle
	position = Vector2(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input_direction = Vector2()
	#uses rotation speed var to rotate ship when key is pressed
	if Input.is_key_pressed(KEY_LEFT):
		rotation -= rotation_speed * delta
	if Input.is_key_pressed(KEY_RIGHT):
		rotation += rotation_speed * delta
	if Input.is_key_pressed(KEY_UP): 
		var direction = Vector2.RIGHT.rotated(rotation) #thrust in same direction pointing to
		velocity += direction * thrust_force * delta
	
	velocity *= friction
	
	position += velocity * delta

	position += (delta * MOVE_SPEED) * input_direction
	
	if position.x < 0.0:
		position.x = 0
	elif position.x > SCREEN_WIDTH:
		position.x = SCREEN_WIDTH
		
	if position.y < 0.0:
		position.y = 0
	elif position.y > SCREEN_HEIGHT:
		position.y = SCREEN_HEIGHT
		
		  #both mus be true for function to run
	if Input.is_key_pressed(KEY_SPACE) and can_shoot:
		
		var stage_node = get_parent() #reference to the stage
		var direction = Vector2.RIGHT.rotated(rotation) #point lasers in same direction

		var shot_instance = shot_scene.instantiate() #new copy of the laser called shot_instance
		shot_instance.position = position + direction * 17 + Vector2(0,-5) #positioning the shots position to the same shit position
		shot_instance.set_velocity(direction * shot_speed)
		shot_instance.rotation = direction.angle() #lasers will face the direction of the ship
		stage_node.add_child(shot_instance) #adding the shot instance to the stage
		
		var shot_instance2 = shot_scene.instantiate() #new copy of the laser called shot_instance
		shot_instance2.position = position + direction * 17 + Vector2(0,5) #positioning the shots position to the same shit position
		shot_instance2.set_velocity(direction * shot_speed)
		shot_instance2.rotation = direction.angle() #lasers will face the direction of the ship
		stage_node.add_child(shot_instance2)
		
		
		can_shoot = false #turning off ability to shoot
		get_node("reload_timer").start()
		
func _on_reload_timer_timeout() -> void:
	can_shoot = true


func _on_area_entered(area: Area2D) -> void:
	
	var stage_node = get_parent()
	var explosion_instance = explosion_scene.instantiate()
	explosion_instance.position = position
	stage_node.add_child(explosion_instance)
	
	emit_signal("destroyed")
	queue_free()
