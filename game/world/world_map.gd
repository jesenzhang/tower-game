extends Node2D

## World Map - manages day phase exploration and resource gathering

@export var map_size: Vector2i = Vector2i(64, 64)
@export var cell_size: int = 32

var _explored: Array[Vector2i] = []
var _spirit_stones: Dictionary = {}  # pos -> amount


func _ready() -> void:
	_generate_map()


func _generate_map() -> void:
	# TODO: procedural map generation
	pass


func explore_cell(pos: Vector2i) -> void:
	if pos in _explored:
		return
	_explored.append(pos)


func mine_spirit_stone(pos: Vector2i) -> float:
	if not _spirit_stones.has(pos):
		return 0.0
	var amount: float = _spirit_stones[pos]
	_spirit_stones.erase(pos)
	return amount


func is_explored(pos: Vector2i) -> bool:
	return pos in _explored


func has_spirit_stone(pos: Vector2i) -> bool:
	return _spirit_stones.has(pos)
