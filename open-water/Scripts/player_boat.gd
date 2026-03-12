extends CharacterBody3D

const SPEED = 10.0
const TURN_SPEED = 2.0
const SINK_SPEED = 1.0
const RESPAWN_TIME = 3.0

var max_health = 100
var current_health = 100
var is_sinking = false
var spawn_point = Vector3.ZERO
var respawn_timer = 0.0

func _ready():
	spawn_point = global_position
	print("Boat Ready! Use WASD to move. Press Space to take damage.")

@onready var camera = $Camera3D
const BASE_FOV = 75.0
const MAX_FOV_OFFSET = 10.0

# Wave Constants (Matching the Shader)
const WAVE_SPEED = 1.0
const WAVE_HEIGHT = 0.25

func _physics_process(delta):
	if is_sinking:
		_handle_sinking(delta)
		return

	# Wave/Bobbing Calculation
	var time = Time.get_ticks_msec() / 1000.0
	var wave_h = _get_wave_height(global_position.x, global_position.z, time)
	
	# Apply rocking rotation
	# Tilt based on the wave slope
	var wave_h_offset = _get_wave_height(global_position.x + 0.5, global_position.z + 0.5, time)
	var tilt_x = (wave_h - wave_h_offset) * 0.5
	var tilt_z = (wave_h - _get_wave_height(global_position.x - 0.5, global_position.z, time)) * 0.5
	
	rotation.x = lerp_angle(rotation.x, tilt_x, delta * 2.0)
	rotation.z = lerp_angle(rotation.z, tilt_z, delta * 2.0)
	
	# Keep the boat bobbing on Y - submerged slightly for draft
	position.y = wave_h - 0.1

	# Simple boat movement
	var input_dir = Vector2.ZERO
	if Input.is_key_pressed(KEY_W): input_dir.y -= 1
	if Input.is_key_pressed(KEY_S): input_dir.y += 1
	if Input.is_key_pressed(KEY_A): input_dir.x -= 1
	if Input.is_key_pressed(KEY_D): input_dir.x += 1
	
	# Rotation (A/D) - Use a separate yaw variable or rotate_y to not fight the tilt
	if input_dir.x != 0:
		rotate_y(-input_dir.x * TURN_SPEED * delta)

	# Forward/Backward (W/S)
	if input_dir.y != 0:
		var forward = -transform.basis.z
		velocity.x = forward.x * -input_dir.y * SPEED
		velocity.z = forward.z * -input_dir.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta * 5)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta * 5)

	velocity.y = 0 # Physics doesn't handle Y, we set it manually for bobbing
	move_and_slide()
	
	# FOV Sensation of speed
	var speed_ratio = velocity.length() / SPEED
	camera.fov = lerp(camera.fov, BASE_FOV + (speed_ratio * MAX_FOV_OFFSET), delta * 2.0)
	
	# Debug damage testing
	if Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_SPACE):
		take_damage(25)

func _get_wave_height(x: float, z: float, t: float) -> float:
	var w1 = sin(x * 0.5 + t * WAVE_SPEED) * cos(z * 0.5 + t * WAVE_SPEED)
	var w2 = sin(x * 1.5 - t * WAVE_SPEED * 0.8) * cos(z * 1.5 + t * WAVE_SPEED * 1.2)
	return (w1 + w2 * 0.5) * WAVE_HEIGHT

func take_damage(amount):
	if is_sinking: return
	
	current_health -= amount
	print("Took damage! Health: ", current_health)
	
	if current_health <= 0:
		start_sinking()

func start_sinking():
	is_sinking = true
	print("Sinking...")
	respawn_timer = RESPAWN_TIME

func _handle_sinking(delta):
	# Lower the boat
	position.y -= SINK_SPEED * delta
	# Rotate slightly to simulate sinking
	rotate_x(0.2 * delta)
	
	# Handle respawn timer
	respawn_timer -= delta
	if respawn_timer <= 0:
		respawn()

func respawn():
	print("Respawning...")
	is_sinking = false
	current_health = max_health
	global_position = spawn_point
	rotation = Vector3.ZERO
	velocity = Vector3.ZERO
