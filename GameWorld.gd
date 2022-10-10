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
	$Drill.position.y = $Player.position.y
	if Input.is_action_just_pressed("ui_home"):
		$Drill.activate(5)


func _on_CoinTimer_timeout():
	if gameSpeed == 0:
		return
	var Coin = coin.instance()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var coinHeight = rng.randf_range(0, 8)
	var position = (480 + (coinHeight-1)*-52) #rng.randf_range(35, 500)
	Coin.set_position(Vector2(545, position))
	add_child(Coin)
	if gameSpeed != 0:
		gameSpeed += (incrementor/(gameSpeed+0.01))*2
		print(gameSpeed)


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
	$WallTimer.wait_time *= 0.98
	if $WallTimer.wait_time < (11-$SettingsInterface/Body/DiffLevel.value)/4:
		$WallTimer.wait_time = (11-$SettingsInterface/Body/DiffLevel.value)/4
		$CoinTimer.wait_time = $WallTimer.wait_time
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
	elif -5 > ud:
		ud = -1
	else:
		ud = rng.randf_range(-8, 8)
		if (ud > 4/gameSpeed) and (gameSpeed > 2):
			ud = 3
		else:
			ud = 2
			num = rng.randf_range(3, 4)
			amount = clamp(amount, 1, 3)
		
	# Too laxy to document the rest :D
	
	if ud == 3:
		var removed
		if rng.randi_range(1, 2) == 1 and gameSpeed < 6:
			removed = [round(rng.randf_range(2, 5))]
			removed.append(removed[0]+1)
			removed.append(removed[1]+1)
		elif rng.randi_range(1, 2) == 1 and gameSpeed < 8:
			removed = [round(rng.randf_range(2, 6))] 
			removed.append(removed[0]+1)
		else:
			removed = [round(rng.randf_range(3, 7))]
		#var removePower = round(rng.randf_range(1, round(8/gameSpeed)+1))
		#print(str(removePower) + " And " + str(gameSpeed))
		for n in range(1, 9, 1):
			var Bar = bar.instance()
			var positionx = (503 + (n-1)*-52)
			Bar.set_position(Vector2(545, positionx))
			Bar.vein = amount
			Bar.id = n
			Bar.removed = removed
			add_child(Bar)
		print("spawned" + str(removed))
	else:
		for n in range(1, amount+1, 1):
			var Bar = bar.instance()
			var positionx = 0
			if ud == 1:
				positionx = (503 + (n-1)*-52)
			elif ud == -1:
				positionx = (59 + (n-1)*52)
			elif ud == 2:
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
	$WallTimer.wait_time = 3
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
	if not $Player.is_ladders_colliding:
		$Player.on_up_input()


func _on_DOWN_pressed():
	#Reduce Height
	if not $Player.is_ladders_colliding:
		$Player.on_down_input()
