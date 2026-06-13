extends Area3D

const SPEED = 55
const RANGE = 40

var travelled_distance = 0

func _physics_process(delta: float) -> void:
	position += transform.basis.z * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()
