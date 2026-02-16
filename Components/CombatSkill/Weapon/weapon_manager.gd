extends Node2D


var current_weapon: Weapon:
	set = _set_current_weapon


#### SETTER ####
func _set_current_weapon(value) -> void:
	if current_weapon: remove_child(current_weapon)
	
	current_weapon = value
	
	if current_weapon:
		current_weapon.object = owner
		add_child(current_weapon)


#### BUILT-IN ####
func _ready() -> void:
	Events.combat_skill_selected.connect(_on_Event_combat_skill_selected)


#### SIGNALS RESPONSES ####
func _on_Event_combat_skill_selected(cs_data: CombatSkillData) -> void:
	var cs: CombatSkill= cs_data.combat_skill_scene.instantiate()
	
	if cs is Weapon: current_weapon = cs
