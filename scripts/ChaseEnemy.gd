extends CharacterBody3D
@onready var player = get_node("../Player")
@onready var shader_camera = $"../HUD/ColorRect"
@onready var labelInfo = get_node("../HUD/InformativeEnemyText")
# Called when the node enters the scene tree for the first time.
var TIMEBETWEENSPAWNS = 34 #seconds
var CHANCETOSPAWN = 100 #percent
var TIMEBETWEENSOUNDS = 0.4 #seconds
const CHASE_SPEED = 8.0
const ESCAPE_DISTANCE = 45
const SPAWN_OFFSET = 20
const COLLISION_THRESHOLD = 1.1
var isSpawned = false
var timePassed = 0.0
var spawn_position: Vector3
var isFirstTimeAppearing = true

var proximity_value = 0.0
var treshold = 5.0
var max_proximity_value = 0.099
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):
	var distance = $".".position.distance_to(player.position)
	var material = shader_camera.material
	
	timePassed += 0.01
	if not isSpawned:
		if timePassed >= TIMEBETWEENSPAWNS:
			if RandomNumberGenerator.new().randf_range(0,100) < CHANCETOSPAWN:
				if isFirstTimeAppearing:
					labelInfo.text = "It's running! But not so fast. Maybe I can OUTRUN it?"
					isFirstTimeAppearing = false
					TIMEBETWEENSPAWNS = 30 #seconds
					CHANCETOSPAWN = 50 #percent
					TIMEBETWEENSOUNDS = 0.4 #seconds
				print("ChaseEnemy spawned")
				isSpawned = true
				var player_transform = player.global_transform
				spawn_position = player_transform.origin + player_transform.basis.x.normalized() * SPAWN_OFFSET
				global_transform.origin = spawn_position
				look_at(player_transform.origin, Vector3.UP)
			timePassed = 0.0
	else:
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * CHASE_SPEED
		move_and_slide()
		if not $ChaseEnemySteps.playing:
			$ChaseEnemySteps.play()
		if (player.global_transform.origin.distance_to(spawn_position) >= ESCAPE_DISTANCE) || (player.global_transform.origin.x > global_transform.origin.x):
			labelInfo.text = ""
			print("Player escaped from ChaseEnemy")
			material.set_shader_parameter("tape_wave_amount", 0.003)
			isSpawned = false
			global_transform.origin = Vector3(9999,9999,0)
			timePassed = 0.0
	if global_transform.origin.distance_to(player.global_transform.origin) < COLLISION_THRESHOLD:
		get_tree().change_scene_to_file("res://scenes/deathcinematic.tscn")
		
	if isSpawned:
		if distance < treshold:
				proximity_value += (treshold - distance) / treshold * delta
				proximity_value = clamp(proximity_value, 0.0, max_proximity_value)
				if material is ShaderMaterial:
					material.set_shader_parameter("tape_wave_amount", proximity_value)
		else:
			proximity_value -= delta * 0.5
			proximity_value = clamp(proximity_value, 0.0, max_proximity_value)
						
			if material is ShaderMaterial:
				material.set_shader_parameter("tape_wave_amount", proximity_value)
