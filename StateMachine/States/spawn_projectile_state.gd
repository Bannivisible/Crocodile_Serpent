extends State
class_name SpawnProjectileState

@export var combat_skill: CombatSkill:
	set = _set_combat_skill

@export_group("ProjectileParameters")

@export var projectile_scene: PackedScene

@export var charac_stat: CharacStatistics
@export var cs_stat: Statistics
@export var attack_data: AttackData

@export_group("SpawnParameters", "spawn_")

@export var spawn_pos: Vector2= Vector2.ZERO
@export_enum("Global", "Owner") var spawn_pos_mode: String= "Owner"

@export var spawn_rot: float
@export_enum("Radian", "Degree") var spawn_rot_mode: String= "Radian"

@export var spawn_projectile_parent: Node= null


@export var vel_comp_path: NodePath= "VelocityComponent" 
@export var face_dir_rotation: float= PI


signal projectile_spawn(projectile: Projectile)

#### SETTERS ####
func _set_combat_skill(value: CombatSkill) -> void:
	if combat_skill:
		combat_skill.charac_stat_changed.disconnect(_on_combat_skill_charac_stat_changed)
	
	combat_skill = value
	
	if combat_skill:
		charac_stat = combat_skill.charac_stat
		cs_stat = combat_skill.stat
		combat_skill.charac_stat_changed.connect(_on_combat_skill_charac_stat_changed)
	else :
		charac_stat = null
		cs_stat = null


#### BUILT-IN ####
func _ready() -> void:
	var vel_comp: VelocityComponent= get_object_node(vel_comp_path)
	if vel_comp:
		vel_comp.face_dir_changed.connect(_on_vel_comp_face_dir_changed)
	
	if spawn_rot_mode == "Degree": spawn_rot = deg_to_rad(spawn_rot)

#### LOGIC ####
func _get_projectile_spawn_pos() -> Vector2:
	var proj_spawn_pos := spawn_pos
	
	if spawn_pos_mode == "Owner":
		proj_spawn_pos += owner.global_position
	
	return proj_spawn_pos


func _setup_spawn_parameters(projectile: Projectile) -> void:
	projectile.global_position = _get_projectile_spawn_pos()
	projectile.rotation = spawn_rot


func _setup_projectile_parameters(projectile: Projectile) -> void:
	projectile.charac_stat = charac_stat
	projectile.cs_stat = cs_stat
	
	if attack_data: projectile.attack_data = attack_data


func _spawn_projectile(projectile: Projectile) -> void:
	if spawn_projectile_parent:
		spawn_projectile_parent.add_child(projectile)
	else :
		Events.request_spawn_object.emit(projectile)

#### INHERITANCE ####
func enter() -> void:
	var projectile: Projectile= projectile_scene.instantiate()
	
	_setup_projectile_parameters(projectile)
	_spawn_projectile(projectile)
	_setup_spawn_parameters(projectile)
	
	projectile_spawn.emit(projectile)

#### SIGNAL RESPONSES ####
func _on_vel_comp_face_dir_changed(dir: Vector2) -> void:
	spawn_pos.x = abs(spawn_pos.x) *  dir.x
	spawn_rot += face_dir_rotation * dir.x


func _on_combat_skill_charac_stat_changed(cs_charac_stat: CharacStatistics) -> void:
	charac_stat = cs_charac_stat
