extends CharacterBody2D
class_name Character

@export var stats: CharacterStats = CharacterStats.new()
@export var abilities: Array[AbilityStats]

@onready var sprite: Sprite2D = $Sprite2D
const outlineShader: Shader = preload("res://Shaders/outline.gdshader")

const SPEED = 300.0

signal _on_death(Character)

var handle_input = true

func _ready() -> void:
	stats._on_death.connect(on_death)
	stats._on_armor_break.connect(on_armor_break)
	stats._on_damage_taken.connect(on_damage_taken)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not handle_input:
		return
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func highlight(color: Color):
	var mat := ShaderMaterial.new()
	mat.shader = outlineShader
	sprite.material = mat
	sprite.material.set("shader_parameter/line_color", color)
	sprite.material.set("shader_parameter/line_thickness", 1.0)

func dehighlight():
	sprite.material = null



func on_death():
	print_debug(stats.name + " has died!")
	_on_death.emit(self)
	get_tree().create_timer(10.0).timeout.connect(queue_free)

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).tween_property(sprite, "self_modulate", Color.RED, 1.0)
	tween.set_trans(Tween.TRANS_BACK).tween_property(sprite, "modulate", Color.TRANSPARENT, 1.0)


func on_armor_break():
	#TODO: Add animation
	var particles: GPUParticles2D = $ArmorBreakParticles
	particles.restart()
	particles.emitting = true


func on_damage_taken():
	#TODO: Add animation
	var particles: GPUParticles2D = $DamageTakenParticles
	particles.restart()
	particles.emitting = true
