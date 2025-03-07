extends Node
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var player = $Player
	var label = get_node("Sprites/SignalHandler/Signal 1/SignalText/SubViewport/Label")
	var label2 = get_node("Sprites/SignalHandler/Signal 5/SignalText/SubViewport/Label")
	player.connect("change_miles",Callable(label,"_on_change_miles"))
	player.connect("change_miles",Callable(label2,"_on_change_miles"))
	$HUD/InformativeEnemyText.text = "My car is out of fuel. I should probbably walk to the next station"

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



