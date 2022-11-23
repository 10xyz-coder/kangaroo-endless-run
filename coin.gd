extends Node2D

var rng = RandomNumberGenerator.new()
var game_world: Node2D
var music_files=[
	"res://Assets/Audio/collect_coins.mp3"
]
func _ready():
	# Initialise
	$AnimatedSprite.playing = true
	
func get_collected():
	$AnimatedSprite.visible = false
	$Particles2D.emitting = true
	game_world.audio_player_sfx.stream = load(music_files[0])
	game_world.audio_player_sfx.play()
	#get_parent().compliment(4.0, 0)
	#get_parent().screen_shake(2.0, 0.5)
	yield(get_tree().create_timer(0.4), "timeout")
	queue_free()
	

func _physics_process(delta):
	# Move
	if get_parent().gameSpeed == 0:
		queue_free()
	position.x -= get_parent().gameSpeed
