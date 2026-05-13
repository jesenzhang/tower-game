extends Node

## Buff System - handles all temporary and persistent status effects
## Supports: DOT, Aura, elemental reactions, law states, stacking

class Buff:
	var buff_id: String
	var tags: Array[TagSystem.Tag] = []
	var duration: float = 0.0
	var tick_interval: float = 1.0
	var stacks: int = 1
	var max_stacks: int = 10
	var source_id: String = ""
	var is_permanent: bool = false
	var _elapsed: float = 0.0
	var _tick_timer: float = 0.0

	func is_expired() -> bool:
		return not is_permanent and _elapsed >= duration

	func tick(delta: float) -> void:
		_elapsed += delta
		_tick_timer += delta

	func should_tick() -> bool:
		if _tick_timer >= tick_interval:
			_tick_timer -= tick_interval
			return true
		return false

	func add_stack(count: int = 1) -> void:
		stacks = mini(stacks + count, max_stacks)

	func get_remaining_time() -> float:
		return maxf(0.0, duration - _elapsed)


var _buffs: Dictionary = {}  # entity_id -> Array[Buff]


func _process(delta: float) -> void:
	for entity_id: String in _buffs:
		var entity_buffs: Array = _buffs[entity_id]
		var expired: Array[Buff] = []
		for buff: Buff in entity_buffs:
			buff.tick(delta)
			if buff.should_tick():
				_apply_tick(entity_id, buff)
			if buff.is_expired():
				expired.append(buff)
		for buff: Buff in expired:
			entity_buffs.erase(buff)
			_on_buff_expired(entity_id, buff)


func add_buff(entity_id: String, buff: Buff) -> void:
	if not _buffs.has(entity_id):
		_buffs[entity_id] = []
	# Check for existing stackable buff
	for existing: Buff in _buffs[entity_id]:
		if existing.buff_id == buff.buff_id:
			existing.add_stack()
			existing._elapsed = 0.0
			return
	_buffs[entity_id].append(buff)


func remove_buff(entity_id: String, buff_id: String) -> void:
	if not _buffs.has(entity_id):
		return
	var entity_buffs: Array = _buffs[entity_id]
	for buff: Buff in entity_buffs:
		if buff.buff_id == buff_id:
			entity_buffs.erase(buff)
			return


func get_buffs(entity_id: String) -> Array:
	if _buffs.has(entity_id):
		return _buffs[entity_id]
	return []


func has_buff(entity_id: String, buff_id: String) -> bool:
	if not _buffs.has(entity_id):
		return false
	for buff: Buff in _buffs[entity_id]:
		if buff.buff_id == buff_id:
			return true
	return false


func clear_buffs(entity_id: String) -> void:
	_buffs.erase(entity_id)


func _apply_tick(_entity_id: String, _buff: Buff) -> void:
	pass  # Implemented by specific buff effects


func _on_buff_expired(_entity_id: String, _buff: Buff) -> void:
	pass  # Override for cleanup
