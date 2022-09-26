extends KinematicBody2D

var score = 0
var heightX = 1
var is_falling = false

signal Game_Over

onready var tween = get_node("Tween")

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
		
	if area.is_in_group('danger'):
		pass
		emit_signal("Game_Over")
		
func _physics_process(delta):
	if get_parent().gameSpeed == 0:
		heightX = 1
		visible = false
		return
	$Sprite.speed_scale = get_parent().gameSpeed*0.6
	if not is_falling:
		if Input.is_action_just_released("ui_up"):
			heightX += 1
		if Input.is_action_just_released("ui_down"):
			heightX -= 1
	else:
		if Input.is_action_just_released("ui_up"):
			move_up()
			
		if Input.is_action_just_released("ui_down"):
			move_down()
	
	
	heightX = clamp(heightX, 1,8)
	position.y = 503+(heightX-1)*-52.5#28.75	
	if heightX == 1:
		$Sprite.animation = 'run'
	else:
		$Sprite.animation = 'float'
		
func move_up():
	var seeker = tween.tell()
	tween.reset_all()
	heightX += 1
	is_falling = true
	tween.interpolate_property(self, "position",
			Vector2(position.x, position.y), Vector2(position.x, 503+(heightX-1)*-52.5), 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.seek(seeker)
	
func move_down():
	var seeker = tween.tell()
	tween.reset_all()
	heightX -= 1
	is_falling = true
	tween.interpolate_property(self, "position",
			Vector2(position.x, position.y), Vector2(position.x, 503+(heightX-1)*-52.5), 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween.seek(seeker)
		

func reduce_height(power):
	heightX -= power
	heightX = clamp(heightX, 1, 8)
	tween.interpolate_property(self, "position",
			Vector2(position.x, position.y), Vector2(position.x, 503+(heightX-1)*-52.5), 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	is_falling = true
	tween.start()


func _on_Tween_tween_completed(object, key):
	is_falling = false
