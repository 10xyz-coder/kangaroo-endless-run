extends Node2D

var rng = RandomNumberGenerator.new()

func _ready():
	# Initialise
	$AnimatedSprite.playing = true
	
func get_collected():
	$AnimatedSprite.visible = false
	$Particles2D.emitting = true
	#get_parent().compliment(4.0, 0)
	#get_parent().screen_shake(2.0, 0.5)
	yield(get_tree().create_timer(0.4), "timeout")
	queue_free()
	

func _physics_process(delta):
	# Move
	if get_parent().gameSpeed == 0:
		queue_free()
	position.x -= get_parent().gameSpeed


func _on_Area2D_area_entered(area):
	if area.is_in_group('player'):
		area.get_parent().score += round(get_parent().gameSpeed*45)
		get_parent().coinsCollected += 1
		get_collected()
