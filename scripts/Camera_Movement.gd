extends Camera3D
@export var rotation_speed = 40
var original_camera_rotation: Vector3



# Called when the node enters the scene tree for the first time.
func _ready():
	original_camera_rotation = rotation_degrees



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_camera_rotation(delta)
	

func handle_camera_rotation(delta):
	if Input.is_action_pressed("look_back"):
		rotation_degrees.y = original_camera_rotation.y - 180
	elif Input.is_action_pressed("look_right"):
		rotation_degrees.y = original_camera_rotation.y - 90
	elif Input.is_action_pressed("look_left"):
		rotation_degrees.y = original_camera_rotation.y + 90
	if Input.is_action_pressed("move_forward"):
		rotation_degrees = original_camera_rotation
