extends AnimatedSprite

var move = false

func _ready():
	animation = "default"
	position.y = ( ( int(editor_description) - 2) * 52.5 ) + 57.5
	
func _process(delta):
	# Checking whether on ground or not
	if int(editor_description) <= get_parent().heightX:
		if move != true:
			visible = true
		else:
			visible = false
	else:
		visible = false
	
	if get_parent().heightX == int(editor_description) and get_parent().is_falling == false:
		animation = "Wheel"
	else:
		animation = "default"
	


func _on_AreaHitbox_area_entered(area):
	# area.is_in_group("visible"):
		#visible = true
	if area.is_in_group("danger"):
		move = true


func _on_AreaHitbox_area_exited(area):
	#if area.is_in_group("visible"):
		#visible = false
	if area.is_in_group("danger"):
		yield(get_tree().create_timer(0.2), "timeout")
		move = false
