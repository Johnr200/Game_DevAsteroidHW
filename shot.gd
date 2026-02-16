extends Area2D
const SCREEN_WIDTH= 320
const MOVE_SPEED= 500.0
var velocity = Vector2.ZERO

func set_velocity(new_velocity: Vector2):
	velocity = new_velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta

	if position.x < -20 or position.x > 340 or \
	   position.y < -20 or position.y > 200:
		queue_free()


#feb 4, 9:24 AM
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		queue_free()
	
