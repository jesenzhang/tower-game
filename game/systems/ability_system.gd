extends Node

## Ability System - unified handler for all ability types
## Handles: formation attacks, artifact skills, true spirit skills, passive effects

class Ability:
	var ability_id: String
	var ability_name: String
	var tags: Array[TagSystem.Tag] = []
	var cooldown: float = 1.0
	var _cooldown_timer: float = 0.0

	func is_ready() -> bool:
		return _cooldown_timer <= 0.0

	func start_cooldown() -> void:
		_cooldown_timer = cooldown

	func tick_cooldown(delta: float) -> void:
		if _cooldown_timer > 0.0:
			_cooldown_timer -= delta


signal ability_cast(ability_id: String, caster_id: String, target_pos: Vector2)

var _abilities: Dictionary = {}  # entity_id -> Array[Ability]


func _process(delta: float) -> void:
	for _entity_id: String in _abilities:
		for ability: Ability in _abilities[_entity_id]:
			ability.tick_cooldown(delta)


func register_ability(entity_id: String, ability: Ability) -> void:
	if not _abilities.has(entity_id):
		_abilities[entity_id] = []
	_abilities[entity_id].append(ability)


func unregister_ability(entity_id: String, ability_id: String) -> void:
	if not _abilities.has(entity_id):
		return
	var list: Array = _abilities[entity_id]
	for i: int in range(list.size() - 1, -1, -1):
		if list[i].ability_id == ability_id:
			list.remove_at(i)
			return


func cast_ability(entity_id: String, ability_id: String, target_pos: Vector2) -> bool:
	if not _abilities.has(entity_id):
		return false
	for ability: Ability in _abilities[entity_id]:
		if ability.ability_id == ability_id and ability.is_ready():
			ability.start_cooldown()
			ability_cast.emit(ability_id, entity_id, target_pos)
			_execute_ability(entity_id, ability, target_pos)
			return true
	return false


func get_abilities(entity_id: String) -> Array:
	if _abilities.has(entity_id):
		return _abilities[entity_id]
	return []


func _execute_ability(_entity_id: String, _ability: Ability, _target_pos: Vector2) -> void:
	pass  # Override for specific ability logic
