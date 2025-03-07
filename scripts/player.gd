extends CharacterBody3D

signal change_miles(new_text: String)

const PLAYER_FREQ = 2.0
const PLAYER_AMP = 0.08
var t_player = 0.0

# How fast the player moves in meters per second.
@onready var shader_camera = $"../HUD/ColorRect"
@export var speed = 4.0 #Te ponen
@export var gravity = 20
@export var teleport_limit_x = 1.0
@export var teleport_target_x = 79.24


var isSprint = false
var speedWalk = 4.0
var speedRun = 7.0

const WALKING = preload("res://Sonidos-Musica/PasosDelPersonajeJugable.ogg")
@onready var AudioFootStep = $AudioStreamPlayer3D
@onready var camera = $PlayerCamera
var original_camera_position = Vector3()
var balance_amount = 0.1
var balance_speed = 5.0
var time_passed = 0.0

var is_dead = false

func _ready():
	original_camera_position = camera.position

func _process(delta):
	if is_dead:
		camera.position.y -= 9.8 * delta
		return
	
	var direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction.z < 0:
		time_passed += delta
		var balance = sin(time_passed * balance_speed) * balance_amount
		camera.position.y = original_camera_position.y + balance
	else:
		camera.position.y = original_camera_position.y
		

func _physics_process(delta):
	if Input.is_action_pressed("Sprint"):
		if not $AgilitedSounds.playing:
			$AgilitedSounds.play()
		isSprint = true
		speed = speedRun
	else:
		if $AgilitedSounds.playing:
			$AgilitedSounds.stop()
			$SemiAgilitedSounds.play()
		isSprint = false
		speed = speedWalk

	var direction = Vector3.ZERO
	var target_velocity = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction = -transform.basis.x
	if direction.length() > 0:
		direction = direction.normalized()
		target_velocity = direction * speed
		
		if !AudioFootStep.playing:
			AudioFootStep.stream = WALKING
			AudioFootStep.play()
	
	if direction.length() == 0:
		if AudioFootStep.playing:
			AudioFootStep.stop()
		
	if not is_on_floor():
		target_velocity.y -=gravity*delta
	else:
		
		target_velocity.y = 0
	
	
	
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	
	if global_transform.origin.x <= teleport_limit_x:
		var material = shader_camera.material
		global_transform.origin.x = teleport_target_x
		emit_signal("change_miles", str(round(RandomNumberGenerator.new().randf_range(10,90))))
		material.set_shader_parameter("tape_wave_amount", 0.015)
		$Timer.start()

func _on_timer_timeout():
	var material = shader_camera.material
	material.set_shader_parameter("tape_wave_amount", 0.003)
