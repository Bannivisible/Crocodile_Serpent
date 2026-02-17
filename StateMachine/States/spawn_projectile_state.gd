extends State
class_name SpawnProjectileState

@export var projectile_scene: PackedScene

@export var pos: Vector2= Vector2.ZERO
@export_enum("Global", "Owner") var pos_mode: String= "Owner"

@export var rot: float
@export_enum("Radian", "Degree") var rot_mode: String= "Radian"
@export var face_dir_rotation: float= PI

@export var vel_comp_path: NodePath= "VelocityComponent" 


signal projectile_spawn(projectile: Projectile)

#### BUILT-IN ####
func _ready() -> void:
	var vel_comp: VelocityComponent= get_object_node(vel_comp_path)
	if vel_comp:
		vel_comp.facing_direction_changed.connect(_on_vel_comp_facing_direction_changed)
	
	if rot_mode == "Degree": rot = deg_to_rad(rot)

#### LOGIC ####
func _get_projectile_pos() -> Vector2:
	var proj_pos := pos
	
	if pos_mode == "Owner":
		proj_pos += owner.global_position
	
	return proj_pos


#### INHERITANCE ####
func enter() -> void:
	var projectile: Projectile= projectile_scene.instantiate()
	projectile.global_position = _get_projectile_pos()
	projectile.rotation = rot
	
	Events.request_spawn_object.emit(projectile)
	projectile_spawn.emit(projectile)



#### SIGNAL RESPONSES ####
func _on_vel_comp_facing_direction_changed(dir: Vector2) -> void:
	pos.x = abs(pos.x) *  dir.x
	rot += face_dir_rotation * dir.x
