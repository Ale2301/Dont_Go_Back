extends MeshInstance2D




func _on_timer_timeout():
	self.visible = false
	$Timer2.start()




func _on_timer_2_timeout():
	self.visible = true
	$Timer.start()
