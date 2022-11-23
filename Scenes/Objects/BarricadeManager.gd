extends Node2D


export var barricade:PackedScene
export var speed:float = 100
var column_id:int=0
var num_of_barricades = 0


func generate_barricades(num:int, gap:int) -> void:
	# Generate barricades, but leave a gap in a random position
	var gap_start = randi() % (num - gap)
	for i in range(num):
		if i >= gap_start and i < gap_start + gap:
			continue
		var barricade_instance = generate_barricade(i, column_id)
		add_child(barricade_instance)

func generate_barricade(index:int, col:int) -> Node2D:
	var barricade_instance = barricade.instance()
	var size_of_barricade = Gamemanager.cell_size
	barricade_instance.position = Vector2(size_of_barricade.x*col, size_of_barricade.y*index)
	barricade_instance.velocity = Vector2(-speed, 0)
	barricade_instance.connect("screen_exited", self, "_on_barricade_exited")
	return barricade_instance

func _on_barricade_exited(node:Node2D) -> void:
	node.queue_free()
	num_of_barricades -= 1
	if num_of_barricades <= 0:
		queue_free()
