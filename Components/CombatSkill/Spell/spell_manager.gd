extends Node2D

@export var active: bool= true:
	set = _set_active

@export var charac_stat: CharacStatistics:
	set = _set_charac_stat

@export var current_spell_data: CombatSkillData:
	set = _set_spell_data

var current_spell: Spell:
	set = _set_current_spell


#### SETTER ####
func _set_active(value: bool) -> void:
	if value == active: return
	
	active = value
	
	if current_spell:
		if active and not current_spell in get_children():
			add_child(current_spell)
	
		elif not active and current_spell in get_children():
			remove_child(current_spell)


func _set_current_spell(value) -> void:
	if value == current_spell: return
	if current_spell in get_children():
		remove_child(current_spell)
	
	current_spell = value
	
	if current_spell:
		current_spell.object = owner
		current_spell.charac_stat = charac_stat
		
		if active and not current_spell in get_children():
			add_child(current_spell)


func _set_charac_stat(value: CharacStatistics):
	charac_stat = value
	
	if current_spell:
		current_spell.charac_stat = charac_stat


func _set_spell_data(value: CombatSkillData) -> void:
	if not value != current_spell_data: return
	
	current_spell_data = value
	
	if current_spell_data == null:
		current_spell = null
	else :
		current_spell = current_spell_data.combat_skill_scene.instantiate()
