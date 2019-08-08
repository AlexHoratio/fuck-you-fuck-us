extends TextureButton

var target_position = Vector2(0, 0)

func _ready():
	pass
	
func _process(delta):
	rect_position = rect_position.linear_interpolate(target_position, 0.1)
	$shadow.position = $shadow.position.linear_interpolate(target_position, 0.1)

func _on_quit_mouse_entered():
	target_position.x = 20

func _on_quit_mouse_exited():
	target_position.x = 0

func _on_quit_pressed():
	get_tree().quit()
