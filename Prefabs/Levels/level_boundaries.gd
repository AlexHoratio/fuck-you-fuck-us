extends Node2D

export(Shape2D) var boundaries
onready var extents = boundaries.extents

func _ready():
	generate_walls_from_extents()
	
func _process(delta):
	update()
	
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
			
		draw_line(line[0], line[1], Color(0.2, 0.2, 0.2, 1), 5)
		draw_rect(rect, Color(0, 0, 0, 1))