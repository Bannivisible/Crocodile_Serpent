extends Area2D
class_name HitBox

@export var faction: HealthComponent.FACTIONS

@export var attack_data: AttackData

@export var monitoring_at_ready: bool= true

@export var cs = _get_cs()

@warning_ignore("unused_signal")
signal hit(damage: float, hurt_box: HurtBox)

func _ready() -> void:
	area_entered.connect(_on_area_2d_entered)
	
	if not monitoring_at_ready: monitoring= false
	monitorable = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(3, true)

func _get_cs() -> CombatSkill:
	if cs != null: return cs
	
	if owner is CombatSkill: return owner
	else : return null

func _compute_raw_damage() -> float:
	var total_damage: float = 0.0
	if cs:
		total_damage += cs.strenght.value * attack_data.multiplier
	
	if attack_data.additionnal_strenght:
		total_damage += attack_data.additionnal_strenght.value
	
	return total_damage

func _on_area_2d_entered(area: Area2D) -> void:
	if area is HurtBox:
		var hurt_box: HurtBox= area
		if hurt_box.owner.faction == faction: return
		var damage: float= _compute_raw_damage()
		
		hurt_box.hurt(damage, self)

func modify_label_damage(_label: Label) -> void:
	return
