extends Control

## UI Manager - handles HUD, growth choice panel, and game phase transitions

@onready var phase_label: Label = %PhaseLabel
@onready var wave_label: Label = %WaveLabel
@onready var energy_bar: ProgressBar = %EnergyBar
@onready var growth_panel: Control = %GrowthPanel


func _ready() -> void:
	GameManager.phase_changed.connect(_on_phase_changed)
	EventBus.growth_choice_offered.connect(_on_growth_choice_offered)


func _on_phase_changed(new_phase: GameManager.GamePhase) -> void:
	var phase_names: Dictionary = {
		GameManager.GamePhase.DAY: "白天 - 探索与经营",
		GameManager.GamePhase.NIGHT: "夜晚 - 妖潮来袭",
		GameManager.GamePhase.POST_BATTLE: "战后 - 成长选择",
	}
	if phase_label:
		phase_label.text = phase_names.get(new_phase, "")
	if wave_label:
		wave_label.text = "第 %d 波" % GameManager.wave_number


func _on_growth_choice_offered(choices: Array) -> void:
	if growth_panel:
		growth_panel.visible = true
		_display_choices(choices)


func _display_choices(_choices: Array) -> void:
	# TODO: populate growth choice UI
	pass
