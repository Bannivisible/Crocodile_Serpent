extends Node2D

@export var active: bool= true

@export var charac_stat: CharacStatistics:
	set = _set_charac_stat


var current_weapon: Weapon:
	set = _set_current_weapon


#### SETTER ####
func _set_active(value: bool) -> void:
	if value == active: return
	
	active = value
	
	if active and current_weapon:
		add_child(current_weapon)
	elif current_weapon != null:
		remove_child(current_weapon)

func _set_current_weapon(value: Weapon) -> void:
	if current_weapon: remove_child(current_weapon)
	
	current_weapon = value
	
	if current_weapon:
		current_weapon.object = owner
		current_weapon.charac_stat = charac_stat
		
		if active: add_child(current_weapon)


func _set_charac_stat(value: CharacStatistics):
	charac_stat = value
	
	if current_weapon:
		current_weapon.charac_stat = charac_stat

#### BUILT-IN ####

#### SIGNALS RESPONSES ####
