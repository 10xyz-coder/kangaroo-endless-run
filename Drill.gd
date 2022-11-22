extends Area2D


var active = false
var on = false


# Called when the node enters the scene tree for the first time.
func _ready():
	active = false


func activate(duration):
	$DrillTimer.wait_time = duration
	$DrillTimer.start()
	active = true


func _on_DrillTimer_timeout():
	active = false
	queue_free()

func _process(delta):
	if active:
		position = Vector2(108, get_parent().get_node("Player").position.y)
		$AnimatedSprite.visible = true
		monitorable = true
		monitoring = true
		on = true
	else:
		$AnimatedSprite.visible = true
		monitorable = true
		monitoring = true
		on = false
	if get_parent().gameSpeed == 0:
		active = false
		queue_free()


func _physics_process(delta):
	if not active:
		position.x -= get_parent().gameSpeed

func _on_Drill_area_entered(area):
	if active == false:
		if area.is_in_group("player"):
			activate(10)
