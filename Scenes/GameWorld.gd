extends Node2D


export var barricade_manager:PackedScene
export var offset_position:float = 332
export var max_number_of_columns:int = 3
export var speed:float = 100

var number_of_columns:int=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generate_barricades(Gamemanager.cell_count, 3)

func _process(delta: float) -> void:
	number_of_columns = get_child_count()
	if number_of_columns < max_number_of_columns:
		_generate_barricades(Gamemanager.cell_count, 3)

func _generate_barricades(num:int, gap:int) -> void:
	var manager:PackedScene = barricade_manager
	var offset:float = offset_position
	var num_to_generate:int = max_number_of_columns - number_of_columns + 1
	for _i in range(num_to_generate):
		var barricades=manager.instance()
		barricades.position.x = offset
		# Generate barricades
		barricades.call("generate_barricades", num, gap)
		add_child(barricades)
		offset += Gamemanager.cell_size.x +100
		number_of_columns+=1
