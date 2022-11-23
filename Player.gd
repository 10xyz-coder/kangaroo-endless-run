extends KinematicBody2D

var score = 0
var heightX = 1
var is_falling = false
var is_ladders_colliding = false
signal Game_Over

onready var tween = get_node("Tween")

var collisionShape = preload("res://Physics/PlayerHitbox.tres")

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
		score += round(get_parent().gameSpeed*45)
		get_parent().coinsCollected += 1
		area.get_parent().get_collected()
		print_debug("Coin collected")
	if area.is_in_group('danger'):
		$Particles2D.emitting = true
		emit_signal("Game_Over")
		
func _physics_process(_delta):
	if get_parent().gameSpeed == 0:
		heightX = 1
		$Sprite.visible = false
		return
	$Sprite.visible = true
	$Sprite.speed_scale = get_parent().gameSpeed*0.6
	
	if not is_ladders_colliding:
		handle_input()
	
	heightX = clamp(heightX, 1,8)
	position.y = 503+(heightX-1)*-52.5#28.75	
	if heightX == 1:
		$Sprite.animation = 'run'
	else:
		$Sprite.animation = 'float'

func handle_input():
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

func on_up_input():
	if not is_falling:
		heightX += 1
	else:
		move_up()

func on_down_input():
	if not is_falling:
		heightX -= 1
	else:
		move_down()

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


func _on_Tween_tween_started(object, key):
	while get_node("Area2D").position >= Vector2(position.x, 503+(heightX-1)*-52.5):
		var shape = collisionShape.duplicate()
		shape.position = Vector2(position.x, position.y)
		get_node("Area2D").set_shape(shape)
		
		yield(get_tree().create_timer(0.05), "timeout")
		continue

func is_colliding(val:bool, obj) -> void:
	is_ladders_colliding=val
