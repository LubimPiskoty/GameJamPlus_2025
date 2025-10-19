extends CharacterBody2D

var max_speed = 100 
var last_direction := Vector2(1,0)

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * max_speed
	move_and_slide()
	
	if direction.length() > 0:
		last_direction = direction
		play_walk_animation(direction)
	else:
		play_idle_animation(last_direction)

func play_walk_animation(direction):
	if direction.x > 0:
		$AnimatedSprite2D.play("Walk_right")
	elif direction.x < 0:
		$AnimatedSprite2D.play("Walk_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("Walk_down")
	elif direction.y < 0:
		$AnimatedSprite2D.play("Walk_up")

func play_idle_animation(last_direction):
	if last_direction.x > 0:
		$AnimatedSprite2D.play("Idle_right")
	elif last_direction.x < 0:
		$AnimatedSprite2D.play("Idle_left")
	elif last_direction.y > 0:
		$AnimatedSprite2D.play("Idle_down")
	elif last_direction.y < 0:
		$AnimatedSprite2D.play("Idle_up")
