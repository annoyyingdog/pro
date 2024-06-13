extends CharacterBody3D
# player nodes

class_name Player
@onready var head = $head
@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape
@onready var ray_cast_3d = $RayCast3D
@onready var camera = $head/Camera3D
@onready var hand = $Hand
@onready var flashlight = $Hand/SpotLight3D
@onready var audio_player = $head/AudioStreamPlayer3D
var footstep_sounds = []


signal staminaChanged
signal step


#diff speeds
const walking_speed = 4.0
const sprinting_speed = 7.0
const crouching_speed = 3.0
const jump_velocity = 0
@export var mouse_sens = 0.55 #Global.sens # here is where I would replace "0.55" with the mouse_sens from the menu
#
@export var mouse_acc = 2.0
var playerAcceleration = 5.0

#________________________
const MAX_STAMINA = 200
const SPRINT_COST = 1
const REGEN_RATE = 30
const COOLDOWN_TIME = 3
# lerp - smooth, gradual stuff
var lerp_speed = 10.0
var current_speed = 5.0
var direction = Vector3.ZERO
var crouching_depth = -0.5
#__________________________
@onready var stamina = MAX_STAMINA
var sprinting = false
var cooldown = 0

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 65.0
const FOV_CHANGE = 1.5

#variables that wont work
var head_y_axis = 0.0
var camera_x_axis = 0.0

var can_play: bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	staminaChanged.emit()
	footstep_sounds = [
		load("res://assets/sounds/zapsplat_foley_footstep_single_boys_sneaker_on_concrete_001_50911.mp3"),
		load("res://assets/sounds/zapsplat_foley_footstep_single_boys_sneaker_on_concrete_002_50912.mp3")
	]
	randomize()
func _input(event):
	if event is InputEventMouseMotion:
		head_y_axis += event.relative.x * mouse_sens
		camera_x_axis += event.relative.y * mouse_sens
		camera_x_axis = clamp(camera_x_axis, -89, 89)
		#rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		#head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		#head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func _physics_process(delta):
	
	if cooldown > 0:
		cooldown = max(0, cooldown - delta)
		
	if not sprinting and cooldown == 0:
		stamina = min(MAX_STAMINA, stamina + REGEN_RATE * delta)
		staminaChanged.emit()
		
	if Input.is_action_pressed("crouch"):
		sprinting = false
		current_speed = crouching_speed
		#head.position.y = lerp(head.position.y,1.8 + crouching_depth, delta*lerp_speed)
		#standing_collision_shape.disabled = true
		#crouching_collision_shape.disabled = false
	elif !ray_cast_3d.is_colliding():
		#standing_collision_shape.disabled = false
		#crouching_collision_shape.disabled = true
		head.position.y = lerp(head.position.y,1.8, delta*lerp_speed)
		
		if Input.is_action_pressed("sprint") and stamina >= SPRINT_COST:
			sprinting = true
			current_speed = sprinting_speed
			stamina -= SPRINT_COST
			staminaChanged.emit()
			cooldown = COOLDOWN_TIME
		else:
			sprinting = false
			current_speed = walking_speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("left", "right", "forward", "back") 
	#direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	#if direction:
		#velocity.x = direction.x * current_speed
		#velocity.z = direction.z * current_speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, current_speed)
		#velocity.z = move_toward(velocity.z, 0, current_speed)
		
		
		# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, sprinting_speed * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	
	var low_pos = BOB_AMP - 0.05
	
	if pos.y > -low_pos:
		can_play = true
	if pos.y < -low_pos and can_play:
		_play_footstep_sound()
		can_play = false
	return pos
	
func _play_footstep_sound():
	var random_sound = footstep_sounds[randi()% footstep_sounds.size()]
	audio_player.stream = random_sound
	# Apply random pitch modulation
	var pitch_scale = randf_range(0.7, 1.7)
	audio_player.pitch_scale = pitch_scale
	# Play the sound
	audio_player.play()
	

	
func _on_StaminaTimer_timeout():
	stamina = min(MAX_STAMINA, stamina + REGEN_RATE)
	staminaChanged.emit()
	
func _on_StaminaCooldown_timeout():
	cooldown = 0
	stamina = min(MAX_STAMINA, stamina + REGEN_RATE)
	staminaChanged.emit()
	
func _process(delta):
	direction = Input.get_axis("left", "right") * head.basis.z + Input.get_axis("back", "forward") * head.basis.x
	velocity = velocity.lerp(direction * current_speed + velocity.y * Vector3.UP, playerAcceleration * delta)
	mouse_sens = Global.sens
	head.rotation.y = lerp(head.rotation.y, -deg_to_rad(head_y_axis), mouse_acc * delta * 2)
	camera.rotation.x = lerp(camera.rotation.x, -deg_to_rad(camera_x_axis), mouse_acc * delta* 2.1)
	
	hand.rotation.y = -deg_to_rad(head_y_axis) 
	flashlight.rotation.x = -deg_to_rad(camera_x_axis)
