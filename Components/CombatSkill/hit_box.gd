extends Area2D
class_name HitBox

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

#### BUILT IN ####
func _ready() -> void:
	area_entered.connect(_on_area_2d_entered)
	area_exited.connect(_on_area_2d_exited)
	
	monitorable = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(3, true)

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
		
		damage_inteval_timer.wait_time = damage_inteval

#### LOGICS ####

func _compute_raw_damage() -> float:
	return attack_data.add_damage * attack_data.mult_damage

func modify_label_damage(_label: Label) -> void:
	return

#### SIGNAL RESPONSES ####

func _on_area_2d_entered(area: Area2D) -> void:
	if area is HurtBox:
		var hurt_box: HurtBox= area
		if hurt_box.owner.faction == faction: return
		
		
		var damage: float= _compute_raw_damage()
		hurt_box.hurt(damage, self)
		
		if damage_inteval_timer and overlapping_hurt_box == []:
			damage_inteval_timer.start()
		
		overlapping_hurt_box.append(hurt_box)

func _on_area_2d_exited(area: Area2D) -> void:
	if area in overlapping_hurt_box:
		overlapping_hurt_box.erase(area)
		
		if overlapping_hurt_box == [] and damage_inteval_timer:
			damage_inteval_timer.stop()

func _on_damage_interval_timer_timeout() -> void:
	for hurt_box in overlapping_hurt_box:
		var damage: float= _compute_raw_damage()
		hurt_box.hurt(damage, self)
