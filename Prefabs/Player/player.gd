extends RigidBody2D

#
# TODO: REMAKE THIS FOR KINEMATICBODIES TOO?
#

#PHYSICS VARIABLES
var SPEED = 5000
var MAX_SPEED = 500
var KNOCKBACK = 600
var BULLET_SPEED = 10
var redirect_compensation = 5
var direction_focus = 0.95

var catatonic = false

onready var camera = $Camera2D

func _ready():
	linear_damp = 2.3
	
	get_tree().set_meta("player", self)
	get_tree().set_meta("camera", $Camera2D)

func _physics_process(delta):
	
	if not(catatonic):
		if(Input.is_action_pressed("ui_left")):
			linear_velocity.x -= SPEED*delta
			if(linear_velocity.x > 0):
				linear_velocity.x -= SPEED*delta*redirect_compensation
			linear_velocity.y *= direction_focus
		if(Input.is_action_pressed("ui_right")):
			linear_velocity.x += SPEED*delta
			if(linear_velocity.x < 0):
				linear_velocity.x += SPEED*delta*redirect_compensation
			linear_velocity.y *= direction_focus
		if(Input.is_action_pressed("ui_up")):
			linear_velocity.y -= SPEED*delta
			if(linear_velocity.y > 0):
				linear_velocity.y -= SPEED*delta*redirect_compensation
			linear_velocity.x *= direction_focus
		if(Input.is_action_pressed("ui_down")):
			linear_velocity.y += SPEED*delta
			if(linear_velocity.y < 0):
				linear_velocity.y += SPEED*delta*redirect_compensation
			linear_velocity.x *= direction_focus
	
	linear_velocity.x = min(max(linear_velocity.x, -MAX_SPEED), MAX_SPEED)
	linear_velocity.y = min(max(linear_velocity.y, -MAX_SPEED), MAX_SPEED)
	
	if linear_velocity.length() > 250:
		get_node("particles/col").emitting = true
	else: 
		get_node("particles/col").emitting = false
	
func _input(event):

	if not(catatonic):
		if event is InputEventMouseButton:
			if event.button_mask == BUTTON_LEFT:
				var impulse = Vector2(1, 0).rotated(position.angle_to_point(get_global_mouse_position())) * KNOCKBACK
				apply_impulse(Vector2(0, 0), impulse)
				
				var bullet = load("res://Prefabs/Bullets/player_bullet.tscn").instance()
				bullet.movement_vector = -impulse.normalized() * BULLET_SPEED
				bullet.position = position
				get_parent().add_child(bullet)
			
#			var muzzleflash = load("res://muzzleflash.tscn").instance()
#			#muzzleflash.position = position
#			muzzleflash.rotation = impulse.angle() + PI
#			add_child(muzzleflash)
	
func enter_catatonia(stage=1, level=1) -> void:
	catatonic = true
	
	get_node("..").destination = "res://Scenes/Levels/" + str(stage) + "-" + str(level) + ".tscn"
	get_node("../CanvasLayer/ColorRect/AnimationPlayer").play("fade_out")
	
func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference