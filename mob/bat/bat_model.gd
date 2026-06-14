extends Node3D

@onready var anim_tree: AnimationTree = $AnimationTree

func hurt():
	anim_tree.set(
		"parameters/OneShot/request",
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE,
	)
