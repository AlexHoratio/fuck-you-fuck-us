extends TextureButton

var TIME = 0
var distance = 1
var target_distance = 1

var scrolled = false

func _ready():
	pass
	
func _process(delta):
	TIME += delta
	
	rect_position.y += sin(TIME*4)*0.2
	
	$shadow.position.y += sin(TIME*4 + 0.5)*0.1 * distance
	$shadow.position.x = cos(TIME)*2 * distance
	
	distance = lerp(distance, target_distance, 0.1)
	
func _on_arrow_mouse_entered():
	target_distance = 3

func _on_arrow_mouse_exited():
	target_distance = 1

func _on_arrow_pressed():
	scrolled = true
	get_node("AnimationPlayer").play("scroll")
