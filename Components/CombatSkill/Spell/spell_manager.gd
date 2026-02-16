extends Node2D

var current_spell: Spell:
	set = _set_current_spell


#### SETTER ####
func _set_current_spell(value) -> void:
	if current_spell: remove_child(current_spell)
	
	current_spell = value
	
	if current_spell:
		current_spell.object = owner
		add_child(current_spell)


#### BUILT-IN ####
func _ready() -> void:
	Events.combat_skill_selected.connect(_on_Event_combat_skill_selected)


#### SIGNALS RESPONSES ####
func _on_Event_combat_skill_selected(cs_data: CombatSkillData) -> void:
	var cs: CombatSkill= cs_data.combat_skill_scene.instantiate()
	
	if cs is Spell: current_spell = cs
