extends Node2D


func _ready():
	get_node("Particles2D").emitting = true

func _on_die_timeout():
	queue_free()
