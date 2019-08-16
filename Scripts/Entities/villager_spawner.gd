extends CollisionShape2D

export(int) var NUMBER_OF_VILLAGERS = 20

func _ready():
	generate_villagers()

func generate_villagers() -> void:
	var radius = shape.radius
	
	for i in range(NUMBER_OF_VILLAGERS):
		var villager = load("res://Prefabs/Entities/villager.tscn").instance()
		
		villager.position = position + Vector2(1, 0).rotated(2*PI*randf()) * randf()*radius
		
		get_node("../../villagers").add_child(villager)