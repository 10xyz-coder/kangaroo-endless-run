extends Area2D

signal screen_exited
signal screen_entered

onready var box:Sprite=$Box

var velocity:Vector2=Vector2.ZERO setget set_velocity,get_velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Barricades")

func _process(delta: float) -> void:
	position.x+=velocity.x*delta

func get_size() -> Rect2:
	var size = Rect2()
	box= $Box
	size.size.x=box.get_rect().size.x*box.scale.x*scale.x
	size.size.y=box.get_rect().size.y*box.scale.y*scale.y
	return size

func set_velocity(vel:Vector2):
	velocity=vel

func get_velocity() -> Vector2:
	return velocity

func _on_VisibilityNotifier2D_screen_exited() -> void:
	emit_signal("screen_exited",self)

func _on_VisibilityNotifier2D_screen_entered() -> void:
	emit_signal("screen_entered",self)

func _on_Barricade_body_entered(body:Node) -> void:
	pass # Replace with function body.
