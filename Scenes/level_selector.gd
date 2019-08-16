extends Node2D

var destination: String

func _ready():
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene(destination)
