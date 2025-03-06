extends Node2D



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_menu_button_mouse_entered():
	$MenuButton/AudioStreamPlayer2D2.play()

func _on_restart_button_pressed():
	Functions.load_screen_to_scene("res://scenes/main.tscn")
	$VideoStreamPlayer/AudioStreamPlayer2D.stop()

func _on_restart_button_mouse_entered():
	$RestartButton/AudioStreamPlayer2D.play()
