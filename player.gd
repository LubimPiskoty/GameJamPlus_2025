extends CharacterBody2D

var max_speed = 100 
var last_direction := Vector2(1,0)

func _physics_process(delta):
	var direction = Input.get_vector("Move_left", "Move_right", "Move_up", "Move_down")
	velocity = direction * max_speed
	move_and_slide()
	
	if direction.lenght() > 0:
		last_direction = direction
		play_walk_animation(direction)
		
func play_walk_animation(direction):
	if direction.x > 0:
		$AnimatedSprite2D.play("Walk_right")
	elif direction.x < 0:
		$AnimatedSprite2D.play("Walk_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("Walk_down")
	elif direction.y < 0:
		$AnimatedSprite2D.play("Walk_up")
