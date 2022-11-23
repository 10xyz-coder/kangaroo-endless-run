extends Node2D

var coin = preload("res://coin.tscn")
var bar = preload("res://Barricade.tscn")
var drill_object = preload("res://Drill.tscn")
var gameSpeed = 1
var downPower = 0
var totalScore = 0
var highScore = 0
var totalDrill = 0
var upgrades = {}
var coinsCollected = 0
var shake_amount = 0.0
var shake_power = 0.0
var compliments = ["Perfect", "Superb", "Wondeful", "Mesmerising"]
var betterCompliments = ["Perfect!", "Superb!", "Wondeful!", "Mesmerising!", "Brilliant!", "Lovely!", "Magical!", "Excellent!"]
var audio_player_sfx: AudioStreamPlayer

onready var camera = get_node("Camera2D")
var incrementor = 0.5
var coin_label: Label
signal down(vein)


func _ready():
	$GameOver.visible = false
	totalScore = 0
	audio_player_sfx = $SoundFX
	$Compliments.visible = false
	$GameSaver.load_game()
	camera.set_offset(Vector2(0, 0))
	coin_label = $Coins
	coinsCollected = 0

func _process(delta):
	$Score.text = str($Player.score)
	coin_label.text = str(coinsCollected)
	if shake_amount > 0.1:
		camera.set_offset(Vector2(rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount ))
	if shake_power > 0.1:
		$Compliments.set_position(Vector2(rand_range(-1.0, 1.0) * shake_power + 235, rand_range(-1.0, 1.0) * shake_power + 26 ))
	
#	$Drill.position.y = $Player.position.y
#	if Input.is_action_just_pressed("ui_home"):
#		$Drill.activate(5)

func compliment(power, type):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	shake_power = power
	var rand_compliment
	if type == 0:
		rand_compliment = compliments[randi() % compliments.size()]
	else:
		rand_compliment = betterCompliments[randi() % betterCompliments.size()]
	$Compliments.text = rand_compliment
	if rng.randi_range(1, 3) == 1:
		shake_power += 2.0
		$Compliments.uppercase = true
		$Player.score += incrementor* 100
	else:
		$Compliments.uppercase = false
	$Compliments.visible = true
	yield(get_tree().create_timer(1.2), "timeout")
	$Compliments.visible = false
	shake_power = 0.0

func screen_shake(power, time):
	shake_amount = power
	yield(get_tree().create_timer(time), "timeout")
	shake_amount = 0.0

func _on_CoinTimer_timeout():
	if gameSpeed == 0:
		return
	var Coin = coin.instance()
	Coin.game_world = self
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var coinHeight = rng.randf_range(0, 8)
	var position = (503 + (coinHeight-1)*-52) #rng.randf_range(35, 500)
	Coin.set_position(Vector2(545, position))
	add_child(Coin)
	if gameSpeed != 0:
		gameSpeed += (incrementor/(gameSpeed+0.01))*1
	


func _on_starter_timeout():
	$WallTimer.start()


func _on_WallTimer_timeout():
	
	# All of this just to generate some walls
	$WallTimer.wait_time *= 0.98
	$CoinTimer.wait_time = $WallTimer.wait_time
	if $WallTimer.wait_time < (11-8)/1.5 - 0.1:
		$WallTimer.wait_time = (11-8)/1.5 - 0.1
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
	elif (clamp((floor(-10000/$Player.score+1)), -10, 0)) < ud:
		ud = -1
	else:
		ud = rng.randf_range(0, 8)
		print(1500/$Player.score+1)
		if (ud > floor(1500/$Player.score+1)) and ($Player.score > 400):
			ud = 3
		else:
			ud = 2
			num = rng.randf_range(3, 4)
			amount = clamp(amount, 1, 3)
		
	# Too laxy to document the rest :D
	
	if ud == 3:
		var removed
		var drill = 30
		if rng.randi_range(1, 2) == 1 and $Player.score < 4000:
			removed = [round(rng.randf_range(2, 5))]
			removed.append(round(rng.randf_range(2, 6)))
			removed.append(round(rng.randf_range(2, 7)))
			#removed.append(removed[0]+1)
			#removed.append(removed[1]+1)
		elif rng.randi_range(1, 2) == 1 and $Player.score < 7000:
			removed = [round(rng.randf_range(2, 6))] 
			removed.append(round(rng.randf_range(2, 7)))
			#removed.append(removed[0]+1)
		else:
			removed = [round(rng.randf_range(3, 7))]
		#var removePower = round(rng.randf_range(1, round(8/gameSpeed)+1))
		#print(str(removePower) + " And " + str(gameSpeed))
		if (rng.randi_range(1, 6)) == 1 or ($Player.score > 1500 and totalDrill == 0):
			drill = removed[0]
			totalDrill += 1
		
		for n in range(1, 9, 1):
			var Bar = bar.instance()
			var positionx = (503 + (n-1)*-52)
			Bar.set_position(Vector2(545, positionx))
			Bar.vein = amount
			Bar.id = n
			Bar.removed = removed
			add_child(Bar)
			if n == drill:
				var Drill = drill_object.instance()
				Drill.set_position(Vector2(545, positionx))
				add_child(Drill)
			elif n in removed and drill == 30:
				if rng.randi_range(1, 3) == 1:
					print("coined")
					var Coin = coin.instance()
					var position = (503 + (removed[0]-1)*-52)
					Coin.set_position(Vector2(545, position))
					add_child(Coin)
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
	gameSpeed = 0
	if $Player.score > highScore:
		highScore = $Player.score
	screen_shake(20.0, 0.7)
	yield(get_tree().create_timer(2), "timeout")
	camera.set_offset(Vector2(0,0))
	$GameOver.visible = true
	$GameOver/Background/Score.text = "FINAL SCORE : " + str($Player.score)
	$GameOver/Background/highscore.text = "HIGHEST SCORE : " + str(highScore)
	totalScore += $Player.score
	$GameSaver.save_game()
	coinsCollected = 0


func _on_GameOver_replay():
	# Replaying 
	gameSpeed = 1
	incrementor = 0.5
	totalDrill = 0
	$WallTimer.wait_time = 3
	$CoinTimer.wait_time = 3
	$GameOver.visible = false
	$Player.score = 0
	$Player.visible = true
	camera.set_offset(Vector2(0, 0))
	coinsCollected = 0

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
