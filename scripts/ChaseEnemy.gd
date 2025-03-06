extends CharacterBody3D
@onready var player = get_node("../Player")
# Called when the node enters the scene tree for the first time.
const TIMEBETWEENSPAWNS = 30 #seconds
const CHANCETOSPAWN = 50 #percent
const TIMEBETWEENSOUNDS = 0.4 #seconds
const CHASE_SPEED = 4.0
const ESCAPE_DISTANCE = 30
const SPAWN_OFFSET = 20
const COLLISION_THRESHOLD = 1.1
var isSpawned = false
var timePassed = 0.0
var spawn_position: Vector3
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not isSpawned:
		timePassed += 0.1
		if timePassed >= TIMEBETWEENSPAWNS:
			if RandomNumberGenerator.new().randf_range(0,100) < CHANCETOSPAWN:
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
		if player.global_transform.origin.distance_to(spawn_position) >= ESCAPE_DISTANCE:
			print("Player escaped from ChaseEnemy")
			isSpawned = false
			global_transform.origin = Vector3(9999,9999,0)
			timePassed = 0.0
	if global_transform.origin.distance_to(player.global_transform.origin) < COLLISION_THRESHOLD:
		get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
