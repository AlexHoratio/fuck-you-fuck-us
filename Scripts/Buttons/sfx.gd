extends TextureButton

var target_position = Vector2(100, 10)

var textures = {
	"unmuted":[
		preload("res://Graphics/Menu/Buttons/SFX/normal.png"),
		preload("res://Graphics/Menu/Buttons/SFX/shadow.png"), 
	],
	"muted":[
		preload("res://Graphics/Menu/Buttons/SFX/disabled/normal.png"),
		preload("res://Graphics/Menu/Buttons/SFX/disabled/shadow.png"), 
	]
}
var muted = false
var trauma = 0
var MAX_SHAKE = 8

func _ready():
	pass
	
func _process(delta):
	rect_position = rect_position.linear_interpolate(target_position, 0.1)
	$shadow.position = $shadow.position.linear_interpolate(target_position - Vector2(100, 10), 0.1)

	trauma = clamp(trauma - delta*3, 0, 1)
	$shadow.offset = Vector2((2*randf()-1)*MAX_SHAKE, (2*randf()-1)*MAX_SHAKE) * trauma * trauma
	
func _on_sfx_mouse_entered():
	target_position.x = 90

func _on_sfx_mouse_exited():
	target_position.x = 100

func _on_sfx_pressed():
	muted = not(muted)
	
	if muted:
		texture_normal = textures["muted"][0]
		get_node("shadow").texture = textures["muted"][1]
	else:
		texture_normal = textures["unmuted"][0]
		get_node("shadow").texture = textures["unmuted"][1]
		
	trauma = 1
