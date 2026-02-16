extends Component
class_name CSManager

#@export var cs_data: CombatSkillData:
	#set(value):
		#if value != cs_data:
			#cs_data = value
			#_set_cs()
#
#var current_cs: CombatSkill= null
#
#func _ready() -> void:
	#Events.combat_skill_selected.connect(_on_Events_combat_skill_selected)
	#
	#Events.cs_interface_on_screen_changed.connect(_on_Events_cs_interface_on_screen_changed)
	#
	#var velocity_component: VelocityComponent= owner.get_node_or_null("VelocityComponent")
	#if velocity_component: velocity_component.facing_direction_changed.connect(_on_VelocityComponent_facing_direction_change)
#
#func _physics_process(delta: float) -> void:
	#if current_cs:
		#current_cs.process_trigger(delta)
#
#func _set_cs() -> void:
	#if current_cs: current_cs.queue_free()
	#
	#var cs: CombatSkill= cs_data.combat_skill_scene.instantiate()
	#cs.character = owner
	#cs.manager = self
	#cs.strenght = cs_data.strenght
	#cs.position = cs.gap
	#
	#add_child(cs)
	#current_cs = cs
#
##### SIGNALS RESPONSES ####
#
#func _on_VelocityComponent_facing_direction_change(face_dir: Vector2) -> void:
	#if current_cs:
		#current_cs.position.x = current_cs.gap.x * face_dir.x
#
#func _on_Events_combat_skill_selected(data: CombatSkillData) -> void:
	#cs_data = data
	#set_physics_process(true)
	#if current_cs: current_cs.set_process_input(true)
#
#func _on_Events_cs_interface_on_screen_changed(on_screen: bool) -> void:
	#if on_screen:
			#set_physics_process(false)
			#if current_cs: current_cs.set_process_input(false)
