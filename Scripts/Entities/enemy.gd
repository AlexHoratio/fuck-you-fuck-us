extends RigidBody2D

#
# TODO: REMAKE THIS FOR KINEMATICBODIES TOO?
#

#PHYSICS VARIABLES
var SPEED = 200
var MAX_SPEED = 400
var redirect_compensation = 5
var direction_focus = 0.95

var can_move = true

var tower

var movement_vector = Vector2(0, 0)
var meta_vector = Vector2(0, 0)

var knockback_vector
var knockback_queued = false

var alerted = false

var HEALTH = 2

func _ready():
	add_to_group("enemies")
	linear_damp = 2.3
	
func knockback(bullet_movement_vector):
	knockback_vector = bullet_movement_vector.linear_interpolate(movement_vector, 0.5)*500
	knockback_queued = true
	
func alert():
	alerted = true

func _physics_process(delta):
	
	if knockback_queued:
		knockback_queued = false
		linear_velocity += knockback_vector
	
	if can_move:
		if(movement_vector.x < 0):
			linear_velocity.x -= SPEED*delta
		if(movement_vector.x > 0):
			linear_velocity.x += SPEED*delta
		if(movement_vector.y < 0):
			linear_velocity.y -= SPEED*delta
		if(movement_vector.y > 0):
			linear_velocity.y += SPEED*delta
		
	linear_velocity.x = min(max(linear_velocity.x, -MAX_SPEED), MAX_SPEED)
	linear_velocity.y = min(max(linear_velocity.y, -MAX_SPEED), MAX_SPEED)
	
	if get_tree().get_meta("player").position.distance_to(position) < 200 and not(alerted):
		alert()
		
	if get_tree().get_meta("player").position.distance_to(position) < 100 and alerted:
		if get_node("attack_charge").is_stopped():
			get_node("attack_charge").start()
			get_node("Particles2D").emitting = true
			can_move = false
		
	if alerted:
		movement_vector = Vector2(-1, 0).rotated(position.angle_to_point(get_tree().get_meta("player").position))
	else:
		movement_vector = Vector2(0, 0)

func damage(amount):
	HEALTH -= amount
	get_node("Sprite/take_damage").play("take_damage")

func fire_attack():
	if get_tree().get_meta("player").position.distance_to(position) < 100:
		get_tree().get_meta("player").apply_impulse(Vector2(0, 0), 50*Vector2(-1, 0).rotated(position.angle_to_point(get_tree().get_meta("player").position)))
	
		var lightning = load("res://Prefabs/Bullets/Adam/lightning.tscn").instance()
		get_parent().add_child(lightning)
		lightning.end_point = position
	
	can_move = true
	get_node("Particles2D").emitting = false
	
	var muzzleflash = load("res://Prefabs/Bullets/Adam/Muzzleflash/muzzleflash.tscn").instance()
	#muzzleflash.position = position
	add_child(muzzleflash)
	
	
func _on_attack_charge_timeout():
	fire_attack()
