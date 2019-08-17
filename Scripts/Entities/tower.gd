extends Node2D

var camera

func _ready():
	camera = get_tree().get_meta("camera")
	
func _process(delta):
	for layer in range($layers.get_children().size()):
		var angle = atan(camera.get_camera_screen_center().distance_to(get_node("layers").get_child(layer).global_position) / camera.distance_from_plane)
		
		get_node("layers").get_child(layer).position = layer*angle*Vector2(10, 0).rotated(global_position.angle_to_point(camera.get_camera_screen_center()))
