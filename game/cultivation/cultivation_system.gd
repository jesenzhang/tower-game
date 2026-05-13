extends Node

## Cultivation System - manages cultivation realms, techniques, and breakthroughs

enum Realm {
	MORTAL,
	QI_CONDENSATION,
	FOUNDATION,
	GOLDEN_CORE,
	NASCENT_SOUL,
	SOUL_FORMATION,
	VOID_AMALGAMATION,
	MAHAYANA,
	ASCENSION,
}

var current_realm: Realm = Realm.MORTAL
var cultivation_points: float = 0.0
var techniques: Dictionary = {}  # technique_id -> level
var spiritual_roots: Array[TagSystem.Tag] = [TagSystem.Tag.FIRE]


func _ready() -> void:
	pass


func add_cultivation_points(amount: float) -> void:
	cultivation_points += amount


func can_breakthrough() -> bool:
	var required: float = _get_breakthrough_cost()
	return cultivation_points >= required


func attempt_breakthrough() -> bool:
	if not can_breakthrough():
		EventBus.breakthrough_attempted.emit(Realm.keys()[current_realm])
		return false
	cultivation_points -= _get_breakthrough_cost()
	current_realm = current_realm + 1 as Realm
	EventBus.breakthrough_succeeded.emit(Realm.keys()[current_realm])
	return true


func learn_technique(technique_id: String) -> void:
	if not techniques.has(technique_id):
		techniques[technique_id] = 1
		EventBus.technique_learned.emit(technique_id)


func level_up_technique(technique_id: String) -> void:
	if techniques.has(technique_id):
		techniques[technique_id] += 1
		EventBus.technique_leveled_up.emit(technique_id, techniques[technique_id])


func _get_breakthrough_cost() -> float:
	return 100.0 * (current_realm + 1) * (current_realm + 1)


func get_realm_name() -> String:
	return Realm.keys()[current_realm]
