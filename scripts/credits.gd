extends Node2D


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("skip_credits"):
		get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
