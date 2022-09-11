extends Node2D

var rng = RandomNumberGenerator.new()

func _ready():
	# Initialise
	$AnimatedSprite.playing = true
	
func get_collected():
	queue_free()
	

func _physics_process(delta):
	# Move
	if get_parent().gameSpeed == 0:
		queue_free()
	position.x -= get_parent().gameSpeed
