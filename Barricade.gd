extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	# Move left by gamespeed
	
	if get_parent().gameSpeed == 0:
		queue_free()
	position.x -= get_parent().gameSpeed


# Old Falling Down Code

func _on_Area2D_area_exited(area):
	if area.is_in_group("ladder"):
		get_parent().emit_signal("down")
