extends Area2D

export(int) var stage = 1
export(int) var level = 1

export(bool) var enabled = false

var modulates = {
	"disabled": Color("ac3232"),
	"enabled": Color("6abe30")
}

var bucket_sprites_path = "res://Graphics/Level Selector/Buckets/"

func _ready():
	randomize()
	set_random_bucket_sprite()
	if enabled:
		enable()
	else:
		disable()

func set_random_bucket_sprite() -> void:
	var list_of_sprites = get_list_of_bucket_sprites()
	var choice = list_of_sprites[int(rand_range(0, list_of_sprites.size()))]
	
	var choice_tex = load(bucket_sprites_path + choice)
	get_node("Sprite").texture = choice_tex
	get_node("Sprite/shadow").texture = choice_tex
	
func get_list_of_bucket_sprites() -> Array:
	var files: Array = []
	
	var bucket_sprite_folder = Directory.new()
	bucket_sprite_folder.open(bucket_sprites_path)
	bucket_sprite_folder.list_dir_begin()
	
	while true:
		var file = bucket_sprite_folder.get_next()
		if file == "":
			break
		elif not(file.begins_with(".") or file.ends_with(".import")):
			files.append(file)
	
	return files

func enable() -> void:
	get_node("Sprite/shadow").self_modulate = modulates["enabled"]
	
func disable() -> void:
	get_node("Sprite/shadow").self_modulate = modulates["disabled"]

func _on_bucket_body_entered(body):
	if body == get_tree().get_meta("player") and enabled:
		body.enter_catatonia(stage, level)
