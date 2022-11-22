extends Node2D

var vein : int
var id : int
var removed : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.monitorable = true
	$Area2D.monitoring = true


func _physics_process(delta):
	# Move left by gamespeed
	
	if get_parent().gameSpeed == 0 or position.x < -32:
		queue_free()
	
	if id in removed:
		queue_free()
		
	position.x -= get_parent().gameSpeed
	
	


# Old Falling Down Code

func _on_Area2D_area_exited(area):
	pass
	#if area.is_in_group("ladder"):
		#get_parent().emit_signal("down")


func _on_Area2D_area_entered(area):
	if area.is_in_group("ladder"):
		$Timer.wait_time = 1.5  / (0.01+get_parent().gameSpeed)
		$Timer.start()
	if area.is_in_group("drill"):
		if area.on:
			get_parent().screen_shake(5.0, 0.5)
			get_parent().compliment(7.0, 1)
			#yield(get_tree().create_timer(0.4), "timeout")
			$Area2D.remove_from_group("danger")
			$Area2D.monitorable = false
			$Area2D.monitoring = false
			$AnimatedSprite.visible = false
			$Particles2D.emitting = true
			$deathTimer.start()


func _on_Timer_timeout():
	if id == 1:
		get_parent().emit_signal("down", vein)


func _on_deathTimer_timeout():
	queue_free()
