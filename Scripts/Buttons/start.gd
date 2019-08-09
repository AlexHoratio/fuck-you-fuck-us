extends TextureButton

var target_position = Vector2(0, 0)

func _ready():
	pass
	
func _process(delta):
	rect_position = rect_position.linear_interpolate(target_position, 0.1)
	$shadow.position = $shadow.position.linear_interpolate(target_position, 0.1)

func _on_start_mouse_entered():
	target_position.x = -20

func _on_start_mouse_exited():
	target_position.x = 0

func _on_start_pressed():
	if not(get_node("../settings").disabled):
		get_node("AnimationPlayer").play("scroll")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "scroll":
		get_tree().change_scene("res://Scenes/level_selector.tscn")
