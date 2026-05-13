extends Node

enum GamePhase { DAY, NIGHT, POST_BATTLE }

signal phase_changed(new_phase: GamePhase)

var current_phase: GamePhase = GamePhase.DAY
var wave_number: int = 0
var game_time: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(delta: float) -> void:
	match current_phase:
		GamePhase.DAY:
			game_time += delta
		GamePhase.NIGHT:
			game_time += delta


func change_phase(new_phase: GamePhase) -> void:
	if current_phase == new_phase:
		return
	current_phase = new_phase
	phase_changed.emit(new_phase)


func start_night() -> void:
	wave_number += 1
	change_phase(GamePhase.NIGHT)


func start_post_battle() -> void:
	change_phase(GamePhase.POST_BATTLE)


func start_day() -> void:
	change_phase(GamePhase.DAY)


func reset_run() -> void:
	wave_number = 0
	game_time = 0.0
	change_phase(GamePhase.DAY)
