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

func _physics_process(delta: float) -> void:
	var dir = global_position.direction_to(player.global_position) 
	dir.y = 0
	
	if dir.length_squared() < 0.001:
		return
	
	dir = dir.normalized()
	linear_velocity = dir * speed
	
	model.global_basis = Basis.looking_at(-dir , Vector3.UP)

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
