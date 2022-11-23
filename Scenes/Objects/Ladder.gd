extends Area2D
class_name Ladder

signal got_hit

var ladder_id: int
var cell_position:int
var next_ladder: Node2D setget set_next, get_next
var is_hit=false
export var ladder_type:bool=false
var sprite=Sprite
var animation_player:AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite= $Ladder
	animation_player=$AnimationPlayer
	add_to_group("Ladders")

func _process(delta: float) -> void:
	if ladder_type:
		sprite.frame_coords.y=1
	else:
		sprite.frame_coords.y=0


# Getters and setters

func get_size() -> Rect2:
	var rect2=Rect2()
	rect2.size=$Ladder.get_rect().size
	rect2.size.y=rect2.size.y*$Ladder.scale.y*scale.y
	rect2.size.x=rect2.size.x*$Ladder.scale.x*scale.x
	return rect2

func set_next(ladder: Node2D) -> void:
	next_ladder=ladder

func get_next() -> Node2D:
	return next_ladder


func _on_Ladder_area_shape_entered(_area_rid:RID, area:Area2D, _area_shape_index:int, _local_shape_index:int) -> void:
	if area.is_in_group("Barricades") and !is_hit:
		emit_signal("got_hit", self)
		is_hit=true