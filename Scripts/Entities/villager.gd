extends RigidBody2D

var noise_script = load("res://Scripts/softnoise.gd")
var softnoise
var TIME = 0
var avoidance_coefficient = 0.2
var offset_constant = Vector2(0, 0)
var nearby_villagers = []
var SPEED = 0.2

func _ready():
	add_to_group("villagers")
	
	randomize()
	softnoise = noise_script.SoftNoise.new()
	
	linear_velocity = SPEED*Vector2(100, 0).rotated(randf()*2*PI)
	TIME = randi() + randf()
	offset_constant = Vector2(randf(), randf()) * 50

func _process(delta):
	TIME += SPEED * delta * 0.2
	rotation += SPEED*softnoise.openSimplex2D(TIME + offset_constant.x, TIME + offset_constant.y) * avoidance_coefficient
	
	linear_velocity = SPEED*Vector2(100, 0).rotated(rotation)

# AVOIDANCE CALCULATION
#	if nearby_villagers.size() > 0:
#		var epicenter = Vector2(0, 0)
#
#		for villager in nearby_villagers:
#			epicenter += villager.position
#		epicenter /= nearby_villagers.size()

	position += linear_velocity*delta

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func _on_Area2D_body_entered(body):
	if body in get_tree().get_nodes_in_group("villagers") and not(body == self):
		#avoidance_coefficient = 1
		nearby_villagers.append(body)

func _on_Area2D_body_exited(body):
	if body in get_tree().get_nodes_in_group("villagers") and not(body == self):
		#avoidance_coefficient = 1
		nearby_villagers.erase(body)
