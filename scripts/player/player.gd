extends CharacterBody3D

@export var walk_speed: float = 5.0
@export var sprint_speed: float = 8.5
@export var jump_velocity: float = 5.5
@export var rotation_speed: float = 12.0
@export var mouse_sensitivity: float = 0.003

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 14.0)

@onready var camera_pivot: Node3D = $CameraPivot
@onready var spring_arm: SpringArm3D = $CameraPivot/SpringArm3D
@onready var visual_model: Node3D = $VisualModel

var _cam_pitch: float = 0.0
var _step_time: float = 0.0

func _ready() -> void:
	add_to_group("player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Horizontal rotation rotates the camera pivot
		camera_pivot.rotate_y(-event.relative.x * mouse_sensitivity)
		# Vertical rotation adjusts spring arm pitch
		_cam_pitch = clamp(_cam_pitch - event.relative.y * mouse_sensitivity, deg_to_rad(-60), deg_to_rad(45))
		spring_arm.rotation.x = _cam_pitch
	
	if event.is_action_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get input vector
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("move_forward"):
		input_dir.y -= 1.0
	if Input.is_action_pressed("move_back"):
		input_dir.y += 1.0
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1.0
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1.0
	input_dir = input_dir.normalized()

	# Determine speed
	var current_speed = sprint_speed if Input.is_action_pressed("sprint") else walk_speed

	# Camera-relative movement
	var cam_basis = camera_pivot.global_transform.basis
	var forward = -cam_basis.z
	var right = cam_basis.x
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()

	var move_direction = (forward * -input_dir.y + right * input_dir.x).normalized()

	if move_direction.length() > 0.01:
		velocity.x = move_direction.x * current_speed
		velocity.z = move_direction.z * current_speed

		# Smoothly rotate model towards movement direction
		var target_angle = atan2(-move_direction.x, -move_direction.z)
		visual_model.rotation.y = lerp_angle(visual_model.rotation.y, target_angle, rotation_speed * delta)

		# Procedural walk tilt / step animation
		_step_time += delta * (12.0 if Input.is_action_pressed("sprint") else 8.0)
		visual_model.rotation.z = sin(_step_time) * 0.05
		visual_model.position.y = abs(sin(_step_time)) * 0.08
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed * 8.0 * delta)
		velocity.z = move_toward(velocity.z, 0, current_speed * 8.0 * delta)
		_step_time = 0.0
		visual_model.rotation.z = lerp(visual_model.rotation.z, 0.0, 10.0 * delta)
		visual_model.position.y = lerp(visual_model.position.y, 0.0, 10.0 * delta)

	move_and_slide()
