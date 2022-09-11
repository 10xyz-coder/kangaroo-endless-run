extends AnimatedSprite

var move = false

func _ready():
	animation = "default"
	position.y = ( ( int(editor_description) - 2) * 36.5 ) + 57.5
	
func _process(delta):
	# Checking whether on ground or not
	if get_parent().heightX == int(editor_description):
		animation = "Wheel"
	else:
		animation = "default"
	
	if move == true:
		position.x -= get_parent().get_parent().gameSpeed * 2
	else:
		position.x = 15

func _on_AreaHitbox_area_entered(area):
	if area.is_in_group("visible"):
		visible = true
	elif area.is_in_group("danger"):
		move = true


func _on_AreaHitbox_area_exited(area):
	if area.is_in_group("visible"):
		visible = false
	elif area.is_in_group("danger"):
		move = false
