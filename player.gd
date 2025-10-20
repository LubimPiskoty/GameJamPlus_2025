extends CharacterBody2D

@onready var animTree = $AnimationTree

var max_speed = 100 
var last_direction := Vector2(1,0)

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * max_speed
	move_and_slide()
	
	if direction.length() > 0:
		last_direction = direction
	elif last_direction.length() > 0.15:
		last_direction = last_direction.limit_length(0.1)
	
	animTree["parameters/Locomotion/blend_position"] = last_direction
