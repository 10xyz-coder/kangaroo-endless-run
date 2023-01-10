extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal replay

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit_pressed():
	# Go Back
	get_parent().get_node("GameSaver").save_game()
	get_tree().change_scene("res://Scenes/Main_Menu.tscn")


func _on_Play_pressed():
	# Replay
	emit_signal("replay")
