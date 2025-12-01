extends Component
class_name HealthComponent

enum FACTIONS{
	PLAYER,
	ENEMY,
	NEUTRAL
}

@export var faction : FACTIONS

@export var health: HealthStat:
	set(value):
		if value != health:
			health = value
			if health != null:
				health.die.connect(die)

@export var defense: DefenseStat

@export_group("Feed back")
@export_subgroup("Damage label", "label")
@export var label_settings: LabelSettings

var label_tween: Tween

#### BUILT-IN ####
func _ready() -> void:
	for child in get_children():
		if not child.is_in_group("HurtBox"): return
		
		var hurt_box: HurtBox= child
		hurt_box.hitted.connect(_on_hurt_box_hitted)

#### LOGICS ####
func _hurt(damage: float, hurt_box: HurtBox, hit_box: HitBox) -> void:
	var dam: float= _compute_damage(damage)
	health.current_health -= dam
	
	hit_box.hit.emit(damage, hurt_box)

func die() -> void:
	pass

func _compute_damage(damage: float) -> float:
	return damage - ( 2**(damage / defense.value) )

func _hurt_feed_back(damage: float, hurt_box: HurtBox, hit_box: HitBox) -> void:
	_label_feed_back(damage, hurt_box, hit_box)

func _label_feed_back(damage: float, hurt_box: HurtBox, hit_box: HitBox) -> void:
	var label := Label.new()
	_custom_label(label, damage, hurt_box)
	hurt_box._modify_label_damage(label)
	hit_box.modify_label_damage(label)
	
	add_child(label)
	
	label_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	label_tween.tween_property(label, "position", label.position + Vector2.UP * 32.0, 0.5)
	label_tween.parallel().tween_property(label, "modulate:a", 0.0, 0.5)
	label_tween.parallel().tween_property(label, "scale", Vector2.ZERO, 0.6).set_ease(Tween.EASE_IN)
	
	label_tween.tween_callback(label.queue_free)

func _custom_label(label: Label, damage: float, hurt_box: HurtBox) -> void:
	label.text = str(damage)
	var collision_height: float = Utiles.compute_collision_height(hurt_box.get_child(0))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.scale = Vector2.ONE * 1.5
	label.pivot_offset = label.size
	label.position = hurt_box.position + Vector2.UP * collision_height 
	label.position -= label.size
	var collision_lenght: float= Utiles.compute_collision_lenght(hurt_box.get_child(0))
	label.position.x += randf_range(-collision_lenght, collision_lenght)
	label.label_settings = label_settings.duplicate()

#### SIGNAL RESPONSES ####
func _on_hurt_box_hitted(damage: float, hurt_box: HurtBox, hit_box: HitBox) -> void:
	_hurt(damage, hurt_box, hit_box)
	_hurt_feed_back(damage, hurt_box, hit_box)
