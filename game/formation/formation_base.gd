extends Node2D

## Base Formation - parent class for all formations (array spells)
## Each formation has element type, attack pattern, and energy consumption

@export var formation_id: String = ""
@export var formation_name: String = ""
@export var element: TagSystem.Tag = TagSystem.Tag.FIRE
@export var base_damage: float = 10.0
@export var attack_range: float = 128.0
@export var attack_interval: float = 1.0
@export var energy_cost: float = 0.5
@export var max_level: int = 5

var level: int = 1
var grid_pos: Vector2i = Vector2i.ZERO
var is_active: bool = true
var _attack_timer: float = 0.0


func _ready() -> void:
	_attack_timer = attack_interval


func _process(delta: float) -> void:
	if not is_active:
		return
	_attack_timer -= delta
	if _attack_timer <= 0.0:
		_attack_timer = attack_interval
		_try_attack()


func _try_attack() -> void:
	var targets: Array = _find_targets()
	if targets.is_empty():
		return
	# Check energy from spirit vein network
	if not _consume_energy():
		return
	_execute_attack(targets)


func _find_targets() -> Array:
	# Override in specific formations
	return []


func _consume_energy() -> bool:
	# TODO: integrate with SpiritVeinNetwork
	return true


func _execute_attack(_targets: Array) -> void:
	# Override in specific formations
	pass


func upgrade() -> void:
	if level >= max_level:
		return
	level += 1
	base_damage *= 1.3
	attack_range *= 1.1
	attack_interval *= 0.9
	EventBus.formation_upgraded.emit(formation_id, level)


func get_tags() -> Array[TagSystem.Tag]:
	var tags: Array[TagSystem.Tag] = [TagSystem.Tag.FORMATION, element]
	return tags
