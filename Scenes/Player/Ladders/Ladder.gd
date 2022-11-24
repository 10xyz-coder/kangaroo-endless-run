extends KinematicBody2D
class_name Ladder

signal got_hit

var ladder_id: int
var cell_position:int
var is_hit=false

# The speed at which the ladder moves
export(float, .1, 10, .1) var gravity: float = .5
export var ladder_type:bool=false

# Physics variables for the player movement
var velocity:Vector2 = Vector2(0,0)
var acceleration:Vector2 = Vector2(0,0)

# For the animation
var sprite=Sprite
var animation_player:AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite= $Ladder
	animation_player=$AnimationPlayer

func _process(_delta: float) -> void:
	if ladder_type:
		sprite.frame_coords.y=1
	else:
		sprite.frame_coords.y=0
	
func _physics_process(delta: float) -> void:
	var curr= int(round(position.y/Gamemanager.cell_size.y))
	if cell_position==curr:
		velocity.y=0
	else:
		velocity.y = gravity
	var collision=move_and_collide(velocity*delta)
	if collision:
		velocity=Vector2(0,0)
	
	