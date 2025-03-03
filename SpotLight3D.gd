extends SpotLight3D

var original_light_rotation: Vector3
var mouse_sensitivity_horizontal = 0.01
var mouse_sensitivity_vertical = 0.01


func _physics_process(delta):
	if Input.is_action_pressed("look_back"):
		rotation_degrees.y = original_light_rotation.y - 180
	elif Input.is_action_pressed("look_right"):
		rotation_degrees.y = original_light_rotation.y - 90
	elif Input.is_action_pressed("look_left"):
		rotation_degrees.y = original_light_rotation.y + 90
	if Input.is_action_pressed("move_forward"):
		rotation_degrees = original_light_rotation

func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotate_y(deg_to_rad(- event.relative.x * mouse_sensitivity_horizontal))
			$LightRotation.rotate_x(deg_to_rad(- event.relative.y * mouse_sensitivity_vertical))
