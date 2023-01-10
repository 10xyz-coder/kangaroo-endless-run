extends Node2D

var currentTimer = 0.0


func _ready():
	load_game()
	currentTimer = 0.0
	
func _process(delta):
	$Title.rect_rotation = (sin(currentTimer*380)*5+0)

func _on_Play_pressed():
	get_tree().change_scene("res://Scenes/GameWorld.tscn")
	

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		save_game.close()
		return # Error! We don't have a save to load.
	
	save_game.open("user://savegame.save", File.READ)
	
	var data = parse_json(save_game.get_line())
	
	$highscore.text = "Highscore : " + str(data.high_score)
	
	save_game.close()


#func _on_Shop_pressed():
#	get_tree().change_scene("res://Shop.tscn")


func _on_Timer_timeout():
	currentTimer += (0.05)
