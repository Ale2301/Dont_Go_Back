extends StaticBody3D
@onready var player = get_node("../Player")
@onready var camera = player.get_node("PlayerCamera")

# Parámetros
const ENEMY_DURATION = 3.0        # Tiempo (en segundos) antes de que el enemigo mate al jugador si es observado
const NOT_LOOK_THRESHOLD = 3.0    # Tiempo que debe transcurrir sin ser observado para que el enemigo desaparezca
const TIMEBETWEENSPAWNS = 15      # Intervalo entre spawns (en segundos)
const CHANCETOSPAWN = 0           # Porcentaje de chance para iniciar la persecución (ajusta según balance)
const TIMEBETWEENSOUNDS = 3       # (Si se necesita reproducir un sonido, por ejemplo)
const SPAWN_OFFSET = 5.0          # Distancia del spawn al jugador (siempre DElante)

# Variables de control
var enemyTimer = ENEMY_DURATION
var timeNotLookedAt = 0.0
var isSpawned = false
var timePassed = 0.0
var enemyPaused = false   # Indica que el enemigo ya se spawneó y está activo

func _ready():
	# Inicialmente el enemigo no está activo
	pass

func _physics_process(delta):
	var playerPosition = player.global_transform.origin
	timePassed += delta
	
	if enemyPaused:
		# Posicionamos al enemigo en frente del jugador:
		# Usamos el vector -Z del jugador (su "frente") para spawnear delante.
		var offset = -player.global_transform.basis.x
		offset.y = 0  # Nos aseguramos de no desplazar en Y
		offset = offset.normalized() * SPAWN_OFFSET
		playerPosition += offset
		global_transform.origin = playerPosition
		
		# Hacemos que el enemigo mire hacia el jugador.
		look_at(player.global_transform.origin, Vector3.UP)
		
		# --- Lógica de detección invertida ---
		# Calculamos si el jugador está mirando al enemigo.
		# Para ello, obtenemos la dirección en la que mira la cámara.
		var camera_forward = -camera.global_transform.basis.z.normalized()
		var to_enemy = (global_transform.origin - camera.global_transform.origin).normalized()
		var dot_value = camera_forward.dot(to_enemy)
		
		# En este enemigo, si el jugador lo mira (dot_value alto), se reduce el tiempo de seguridad.
		if dot_value > 0.1:
			# El jugador está mirando: reducimos el contador (al llegar a 0, el enemigo mata al jugador).
			enemyTimer -= delta
			print("Player looking at enemy. Time until kill: ", enemyTimer)
		else:
			# El jugador no mira: se acumula el tiempo de no ser observado.
			timeNotLookedAt += delta
			print("Player not looking at enemy for: ", timeNotLookedAt, " seconds")
		
		# Si el jugador mira al enemigo por tiempo suficiente (enemyTimer se agota)...
		if enemyTimer <= 0:
			print("Enemy kills the player")
			get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
		# Si el jugador no lo ve por el tiempo requerido, el enemigo desaparece.
		elif timeNotLookedAt >= NOT_LOOK_THRESHOLD:
			print("Enemy disappears because player did not look")
			restore_vars()
	
	# Control de spawn
	elif not isSpawned:
		if timePassed >= TIMEBETWEENSPAWNS:
			print("Trying to spawn enemy in front...")
			if RandomNumberGenerator.new().randf_range(0,100) < CHANCETOSPAWN:
				print("Enemy spawned and started to follow")
				isSpawned = true
				enemyPaused = true
			else:
				print("Enemy did not spawn this time")
			timePassed = 0.0
	elif timePassed >= TIMEBETWEENSOUNDS and not enemyPaused:
		# (Si deseas agregar algún sonido o fase de spawn similar al stalker, este bloque es opcional)
		timePassed = 0.0

func restore_vars():
	# Reinicia las variables para que el enemigo desaparezca (o se re-spawnee en otro ciclo)
	enemyPaused = false
	enemyTimer = ENEMY_DURATION
	timeNotLookedAt = 0.0
	isSpawned = false
	timePassed = 0.0
	global_transform.origin = Vector3(9999, 9999, 0)
