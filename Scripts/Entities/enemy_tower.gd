extends Node2D

var camera
var player

var CHANCE_TO_SPAWN = 0.05

export(bool) var trail_enabled = false

#onready var softnoise_script = load("res://Scripts/softnoise.gd")
#var softnoise
#var noise_value = 0
#
#var TIME = 0

func _ready():
	randomize()
	camera = get_tree().get_meta("camera")
	player = get_tree().get_meta("player")
	
#	softnoise = softnoise_script.SoftNoise.new()
#
#	TIME = randi()
	
func _process(delta):
	for layer in range($layers.get_children().size()):
		var angle = atan(camera.get_camera_screen_center().distance_to(get_node("layers").get_child(layer).global_position) / camera.distance_from_plane)
		
		get_node("layers").get_child(layer).position = layer*angle*Vector2(10, 0).rotated(global_position.angle_to_point(camera.get_camera_screen_center()))
	
	var distance_to_player = global_position.distance_to(player.global_position)
	var angle_to_player = global_position.angle_to_point(player.global_position)
	
#	if randf() < CHANCE_TO_SPAWN:
#		spawn_enemy()
		
func spawn_enemy():
	var enemy = load("res://Prefabs/Entities/Enemies/enemy.tscn").instance()
	enemy.tower = self
	enemy.position = position + Vector2(200, 0).rotated(randf()*2*PI)
	get_parent().add_child(enemy)
	
#func _draw():
#	var point_list = [[], []]
#	var color_list = []
#
#	for each_list in range(point_list.size()):
#		var list = point_list[each_list]
#		for radius in range(0, global_position.distance_to(player.global_position), 50):
#
#			var first_point = Vector2(-5 + each_list*10, 0).rotated(global_position.angle_to_point(player.global_position) + PI/2)
#
#			var point = Vector2(-radius, 0).rotated(global_position.angle_to_point(player.global_position))
#			point += each_list*Vector2(20, 0).rotated(global_position.angle_to_point(player.global_position) + PI/2)
#			point += first_point
#			list.append(point)
#
#	point_list[1].invert()
#
#	point_list = point_list[0] + point_list[1]
#
#	var new_point_list = []
#	var random_number = 0
#	for point in point_list:
#		random_number = fmod(lerp(random_number, random_number + randf()*1, 0.1), 1)
#		point += Vector2(5, 0).rotated(random_number*2*PI)
#		new_point_list.append(point)
#
#	for item in range(point_list.size()):
#		color_list.append(Color(1, 1, 1, 1))
#
#	var points = PoolVector2Array(new_point_list)
#	var colors = PoolColorArray(color_list)
#
#	draw_polygon(points, colors)