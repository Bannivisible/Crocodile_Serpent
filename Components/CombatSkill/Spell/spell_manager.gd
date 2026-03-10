extends Node2D

@export var active: bool= true:
	set = _set_active

@export var charac_stat: CharacStatistics:
	set = _set_charac_stat


var current_spell: Spell:
	set = _set_current_spell


#### SETTER ####
func _set_active(value: bool) -> void:
	if value == active: return
	
	active = value
	
	if active and current_spell:
		add_child(current_spell)
	elif current_spell != null:
		remove_child(current_spell)


func _set_current_spell(value) -> void:
	if current_spell: remove_child(current_spell)
	
	current_spell = value
	
	if current_spell:
		current_spell.object = owner
		current_spell.charac_stat = charac_stat
		add_child(current_spell)


func _set_charac_stat(value: CharacStatistics):
	charac_stat = value
	
	if current_spell:
		current_spell.charac_stat = charac_stat

#### BUILT-IN ####
func _ready() -> void:
	Events.combat_skill_selected.connect(_on_Event_combat_skill_selected)


#### SIGNALS RESPONSES ####
func _on_Event_combat_skill_selected(cs_data: CombatSkillData) -> void:
	var cs: CombatSkill= cs_data.combat_skill_scene.instantiate()
	
	if cs is Spell:
		current_spell = cs
		active = true
	elif cs is Weapon: active = false
