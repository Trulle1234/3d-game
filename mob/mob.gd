extends RigidBody3D

@onready var model: Node3D = $BatModel
@onready var despawn_timer: Timer = $DespawnTimer
@onready var player = get_node("/root/Level/Player")

var speed = randf_range(2, 4)
var health = 5

func _physics_process(delta: float) -> void:
	var dir = global_position.direction_to(player.global_position)
	dir.y = 0
	linear_velocity = dir * speed
	
	model.rotation.y = Vector3.FORWARD.signed_angle_to(dir, Vector3.UP) + PI/2

func take_damage():
	if health == 0:
		return
	
	model.hurt()
	health -= 1
	
	if health == 0:
		set_physics_process(false)
		
		gravity_scale = 1
		var dir = -1 * global_position.direction_to(player.global_position)
		var random_up_force = Vector3.UP * randf_range(1, 3)
		apply_central_impulse(dir *  6 + random_up_force)
		
		despawn_timer.start()

func _on_despawn_timer_timeout() -> void:
	model.hurt()
	await get_tree().create_timer(0.2).timeout
	queue_free()
