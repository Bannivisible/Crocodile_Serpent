extends Area2D
class_name HitBox

@export var combat_skill: CombatSkill:
	set = _set_combat_skill

@export var charac_stat: CharacStatistics

@export var cs_stat: Statistics

@export var faction: HealthComponent.FACTIONS

@export var attack_data: AttackData

@export_range(0.0, 60.0) var damage_inteval: float= 0.0:
	set(value):
		damage_inteval = value
		_init_damage_inteval_timer()

var damage_inteval_timer: Timer

var overlapping_hurt_box: Array[HurtBox]= []

@warning_ignore("unused_signal")
signal hit(damage: float, hurt_box: HurtBox)

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

#### BUILT IN ####
func _ready() -> void:
	area_entered.connect(_on_area_2d_entered)
	area_exited.connect(_on_area_2d_exited)
	
	monitorable = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(Game.COLLISION_MASK.HURT_BOX, true)

#### INIT ####

func _init_damage_inteval_timer() -> void: 
	if damage_inteval == 0.0:
		if damage_inteval_timer:
			damage_inteval_timer.timeout.disconnect(_on_damage_interval_timer_timeout)
			damage_inteval_timer = null
	else :
		if not damage_inteval_timer: 
			damage_inteval_timer = Timer.new()
			add_child(damage_inteval_timer)
			damage_inteval_timer.timeout.connect(_on_damage_interval_timer_timeout)
			
			if overlapping_hurt_box != []:
				damage_inteval_timer.start()
		
		damage_inteval_timer.wait_time = damage_inteval

#### LOGICS ####
func _get_damage() -> float:
	return attack_data.compute_damage(charac_stat ,cs_stat)


func _hit_hurt_box(hurt_box: HurtBox) -> void:
	var damage: float= _get_damage()
	hurt_box.hurt(damage, self)


func _is_area_valid(area: Area2D) -> bool:
	if area is not HurtBox: return false
	if area.owner.faction == faction: return false
	return true

func _affect_hurt_box(hurt_box: Area2D) -> void:
	if not _is_area_valid(hurt_box): return
	
	_hit_hurt_box(hurt_box)
	
	if damage_inteval_timer and overlapping_hurt_box == []:
		damage_inteval_timer.start()
	
	overlapping_hurt_box.append(hurt_box)


func modify_label_damage(_label: Label) -> void:
	return


#### SIGNAL RESPONSES ####
func _on_area_2d_entered(hurt_box: Area2D) -> void:
	_affect_hurt_box(hurt_box)


func _on_area_2d_exited(area: Area2D) -> void:
	if area in overlapping_hurt_box:
		overlapping_hurt_box.erase(area)
		
		if overlapping_hurt_box == [] and damage_inteval_timer:
			damage_inteval_timer.stop()


func _on_damage_interval_timer_timeout() -> void:
	for hurt_box in overlapping_hurt_box:
		_hit_hurt_box(hurt_box)


func _on_combat_skill_charac_stat_changed(cs_charac_stat: CharacStatistics) -> void:
	charac_stat = cs_charac_stat
