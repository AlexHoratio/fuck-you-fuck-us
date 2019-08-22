extends Camera2D

export var distance_from_plane = 200

var trauma = 0
var STRENGTH = 2

func _ready():
	pass

func _process(delta):
	offset = Vector2(2*randf() - 1, 2*randf() - 1) * trauma * trauma * STRENGTH
	
	trauma = clamp(trauma - delta, 0, 1)