extends CharacterBody2D
class_name Character

@export var stats: CharacterStats = CharacterStats.new()
@export var abilities: Array[AbilityStats]

@onready var sprite: Sprite2D = $Sprite2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func highlight(color: Color):
	print("%s is highlighted" % [stats.name])
	sprite.material.set("shader_parameter/line_color", color)
	sprite.material.set("shader_parameter/line_thickness", 1.0)

func dehighlight():
	print("%s is no longer highlighted" % [stats.name])
	sprite.material.set("shader_parameter/line_thickness", 0.0)
