extends CanvasLayer

var time: float = 0.0
var minutes : int = 0
var seconds: int = 0
var msec: int = 0

func _process(delta) -> void:
	time += delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time,3600) / 60
	$"PlayerHUD#Minutes".text = "%02d:" % minutes
	$"PlayerHUD#Seconds".text = "%02d." % seconds
	$"PlayerHUD#Mseconds".text = "%03d" % msec
	
func stop() -> void:
	set_process(false)
	
func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]


func _on_timer_timeout():
	$MeshInstance2D/Timer.start()
	if $MeshInstance2D.visible:
		$MeshInstance2D.visible = false
	else :
		$MeshInstance2D.visible = true




