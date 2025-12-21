extends CharacterBody3D

@export var animator: AnimationTree
@export var mesh: Node3D

const SPEED = 2.0
const JUMP_VELOCITY = 4.5

func _ready():
	assert(animator, "CharacterBody3D: Animator not set")
	assert(mesh, "CharacterBody3D: Mesh not set")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	if velocity.length_squared():
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-velocity.z, velocity.x) + PI/2, 0.2)
	animator.set("parameters/blend_position", velocity.length());
