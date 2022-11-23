extends KinematicBody2D



# The speed at which the player moves
export(int, 1, 200, 5) var speed:float = 10

var can_move:bool = true
var timer:Timer
# The position where the ladder will be placed
var ladder_position : Vector2 = Vector2(0,0)
var ladder_manager: Node2D
# The cell positions are 0 indexed, so the first cell is 0
var target_cell:int=-1
var current_cell:int=8
# Physics variables for the player movement
var velocity:Vector2 = Vector2(0,0)
var acceleration:Vector2 = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ladder_manager = $Ladders
	ladder_position=ladder_manager.position
	position.y=current_cell*Gamemanager.cell_size.y
	timer = $CooldownTimer
	# Generate the ladders to the height of the player
	generate_ladders()
func _process(_delta: float) -> void:
	current_cell= round(position.y/Gamemanager.cell_size.y)
	# Update velocity and acceleration
	velocity.y += acceleration.y * _delta
	velocity.y = clamp(velocity.y, -speed*2, speed*2)
	# Update position
	if target_cell!=-1:
		# If the player is moving to a cell, move to that cell
		if is_at_target_cell():
			# This signifies that the player has reached the target cell or hasn't moved
			target_cell=-1
			position.y=current_cell*Gamemanager.cell_size.y
			velocity.y=0
			acceleration.y=0
			can_move=true
		else:
			# Move to the target cell in the direction of the target cell
			position.y+=velocity.y*_delta

func _input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_up") and can_move:
		if target_cell==-1:
			target_cell=current_cell
		target_cell-=1
		move_to(target_cell)
		can_move=false
	elif event.is_action_pressed("ui_down") and can_move:
		if target_cell==-1:
			target_cell=current_cell
		target_cell+=1
		move_to(target_cell)
		can_move=false

# Moves the player to the target cell
func move_to(position_cell:int):
	# If we are moving out of bounds, don't move
	if position_cell<0:
		position_cell=0
	elif position_cell>=Gamemanager.cell_count:
		position_cell=Gamemanager.cell_count-1
	# Set the target cell
	target_cell=position_cell
	print_debug("Moving to cell "+str(target_cell))
	# Set the acceleration in the direction of the target cell and it makes it snappy
	acceleration.y=sign(target_cell-current_cell)*speed
	if target_cell>current_cell:
		velocity.y=speed
		ladder_manager.remove_ladder()
	elif target_cell<current_cell:
		velocity.y=-speed
		ladder_manager.add_ladder()
# Returns true if the player is at the target cell
func is_at_target_cell()->bool:
	# Check if the player is close enough to the target cell
	return current_cell==target_cell

func generate_ladders():
	# Generate the ladders to the height of the player
	var ladder_count:int=Gamemanager.cell_count-current_cell-1
	print_debug("Generating "+str(ladder_count)+" ladders")
	for i in range(ladder_count):
		ladder_manager.add_ladder()


func _on_Timer_timeout() -> void:
	can_move=true
