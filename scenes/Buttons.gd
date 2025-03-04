extends Control




func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_play_button_mouse_entered():
	$"Play button/Hover".play()

func _on_how_to_play_button_mouse_entered():
	$"HowToPlay Button/Hover".play()


func _on_exit_button_mouse_entered():
	$"Exit Button/hover".play()

func _on_exit_button_pressed():
	get_tree().quit()


