extends StaticBody3D

const TIMEBETWEENSPAWNS = 3 #seconds
const CHANCETOSPAWN = 70 #percent
const CHANCETOPHASE = 20 #percent. Chance to phase is calculated after the laugh sound
const TIMEBETWEENSOUNDS = 3 #seconds
var isSpawned = false
var timePassed = 0
var placeWhereEnemySpawned = 0 # 0 = undefined, 1 = behind, 2 = right, 3 = left
var stalkerPaused = false #After he spawns, every stalker-script is paused (Except the kill counter)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	timePassed += 0.01
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
				stalkerPaused = true
				#Spawn stalker logic
			else:
				print("Stalker stills follow, far away") #laugh close sound
			timePassed = 0
