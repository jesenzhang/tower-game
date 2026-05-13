extends Node

# Formation signals
signal formation_placed(formation_id: String, grid_pos: Vector2i)
signal formation_removed(formation_id: String, grid_pos: Vector2i)
signal formation_activated(formation_id: String)
signal formation_upgraded(formation_id: String, level: int)

# Spirit Vein signals
signal vein_connected(node_a: Vector2i, node_b: Vector2i)
signal vein_disconnected(node_a: Vector2i, node_b: Vector2i)
signal spirit_energy_changed(amount: float)

# Artifact signals
signal artifact_equipped(artifact_id: String)
signal artifact_unequipped(artifact_id: String)
signal artifact_evolved(artifact_id: String, new_tier: int)

# Battle signals
signal enemy_spawned(enemy_id: String)
signal enemy_died(enemy_id: String, pos: Vector2)
signal wave_started(wave: int)
signal wave_completed(wave: int)
signal boss_spawned(boss_id: String)

# Roguelike signals
signal growth_choice_offered(choices: Array)
signal growth_choice_selected(choice: Dictionary)
signal perk_acquired(perk_id: String)

# Cultivation signals
signal breakthrough_attempted(realm: String)
signal breakthrough_succeeded(realm: String)
signal technique_learned(technique_id: String)
signal technique_leveled_up(technique_id: String, level: int)

# True Spirit signals
signal spirit_form_entered(spirit_id: String)
signal spirit_form_exited(spirit_id: String)

# Law signals
signal law_awakened(law_id: String)
signal law_activated(law_id: String)
