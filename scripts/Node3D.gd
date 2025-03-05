extends Node3D

@onready var flashlight = $FlashLight
@onready var timer = $TimerFlashlight

var original_light_rotation: Vector3
var mouse_sensitivity_horizontal = 0.01
var mouse_sensitivity_vertical = 0.01


func _ready() -> void:
	randomize()

func _on_timer_timeout() -> void:
	var rand_amt := (randf())
	flashlight.light_energy = rand_amt
	timer.start(rand_amt/7)
	if rand_amt < 0.50:
		flashlight.light_energy = 10
	if rand_amt > 0.50:
		flashlight.light_energy = 12


func _physics_process(delta):
	if Input.is_action_pressed("look_back"):
		rotation_degrees.y = original_light_rotation.y - 180
	elif Input.is_action_pressed("look_right"):
		rotation_degrees.y = original_light_rotation.y - 90
	elif Input.is_action_pressed("look_left"):
		rotation_degrees.y = original_light_rotation.y + 90
	if Input.is_action_just_pressed("move_forward"):
		rotation_degrees = original_light_rotation

func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity_horizontal))
			rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity_vertical))



func _on_timer_flashlight_timeout() -> void:
	var rand_amt := (randf())
	flashlight.light_energy = rand_amt
	timer.start(rand_amt/7)
	if rand_amt < 0.50:
		flashlight.light_energy = 60
	if rand_amt > 0.50:
		flashlight.light_energy = 40
