extends Node

## Roguelike Growth System - handles 30-45 second growth choice cycle
## Provides: new formations, artifacts, spirit patterns, law fragments, spirit beasts, technique breakthroughs

signal choice_presented(choices: Array)
signal choice_made(choice: Dictionary)

enum GrowthType {
	FORMATION,
	ARTIFACT,
	SPIRIT_PATTERN,
	LAW_FRAGMENT,
	SPIRIT_BEAST,
	TECHNIQUE,
}

var _choice_timer: float = 0.0
var _choice_interval: float = 35.0
var _pending_choices: Array = []


func _process(delta: float) -> void:
	if GameManager.current_phase != GameManager.GamePhase.NIGHT:
		return
	_choice_timer += delta
	if _choice_timer >= _choice_interval:
		_choice_timer = 0.0
		_generate_choices()


func _generate_choices() -> void:
	var choices: Array = []
	var types: Array[GrowthType] = [
		GrowthType.FORMATION,
		GrowthType.ARTIFACT,
		GrowthType.SPIRIT_PATTERN,
		GrowthType.LAW_FRAGMENT,
		GrowthType.SPIRIT_BEAST,
		GrowthType.TECHNIQUE,
	]
	types.shuffle()
	for i: int in range(mini(3, types.size())):
		choices.append(_create_choice(types[i]))
	_pending_choices = choices
	choice_presented.emit(choices)
	EventBus.growth_choice_offered.emit(choices)


func select_choice(index: int) -> void:
	if index < 0 or index >= _pending_choices.size():
		return
	var choice: Dictionary = _pending_choices[index]
	choice_made.emit(choice)
	EventBus.growth_choice_selected.emit(choice)
	_apply_choice(choice)
	_pending_choices.clear()


func _create_choice(type: GrowthType) -> Dictionary:
	return {
		"type": type,
		"id": "placeholder_%d" % type,
		"name": GrowthType.keys()[type],
		"description": "A %s growth option" % GrowthType.keys()[type],
		"rarity": "common",
	}


func _apply_choice(_choice: Dictionary) -> void:
	# Route to appropriate system based on type
	pass
