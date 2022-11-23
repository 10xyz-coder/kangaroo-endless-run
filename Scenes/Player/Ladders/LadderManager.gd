extends Node2D

export var ladder_scene: PackedScene
export var max_ladders: int = 9
export var num_of_ladders: int = 0

var top_ladder: Node2D

# Debug stuff for now
var ladders=[]
var ladders_mutex:bool=false
var command_queue=[]
# The ladders are a linked list, so we need to keep track of the first since -
# we will pop and push from the top of the list.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_ladders = Gamemanager.cell_count - 1
	_generate_ladders(8)
func _process(delta: float) -> void:
	

# Debugging
# func _input(event: InputEvent) -> void:
# 	if event.is_action_pressed("ui_up"):
# 		# Add a ladder to the scene
# 		add_ladder()
# 	elif event.is_action_pressed("ui_down"):
# 		# Remove a ladder from the scene
# 		remove_ladder()
	
# Generates n ladders at the ladder spawn point and at an offset of 1 cell
func _generate_ladders(num: int):
	# Generate the ladders and add them to the scene
	for i in range(num):
		var ladder = _generate_ladder(i)
		if top_ladder == null:
			# This is the first ladder
			top_ladder = ladder
			top_ladder.ladder_type=true
		else:
			# This is not the first ladder
			ladder.set_next(top_ladder)
			top_ladder = ladder
		ladders.append(ladder)
		add_child(ladder)
		num_of_ladders += 1

# Generates a ladder at the index. Each ladder has a name of the form "LadderX" where X is the index
func _generate_ladder(index: int) -> Node2D:
	var ladder:Ladder = ladder_scene.instance()
	# Calculate the size of the ladder
	var ladder_size = ladder.get_size().size
	ladder.position = Vector2(0, ladder_size.y * index)
	ladder.name = "ladder" + str(index)
	ladder.ladder_id = index
	ladder.connect("got_hit", self, "_on_ladder_got_hit")
	return ladder

func _genererate_ladders_from_list(ladder_list: Array):
	for i in range(ladder_list.size()):
		var ladder = _generate_ladder(ladder_list[i])
		if top_ladder == null:
			# This is the first ladder
			top_ladder = ladder
			top_ladder.ladder_type=true
		else:
			# This is not the first ladder
			ladder.set_next(top_ladder)
			top_ladder = ladder
		add_child(ladder)
		num_of_ladders += 1

# Adds a ladder to the scene
func add_ladder(ladder_id: int = 0):
	# Move ladders down then add a new one at the top
	command_queue.append("add")

# Removes a ladder from the scene
func remove_ladder(ladder_id: int = 0):
	# Remove the top ladder and move the rest up
	command_queue.append(["remove", ladders[ladder_id]])

func reset_ladders():
	command_queue.append("reset")

func _remove_ladder(ladder_id: int = 0):
	# Remove the top ladder and move the rest up
	if num_of_ladders > 0:
		var ladder=ladders.pop_at(ladder_id)
		num_of_ladders -= 1
		if num_of_ladders > 0:
			move_ladders_up(ladder_id)
		ladder.queue_free()

func _erase_ladder(ladder: Ladder):
	# Remove the top ladder and move the rest up
	if num_of_ladders > 0:
		ladders.erase(ladder)
		num_of_ladders -= 1
		if num_of_ladders > 0:
			move_ladders_up(ladder.ladder_id)
		ladder.queue_free()

func _add_ladder():
	# Move ladders down then add a new one at the top
	if num_of_ladders < max_ladders:
		# Move all the ladders down
		move_ladders_down()
		# Add a new ladder at the top
		var ladder = _generate_ladder(0)
		ladders.append(ladder)
		num_of_ladders += 1
		add_child(ladder)

func _reset_ladders():
	# Remove all the ladders
	for ladder in ladders:
		remove_child(ladder)
		ladder.queue_free()
	ladders=[]
	num_of_ladders=0

# Moves all the ladders down by one cell unless there is a gap in the middle
# If there is a gap, then the the bottom ladders move up to fill the gap
func move_ladders_up(index: int = 0):
	# Move the ladders up
	for i in range(index, num_of_ladders):
		ladders[i].position.y -= ladders[i].get_size().size.y
		ladders[i].ladder_id -= 1
		ladders[i].name = "ladder" + str(ladders[i].ladder_id)

func move_ladders_down(index: int = 0):
	# Move the ladders down
	for i in range(index, num_of_ladders):
		ladders[i].position.y += ladders[i].get_size().size.y
		ladders[i].ladder_id += 1
		ladders[i].name = "ladder" + str(ladders[i].ladder_id)

func _on_ladder_got_hit(ladder: Ladder):
	# Remove the ladder from the scene
