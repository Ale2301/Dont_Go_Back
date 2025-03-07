extends StaticBody3D
@onready var player = get_node("../Player")
@onready var camera = player.get_node("PlayerCamera")
@onready var labelInfo = get_node("../HUD/InformativeEnemyText")


const ENEMY_DURATION = 3.0 
const NOT_LOOK_THRESHOLD = 3.0 
var TIMEBETWEENSPAWNS = 48
var CHANCETOSPAWN = 100
var TIMEBETWEENSOUNDS = 2
const SPAWN_OFFSET = 5.0 


var enemyTimer = ENEMY_DURATION
var timeNotLookedAt = 0.0
var isSpawned = false
var timePassed = 0.0
var enemyPaused = false
var isFirstTimeAppearing = true

func _ready():
	pass

func _physics_process(delta):
	var playerPosition = player.global_transform.origin
	timePassed += delta
	
	if enemyPaused:
		if not $EyeFloatSound.playing:
			$EyeFloatSound.play()
		var offset = -player.global_transform.basis.x
		offset.y = 0
		offset = offset.normalized() * SPAWN_OFFSET
		playerPosition += offset
		global_transform.origin = playerPosition
		var camera_forward = -camera.global_transform.basis.z.normalized()
		var to_enemy = (global_transform.origin - camera.global_transform.origin).normalized()
		var dot_value = camera_forward.dot(to_enemy)
		if dot_value > 0.1:
			enemyTimer -= delta
			print("Player looking at enemy. Time until kill: ", enemyTimer)
		else:
			timeNotLookedAt += delta
			print("Player not looking at enemy for: ", timeNotLookedAt, " seconds")
		
		if enemyTimer <= 0:
			print("Enemy kills the player")
			get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
		elif timeNotLookedAt >= NOT_LOOK_THRESHOLD:
			print("Enemy disappears because player did not look")
			restore_vars()
	
	elif not isSpawned:
		if timePassed >= TIMEBETWEENSPAWNS:
			print("Trying to spawn enemy in front...")
			if RandomNumberGenerator.new().randf_range(0,100) < CHANCETOSPAWN:
				TIMEBETWEENSPAWNS = 8
				CHANCETOSPAWN = 70
				TIMEBETWEENSOUNDS = 2
				print("Enemy spawned and started to follow")
				$EyeSpawnSound.play()
				isSpawned = true
				enemyPaused = true
				if isFirstTimeAppearing:
					labelInfo.text = "Flapping? That's an... Eye? I should probbably NOT MAKE EYE CONTACT"
					isFirstTimeAppearing = false
					TIMEBETWEENSPAWNS = 8
					CHANCETOSPAWN = 70
					TIMEBETWEENSOUNDS = 2
			else:
				print("Enemy did not spawn this time")
			timePassed = 0.0
	elif timePassed >= TIMEBETWEENSOUNDS and not enemyPaused:
		timePassed = 0.0

func restore_vars():
	enemyPaused = false
	enemyTimer = ENEMY_DURATION
	timeNotLookedAt = 0.0
	isSpawned = false
	timePassed = 0.0
	global_transform.origin = Vector3(9999, 9999, 0)
