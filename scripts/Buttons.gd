extends Control




func _on_play_button_pressed():
	Functions.load_screen_to_scene("res://scenes/main.tscn")
	$"../VideoStreamPlayer/AudioStreamPlayer2D".stop()


func _on_exit_button_pressed():
	get_tree().quit()


func _on_play_button_mouse_entered():
	$"Play button/AudioStreamPlayer2D2".play()


func _on_how_to_play_button_mouse_entered():
	$"HowToPlay Button/AudioStreamPlayer2D".play()


func _on_exit_button_mouse_entered():
	$"Exit Button/AudioStreamPlayer2D".play()
