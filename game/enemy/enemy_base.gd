extends CharacterBody2D

## Base Enemy - all enemies and bosses extend this

@export var enemy_id: String = ""
@export var enemy_name: String = ""
@export var max_health: float = 100.0
@export var move_speed: float = 50.0
@export var damage: float = 10.0
@export var spirit_drop: float = 5.0
@export var tags: Array[TagSystem.Tag] = []
@export var is_boss: bool = false

var health: float = 100.0
var target_position: Vector2 = Vector2.ZERO


func _ready() -> void:
	health = max_health


func take_damage(amount: float, _source_tags: Array[TagSystem.Tag] = []) -> void:
	var actual: float = _calculate_damage(amount, _source_tags)
	health -= actual
	if health <= 0.0:
		_die()


func heal(amount: float) -> void:
	health = minf(health + amount, max_health)


func _calculate_damage(amount: float, _source_tags: Array[TagSystem.Tag]) -> float:
	# Override for damage modifiers
	return amount


func _die() -> void:
	EventBus.enemy_died.emit(enemy_id, global_position)
	queue_free()


func _physics_process(_delta: float) -> void:
	# Override for movement AI
	pass
