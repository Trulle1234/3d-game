extends RigidBody3D

@onready var model: Node3D = $BatModel
@onready var despawn_timer: Timer = $DespawnTimer
@onready var player = get_node("/root/Level/Player")

@onready var hurt_sound: AudioStreamPlayer3D = $HurtSound
@onready var death_sound: AudioStreamPlayer3D = $DeathSound

signal death
signal health_zero

var speed = randf_range(2, 4)
var health = 4

var last_player_floor_pos = 0

func _physics_process(delta: float) -> void:
	var target_pos = player.global_position + Vector3(0, 1.2, 0)
	if player.is_on_floor():
		last_player_floor_pos = player.global_position.y
	else:
		target_pos.y = last_player_floor_pos + 1.2
	
	var dir = global_position.direction_to(target_pos)
	
	if dir.length_squared() < 0.001:
		linear_velocity = Vector3.ZERO
		return
	
	dir = dir.normalized()
	linear_velocity = dir * speed
	
	var look_dir = target_pos - global_position
	look_dir.y = 0
	
	if look_dir.length_squared() > 0.001:
		look_dir = look_dir.normalized()
		model.global_basis = Basis.looking_at(-look_dir, Vector3.UP)

func take_damage():
	if health == 0:
		return
	
	hurt_sound.pitch_scale = randf_range(0.9, 1)
	hurt_sound.play()
	
	model.hurt()
	health -= 1
	
	if health == 0:
		health_zero.emit()
		set_physics_process(false)
		
		death_sound.pitch_scale = randf_range(0.9, 1)
		death_sound.play()
		
		gravity_scale = 1
		
		var dir = -global_position.direction_to(player.global_position)
		var random_up_force = Vector3.UP * randf_range(1, 3)
		apply_central_impulse(dir * 6 + random_up_force)
		
		despawn_timer.start()

func _on_despawn_timer_timeout() -> void:
	death.emit()
	queue_free()
