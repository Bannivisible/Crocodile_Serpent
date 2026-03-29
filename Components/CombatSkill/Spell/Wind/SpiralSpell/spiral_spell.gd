extends Spell
class_name SpiralSpell

@export var nb_wind_sphere: int= 1:
	set = _set_nb_wind_sphere

@export var max_wind_sphere: int= 8

@export var spiral_radius: float= 200.0:
	set = _set_spiral_radius

@export var spiral_rot_speed: float= PI

@onready var spriral_center: Node2D = $SpriralCenter
@onready var state_machine: StateMachine = $StateMachine
@onready var state_machine_animation: StateMachine = $StateMachineAnimation


var ws_spiral: Array[WindSphereProjectile]


#### SETTER ####
func _set_spiral_radius(value: float) -> void:
	if value > spiral_radius:
		state_machine_animation.set_state_with_string("Control")
	elif value < spiral_radius :
		state_machine_animation.set_state_with_string("Charge")
	
	spiral_radius = value
	_replace_wind_spheres()


func _set_nb_wind_sphere(value: int) -> void:
	if value > max_wind_sphere: return
	nb_wind_sphere = value
	if not is_node_ready(): await ready
	_setup_spiral()

#### BUILT-IN ####
func _enter_tree() -> void:
	await get_tree().process_frame
	_setup_spiral()


func _physics_process(delta: float) -> void:
	spriral_center.rotation += spiral_rot_speed * delta

#### LOGIC ####
func _replace_wind_spheres() -> void:
	var angle: float= TAU / nb_wind_sphere
	
	for i in range(nb_wind_sphere):
		var dir := Vector2.RIGHT.rotated(angle * i)
		var pos := dir * spiral_radius
		
		ws_spiral[i].position = pos


func _setup_spiral() -> void:
	var child_diff: int= nb_wind_sphere - spriral_center.get_child_count()
	
	if child_diff > 0:
		for i in range(child_diff):
			state_machine.set_state_with_string("SpawnProjectileState")
			state_machine.set_state_with_string("Idle")
	else :
		for i in range(child_diff * -1):
			ws_spiral[0].queue_free()
			ws_spiral.remove_at(0)
	
	_replace_wind_spheres()

#### SIGNALS RESPONSES ###
func _on_spawn_projectile_state_projectile_spawn(projectile: Projectile) -> void:
	ws_spiral.append(projectile)


func _on_timer_timeout() -> void:
	nb_wind_sphere += 1
