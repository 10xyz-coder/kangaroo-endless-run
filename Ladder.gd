extends AnimatedSprite


func _ready():
	animation = "default"
	
func _process(delta):
	# Checking whether on ground or not
	if get_parent().heightX == int(editor_description):
		animation = "Wheel"
	else:
		animation = "default"

func _on_AreaHitbox_area_entered(area):
	if area.is_in_group("visible"):
		visible = true


func _on_AreaHitbox_area_exited(area):
	if area.is_in_group("visible"):
		visible = false
