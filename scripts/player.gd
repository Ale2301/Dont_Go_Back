extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 4 #Te ponen
@export var gravity = 20
@export var teleport_limit_x = 0.0
@export var teleport_target_x = 79.24





func _physics_process(delta):
	var direction = Vector3.ZERO
	var target_velocity = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction = -transform.basis.x
	if direction.length() > 0:
		direction = direction.normalized()
		target_velocity = direction * speed
	
	if not is_on_floor():
		target_velocity.y -=gravity*delta
	else:
		target_velocity.y = 0

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	
	if global_transform.origin.x <= teleport_limit_x:
		global_transform.origin.x = teleport_target_x


