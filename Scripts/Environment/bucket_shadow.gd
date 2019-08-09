extends Sprite

var TIME = 0
var distance = 1
var target_distance = 1
var time_scale = 1

var scrolled = false

func _ready():
	TIME = randi()

func _process(delta):
	TIME += delta*time_scale

	position.y += sin(TIME*4)*0.2

	$shadow.position.y += sin(TIME*4 + 0.5)*0.1 * distance
	$shadow.position.x = cos(TIME)*2 * distance

	distance = lerp(distance, target_distance, 0.1)
	
	var distance_to_player = global_position.distance_to(get_tree().get_meta("player").position)
	if distance_to_player < 200:
		time_scale = 8
	else:
		time_scale = 1