extends Node3D

@onready var label: Label = $Label
@onready var player: CharacterBody3D = $Player

var score = 0

func _ready() -> void:
	do_poof(player.global_position + Vector3(0, 1, 0))

func add_score():
	score += 1
	label.text = "Score: " + str(score)

func do_poof(global_pos):
	const SMOKE_PUFF = preload("uid://cjk3frr43yesb")
	var poof = SMOKE_PUFF.instantiate()
	add_child(poof)
	poof.global_position = global_pos
	
func _on_mob_spawner_mob_spawned(mob: Variant) -> void:
	mob.health_zero.connect(add_score)
	mob.death.connect(func on_mob_death(): do_poof(mob.global_position))
	do_poof(mob.global_position)

func _on_kill_plane_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()
