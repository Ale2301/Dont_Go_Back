extends StaticBody3D
@onready var player = get_node("../Player")
@onready var camera = player.get_node("../Player/PlayerCamera")
@onready var shader_camera = $"../HUD/ColorRect"

const STALKER_DURATION = 5.0  # Secnds before Stalker kills player
const LOOK_THRESHOLD = 3.0    # Time before stalker dissapears after looking at him
const TIMEBETWEENSPAWNS = 20 #seconds
const CHANCETOSPAWN = 40 #percent
const CHANCETOPHASE = 70 #percent. Chance to phase is calculated after the laugh sound
const TIMEBETWEENSOUNDS = 8 #seconds
const SPAWN_OFFSET = 5.0  # Distance from stalker to player
var stalkerTimer = STALKER_DURATION
var timeLookedAt = 0.0
var isSpawned = false
var timePassed = 0
var placeWhereEnemySpawned = 0 # 0 = undefined, 1 = behind, 2 = right, 3 = left
var stalkerPaused = false #After he spawns, every stalker-script is paused (Except the kill counter)
var isFirstTimeAppearing = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var material = shader_camera.material
	var playerPosition = player.global_transform.origin
	timePassed += 0.01
	if (stalkerPaused):
		if not $"../Player/HearthSound".playing:
			$"../Player/HearthSound".play()
		match placeWhereEnemySpawned:
			1:
				var offset = player.transform.basis.x
				offset.y = 0
				offset = offset.normalized() * SPAWN_OFFSET
				playerPosition += offset
				if material is ShaderMaterial:
					material.set_shader_parameter("tape_wave_amount", 0.025)
			2:
				var offset = player.transform.basis.z
				offset.y = 0
				offset = offset.normalized() * SPAWN_OFFSET
				playerPosition += offset
				if material is ShaderMaterial:
					material.set_shader_parameter("tape_wave_amount", 0.025)
			3:
				var offset = -player.transform.basis.z
				offset.y = 0
				offset = offset.normalized() * SPAWN_OFFSET
				playerPosition += offset
				if material is ShaderMaterial:
					material.set_shader_parameter("tape_wave_amount", 0.025)
		global_transform.origin = playerPosition
		look_at(player.global_transform.origin)
		self.rotate_object_local(Vector3.UP,PI)
		var camera_forward = -camera.global_transform.basis.z.normalized()
		var to_stalker = (global_transform.origin - camera.global_transform.origin).normalized()
		var dot_value = camera_forward.dot(to_stalker)
		if dot_value > 0.1:
			print("Player looking at stalker. Looked for: ",timeLookedAt)
			timeLookedAt += 0.01
		else:
			stalkerTimer -= 0.01
			print("Time remaining for death: ",stalkerTimer)
		if timeLookedAt >= LOOK_THRESHOLD:
			material.set_shader_parameter("tape_wave_amount", 0.003)
			print ("Stalker dissapears..")
			restore_vars()
		elif stalkerTimer <= 0:
			print ("Stalker kills the player")
			get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
	if (not isSpawned):
		if (timePassed > TIMEBETWEENSPAWNS):
			print ("Trying to spawn stalker..")
			if (RandomNumberGenerator.new().randf_range(0,100) < CHANCETOSPAWN):
				print("Stalker started the follow")
				isSpawned = true
			else:
				print ("Stalker is not following")
			timePassed = 0
	else:
		if (timePassed > TIMEBETWEENSOUNDS && not stalkerPaused):
			if (RandomNumberGenerator.new().randf_range(0,100) < CHANCETOPHASE):
				print("Stalker Reached the player") #Laugh far away sound
				placeWhereEnemySpawned = int(RandomNumberGenerator.new().randf_range(1,4))
				print(placeWhereEnemySpawned)
				stalkerPaused = true
				#Spawn stalker logic
			else:
				print("Stalker stills follow, far away") #laugh close sound
			timePassed = 0


func restore_vars():
	stalkerPaused = false
	stalkerTimer = STALKER_DURATION
	timeLookedAt = 0.0
	isSpawned = false
	timePassed = 0
	placeWhereEnemySpawned = 0
	global_transform.origin = Vector3(9999,9999,0)
