extends Node2D
class_name LadderManager

export var ladder_scene: PackedScene
export var max_ladders: int = 9
export var num_of_ladders: int = 0
export var ladder_speed: float = .1

var ladders: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _generate_ladder() -> Ladder:
	var ladder = ladder_scene.instance()
	ladder.position = Vector2(0, num_of_ladders * Gamemanager.cell_size.y )
	ladder.name = "ladder" + str(num_of_ladders)
	ladder.ladder_id = num_of_ladders
	ladder.cell_position =num_of_ladders
	# Set the gravity scale to -1 to make the ladder stick to the player
	ladder.gravity=ladder_speed
	ladder.add_to_group("Ladders")
	return ladder

func generate_ladders(num_to_generate: int) -> void:
	for _i in range(num_to_generate):
		var ladder = _generate_ladder()
		num_of_ladders += 1
		ladders.append(ladder)
		add_child(ladder)

func add_ladder() -> void:
	if num_of_ladders < max_ladders:
		# Move ladders down by one cell
		for ladder in ladders:
			ladder.cell_position += 1
		var ladder = _generate_ladder()
		ladders.append(ladder)
		ladder.position = Vector2(0, 0)
		add_child(ladder)
		num_of_ladders += 1
	
func remove_ladder() -> void:
	if num_of_ladders > 0:
		var ladder = ladders.pop_back()
		remove_child(ladder)
		num_of_ladders -= 1
		move_ladders_up()
func move_ladders_down() -> void:
	for ladder in ladders:
		ladder.cell_position += 1
		ladder.position.y += Gamemanager.cell_size.y

func move_ladders_up() -> void:
	for ladder in ladders:
		ladder.cell_position -= 1

# Debugging input
# func _input(event: InputEvent) -> void:
# 	if event.is_action_pressed("ui_cancel"):
# 		add_ladder()
# 	if event.is_action_pressed("ui_accept"):
# 		remove_ladder()
