extends TextureButton

var target_position = Vector2(18, 18)
var scrolled = false

func _ready():
	pass
	
func _process(delta):
	rect_position = rect_position.linear_interpolate(target_position, 0.1)
	$shadow.position = $shadow.position.linear_interpolate(target_position - Vector2(18, 18), 0.1)

func _on_settings_mouse_entered():
	target_position.x = 28

func _on_settings_mouse_exited():
	target_position.x = 18

func _on_settings_pressed():
	disabled = true
	
	scrolled = not(scrolled)
	
	if get_node("../arrow").scrolled:
		get_node("../arrow/AnimationPlayer").play("unscroll")
		get_node("../arrow").scrolled = false
		scrolled = not(scrolled)
	if scrolled:
		get_node("AnimationPlayer").play("scroll")
	else:
		get_node("AnimationPlayer").play("unscroll")

func _on_AnimationPlayer_animation_finished(anim_name):
	disabled = false
