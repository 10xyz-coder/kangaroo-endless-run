extends Node

func save():
	var save_dict = {
		"score": get_parent().totalScore,
		"high_score": get_parent().highScore,
		"upgrades": get_parent().upgrades,
		"coins": get_parent().coinsCollected
		}
	return save_dict

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	
	var data = save()
	save_game.store_line(to_json(data))
	
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		save_game.close()
		return # Error! We don't have a save to load.
	
	save_game.open("user://savegame.save", File.READ)
	
	var data = parse_json(save_game.get_line())
	
	get_parent().totalScore = data.score
	get_parent().coinsCollected = data.coins
	get_parent().highScore = data.high_score
	
	#for i in data.keys():
	#	if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
	#		continue
	#		
	#	get_parent().set(i, data[i])
	
	save_game.close()
