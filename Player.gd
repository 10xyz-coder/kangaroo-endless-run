extends KinematicBody2D

var score = 0
var heightX = 1

signal Game_Over

func _ready():
	$ScoreTimer.start()
	$Sprite.playing = true

func _on_ScoreTimer_timeout():
	# Making the game difficult as time grows
	if get_parent().gameSpeed == 0:
		return
	score += get_parent().incrementor*20+1


func _on_Area2D_area_entered(area):
	if area.is_in_group('coin'):
		score += round(get_parent().gameSpeed*15)
		area.get_parent().get_collected()
	elif area.is_in_group('danger'):
		emit_signal("Game_Over")
		
func _physics_process(delta):
	if get_parent().gameSpeed == 0:
		heightX = 1
		visible = false
		return
	$Sprite.speed_scale = get_parent().gameSpeed*0.6
	if Input.is_action_just_released("ui_up"):
		heightX += 1
	if Input.is_action_just_released("ui_down"):
		heightX -= 1
	heightX = clamp(heightX, 1,12)
	position.y = 503+(heightX-1)*-37	
	if heightX == 1:
		$Sprite.animation = 'run'
	else:
		$Sprite.animation = 'float'
		

