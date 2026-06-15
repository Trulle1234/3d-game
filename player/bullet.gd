extends Area3D

const SPEED = 55
const RANGE = 40

var travelled_distance = 0

func _physics_process(delta: float) -> void:
	position += transform.basis.z * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("mobs"):
		body.take_damage()
	queue_free()
