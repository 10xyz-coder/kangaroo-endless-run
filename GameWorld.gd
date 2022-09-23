extends Node2D

var coin = preload("res://coin.tscn")
var bar = preload("res://Barricade.tscn")
var gameSpeed = 1
var downPower = 0
export (int) var incrementor = 0.05

signal down(vein)


func _ready():
	$GameOver.visible = false

func _process(delta):
	$Score.text = str($Player.score)


func _on_CoinTimer_timeout():
	if gameSpeed == 0:
		return
	var Coin = coin.instance()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var coinHeight = rng.randf_range(0, 8)
	var position = (503 + (coinHeight-1)*-52) #rng.randf_range(35, 500)
	Coin.set_position(Vector2(545, position))
	add_child(Coin)
	if gameSpeed != 0:
		gameSpeed += incrementor


func _on_Settings_pressed():
	if $SettingsInterface.visible:
		$SettingsInterface.visible = false
		incrementor = $SettingsInterface/Body/DiffLevel.value*0.05
	else:
		$SettingsInterface.visible = true


func _on_starter_timeout():
	$WallTimer.start()


func _on_WallTimer_timeout():
	
	# All of this just to generate some walls
	
	if gameSpeed == 0:
		return
	var rng = RandomNumberGenerator.new()
	
	rng.randomize()
	var amount = rng.randf_range(2, 6)
	
	rng.randomize()
	var ud = rng.randf_range(-8, 8)
	var num
	if ud > 0:
		ud = 1
	elif -6 > ud:
		ud = -1
	else: 
		ud = 2
		num = rng.randf_range(3, 4)
		amount = clamp(amount, 1, 3)
		
	# Too laxy to document the rest :D
	
	
	for n in range(1, amount+1, 1):
		var Bar = bar.instance()
		var positionx = 0
		if ud == 1:
			positionx = (503 + (n-1)*-52)
		elif ud == -1:
			positionx = (59 + (n-1)*52)
		else:
			positionx = 59 + ((num * 52) + (n-1)*52)
		Bar.set_position(Vector2(545, positionx))
		Bar.vein = amount
		Bar.id = n
		add_child(Bar)


func _on_Player_Game_Over():
	# Game Over
	$GameOver.visible = true
	$GameOver/Background/Score.text = "FINAL SCORE : " + str($Player.score)
	gameSpeed = 0


func _on_GameOver_replay():
	# Replaying 
	gameSpeed = 1
	incrementor = 0.05
	$GameOver.visible = false
	$Player.score = 0
	$Player.visible = true
	$SettingsInterface/Body/DiffLevel.value = 1


func _on_GameWorld_down(vein):
	# Make the Stairs go Down
	#if downPower == 0:
		#$HeightReduce.wait_time = 0.05  / (0.01+gameSpeed)
	downPower = vein
	#$HeightReduce.start()
	$Player.reduce_height(downPower)
	#downPower = 0



func _on_UP_pressed():
	# Increase Height
	if not $Player.is_falling:
		$Player.heightX += 1


func _on_DOWN_pressed():
	#Reduce Height
	if not $Player.is_falling:
		$Player.heightX -= 1
