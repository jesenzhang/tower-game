extends Node2D

## Battle Manager - manages night phase combat
## Handles: wave spawning, enemy AI coordination, boss encounters

@export var base_spawn_interval: float = 2.0
@export var spawn_interval_growth: float = 0.02

var _spawn_timer: float = 0.0
var _enemies_alive: int = 0
var _wave_budget: float = 100.0


func _ready() -> void:
	GameManager.phase_changed.connect(_on_phase_changed)


func _on_phase_changed(new_phase: GameManager.GamePhase) -> void:
	if new_phase == GameManager.GamePhase.NIGHT:
		_start_wave()
	elif new_phase == GameManager.GamePhase.POST_BATTLE:
		_end_wave()


func _start_wave() -> void:
	_wave_budget = 100.0 * pow(1.2, GameManager.wave_number - 1)
	_spawn_timer = 0.0
	EventBus.wave_started.emit(GameManager.wave_number)


func _end_wave() -> void:
	EventBus.wave_completed.emit(GameManager.wave_number)


func _process(delta: float) -> void:
	if GameManager.current_phase != GameManager.GamePhase.NIGHT:
		return
	if _wave_budget <= 0.0 and _enemies_alive <= 0:
		GameManager.start_post_battle()
		return
	if _wave_budget > 0.0:
		_spawn_timer -= delta
		if _spawn_timer <= 0.0:
			_spawn_timer = base_spawn_interval * (1.0 - spawn_interval_growth * GameManager.wave_number)
			_spawn_timer = maxf(_spawn_timer, 0.3)
			_spawn_enemy()


func _spawn_enemy() -> void:
	var cost: float = 10.0
	if _wave_budget < cost:
		return
	_wave_budget -= cost
	_enemies_alive += 1
	# TODO: instantiate actual enemy scene
	EventBus.enemy_spawned.emit("enemy_%d" % _enemies_alive)


func on_enemy_killed() -> void:
	_enemies_alive -= 1
