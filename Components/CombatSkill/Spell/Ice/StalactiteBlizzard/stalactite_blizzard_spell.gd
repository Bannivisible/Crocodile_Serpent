extends Spell
class_name StalactiteBlizzard

@export var stal_colli_mask := Game.COLLISION_MASK.OTHER

@export var inval_pos_tw_ease: Tween.EaseType
@export var inval_pos_tw_trans: Tween.TransitionType
@export var inval_pos_tw_duration: float= 0.5


@onready var state_machine: StateMachine = $StateMachine

var current_stalactite: Stalactite
var stalactites: Array[Stalactite]

var tween: Tween


func current_stal_pos_valide() -> bool:
	for area in current_stalactite.get_overlapping_areas():
		if area in stalactites:
			_stal_pos_invalide_feed_back()
			return false
	
	return true


func _stal_pos_invalide_feed_back() -> void:
	tween = Utiles.reset_tween(self, tween, inval_pos_tw_ease, inval_pos_tw_trans)
	
	var stal_modulate: Color= current_stalactite.modulate
	var new_color := Color(1.0, 0.153, 0.259, 1.0)
	
	tween.tween_property(current_stalactite, "modulate", new_color, inval_pos_tw_duration/2)
	tween.tween_callback(func():
		tween = Utiles.reset_tween(self, tween, inval_pos_tw_ease, inval_pos_tw_trans)
		tween.tween_property(current_stalactite, "modulate", stal_modulate, inval_pos_tw_duration/2))


func _set_stal_collision(stalactite: Stalactite, to_project: bool= false) -> void:
	stalactite.set_collision_layer_value(stal_colli_mask, !to_project)
	stalactite.set_collision_mask_value(stal_colli_mask, !to_project)
	stalactite.monitorable = !to_project
	stalactite.set_collision_mask_value(Game.COLLISION_MASK.HURT_BOX, to_project)


func _set_stal_attack_data(stalactite: Stalactite) -> void:
	stalactite.attack_data = stalactite.attack_data.duplicate()
	stalactite.attack_data.mult_damage = float(len(stalactites))


func _cast_stalactites() -> void:
	for stalactite in stalactites:
		_set_stal_collision(stalactite, true)
		
		var callable: Callable= _on_stalactite_destination_reached.bind(stalactite)
		stalactite.linear_movement.destination_reached.connect(callable)
		
		stalactite.project()

#### SIGNALS RESPONSES ####
func _on_spawn_projectile_state_projectile_spawn(projectile: Projectile) -> void:
	current_stalactite = projectile
	_set_stal_collision(projectile)
	stalactites.append(projectile)
	_set_stal_attack_data(projectile)
	
	state_machine.set_state_with_string("PlaceStalactite")


func _on_timer_timeout() -> void:
	_cast_stalactites()
	state_machine.set_state_with_string("Idle")
	stalactites = []


func _on_stalactite_destination_reached(stalactite: Stalactite) -> void:
	stalactite.queue_free()
