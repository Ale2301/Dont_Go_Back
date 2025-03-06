extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var player = $Player
	var label = get_node("Signal 1/SignalText/SubViewport/Label")
	var label2 = get_node("Signal 5/SignalText/SubViewport/Label")
	player.connect("change_miles",Callable(label,"_on_change_miles"))
	player.connect("change_miles",Callable(label2,"_on_change_miles"))

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



