extends Node3D

@onready var marker: Marker3D = $Marker3D
@onready var timer: Timer = $Timer

@export var mob_to_spawn: PackedScene = null

signal mob_spawned(mob)

func _on_timer_timeout() -> void:
	var new_mob = mob_to_spawn.instantiate()
	add_child(new_mob)
	
	new_mob.global_position = marker.global_position
	
	mob_spawned.emit(new_mob)
