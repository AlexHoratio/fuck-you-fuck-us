extends RigidBody2D

#
# TODO: REMAKE THIS FOR KINEMATICBODIES TOO?
#

#PHYSICS VARIABLES
var SPEED = 200
var MAX_SPEED = 400
var redirect_compensation = 5
var direction_focus = 0.95

var tower

var movement_vector = Vector2(0, 0)
var meta_vector = Vector2(0, 0)

var knockback_vector
var knockback_queued = false

func _ready():
	add_to_group("enemies")
	linear_damp = 2.3
	
func knockback(bullet_movement_vector):
	knockback_vector = bullet_movement_vector.linear_interpolate(movement_vector, 0.5)*500
	knockback_queued = true

func _physics_process(delta):
	
	if knockback_queued:
		knockback_queued = false
		linear_velocity += knockback_vector
	
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
	
