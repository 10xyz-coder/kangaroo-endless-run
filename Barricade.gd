extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	# Move left by gamespeed
	
	if get_parent().gameSpeed == 0 or position.x < -32:
		queue_free()
	position.x -= get_parent().gameSpeed


# Old Falling Down Code

func _on_Area2D_area_exited(area):
	pass
	#if area.is_in_group("ladder"):
		#get_parent().emit_signal("down")


func _on_Area2D_area_entered(area):
	pass
	if area.is_in_group("ladder"):
		$Timer.wait_time = 0.75  / (0.01+get_parent().gameSpeed)
		$Timer.start()


func _on_Timer_timeout():
	get_parent().emit_signal("down")
