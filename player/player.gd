extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var marker: Marker3D = $Camera3D/Marker3D
@onready var timer: Timer = $ShootTimer
@onready var shoot_sound: AudioStreamPlayer = $ShootSound

const BULLET = preload("uid://bdddr4ndq3ada")

const GRAVITY = 20
const SPEED = 5.5
const JUMP_STRENGTH = 8

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:	
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.15
		camera.rotation_degrees.x -= event.relative.y * 0.1
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -80, 80)
		
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	var input_dir_2d = Input.get_vector("left", "right", "forward", "back")
	var input_dir_3d = Vector3(input_dir_2d.x, 0, input_dir_2d.y)
	var dir = transform.basis * input_dir_3d
	
	if input_dir_3d != Vector3(0, 0, 0) and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	velocity.x = dir.x * SPEED
	velocity.z = dir.z * SPEED
	
	velocity.y -= GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_STRENGTH
	
	move_and_slide()
	
	if Input.is_action_pressed("shoot") and timer.is_stopped():
		shoot()
	
func shoot():
	shoot_sound.pitch_scale = randf_range(0.9, 1)
	shoot_sound.play()
	
	var new_bullet = BULLET.instantiate()
	marker.add_child(new_bullet)
	
	new_bullet.global_transform = marker.global_transform
	
	timer.start()
