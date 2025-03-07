extends Node2D




func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_texture_button_mouse_entered():
	$TextureButton/AudioStreamPlayer2D.play()
	
