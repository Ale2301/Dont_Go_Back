extends Node3D

@onready var timer = $Timer
@onready var light = $"Farola#FarolaLight"

func _ready() -> void:
	randomize()

func _on_timer_timeout() -> void:
	var rand_amt := (randf())
	light.light_energy = rand_amt
	timer.start(rand_amt/13)
	if rand_amt < 0.50:
		light.light_energy = 80
	if rand_amt > 0.50:
		light.light_energy = 60
