extends Area2D


var active = false


# Called when the node enters the scene tree for the first time.
func _ready():
	active = false


func activate(duration):
	$DrillTimer.wait_time = duration
	$DrillTimer.start()
	active = true


func _on_DrillTimer_timeout():
	active = false

func _process(delta):
	if active:
		$AnimatedSprite.visible = true
		monitorable = true
		monitoring = true
	else:
		$AnimatedSprite.visible = false
		monitorable = false
		monitoring = false
	if get_parent().gameSpeed == 0:
		active = false
