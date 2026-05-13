extends Resource

## Base Artifact resource - equippable magical items
## Supports: auto-attack, evolution, set bonuses, law affixes

class_name ArtifactBase

@export var artifact_id: String = ""
@export var artifact_name: String = ""
@export var artifact_desc: String = ""
@export var tier: int = 1
@export var max_tier: int = 5
@export var tags: Array[TagSystem.Tag] = []
@export var set_id: String = ""

var level: int = 1


func get_base_damage() -> float:
	return 10.0 * tier


func can_evolve() -> bool:
	return tier < max_tier


func evolve() -> void:
	if not can_evolve():
		return
	tier += 1
	level = 1
	EventBus.artifact_evolved.emit(artifact_id, tier)


func get_set_bonus(set_pieces: int) -> Dictionary:
	# Override in specific artifacts
	return {}
