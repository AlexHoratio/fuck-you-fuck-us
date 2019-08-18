extends Node2D

export(Shape2D) var boundaries
onready var extents = boundaries.extents

var softnoise_script = load("res://Scripts/softnoise.gd")
onready var softnoise = softnoise_script.SoftNoise.new()
var noise_value = 0

func _ready():
	generate_walls_from_extents()
	position_particle_nodes()
	noise_value = randi()
	
func _process(delta):
	update()
	
func position_particle_nodes():
	for particles in get_node("particles").get_children():
		if particles.name == "top":
			particles.position = Vector2(0, -extents.y)
			particles.process_material.emission_box_extents = Vector3(extents.x, 1, 0)
		if particles.name == "bottom":
			particles.position = Vector2(0, extents.y)
			particles.process_material.emission_box_extents = Vector3(extents.x, 1, 0)
		elif particles.name == "right":
			particles.position = Vector2(extents.x, 0)
			particles.process_material.emission_box_extents = Vector3(1, extents.y, 0)
		elif particles.name == "left":
			particles.position = Vector2(-extents.x, 0)
			particles.process_material.emission_box_extents = Vector3(1, extents.y, 0)
			
	
func generate_walls_from_extents():
	#this only works with square walls/Vector2 extents
	
	for i in range(4):
		
		var collision_shape = CollisionShape2D.new()
		var shape = SegmentShape2D.new()
		
		if i == 0:
			shape.a = Vector2(-extents.x, -extents.y)
			shape.b = Vector2(extents.x, -extents.y)
		elif i == 1:
			shape.a = Vector2(extents.x, -extents.y)
			shape.b = Vector2(extents.x, extents.y)
		elif i == 2:
			shape.a = Vector2(extents.x, extents.y)
			shape.b = Vector2(-extents.x, extents.y)
		elif i == 3:
			shape.a = Vector2(-extents.x, extents.y)
			shape.b = Vector2(-extents.x, -extents.y)
			
		collision_shape.shape = shape
			
		get_node("StaticBody2D").add_child(collision_shape)
		
func _draw():
	var line = [[], []]
	var rect = Rect2(0, 0, 0, 0)
	var rect_distance_from_playable_area = 1000
	$walls.rect_list = []
	for i in range(4):
		if i == 0:
			line[0] = Vector2(-extents.x, -extents.y)
			line[1] = Vector2(extents.x, -extents.y)
			
			rect.position = Vector2(-extents.x, -extents.y - rect_distance_from_playable_area)
			rect.size = Vector2(extents.x * 4, rect_distance_from_playable_area)
		elif i == 1:
			line[0] = Vector2(extents.x, -extents.y)
			line[1] = Vector2(extents.x, extents.y)
			
			rect.position = Vector2(extents.x, -extents.y)
			rect.size = Vector2(extents.x + rect_distance_from_playable_area, extents.y*4)
		elif i == 2:
			line[0] = Vector2(extents.x, extents.y)
			line[1] = Vector2(-extents.x, extents.y)
			
			rect.position = Vector2(-extents.x*2, extents.y)
			rect.size = Vector2(extents.x*3, rect_distance_from_playable_area)
		elif i == 3:
			line[0] = Vector2(-extents.x, extents.y)
			line[1] = Vector2(-extents.x, -extents.y)
			
			rect.position = Vector2(-extents.x - rect_distance_from_playable_area, -extents.y*2)
			rect.size = Vector2(rect_distance_from_playable_area, extents.y*4)
			
		$walls.rect_list.append(rect)
		
		var polyline = PoolVector2Array()
		noise_value += 0.001
		for radius in range(0, line[0].distance_to(line[1]) + 20, 20):
			var point = Vector2(radius, 0).rotated(line[0].angle_to_point(line[1])) - line[0]
			
			if not(radius == 0 or radius >= line[0].distance_to(line[1])):
				point += Vector2(5, 0).rotated(2*PI*softnoise.openSimplex2D(radius + noise_value, radius + noise_value))
				
			polyline.append(point)
		
		draw_polyline(polyline, Color(0.2, 0.2, 0.2, 1), 5)
		