extends Character
class_name Crocodile


@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var controler: Controler = $PlayerControler
@onready var weapon_manager: Node2D = $WeaponManager
@onready var state_machine: CharacStateMachine = $StateMachine


##### BUILT-IN ####
func _ready() -> void:
	Events.combat_skill_selected.connect(_on_Event_combat_skill_selected)
	Events.cs_interface_on_screen_changed.connect(_on_Events_cs_interface_on_screen_changed)


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("bent_down"):
		#print($AnimationTree.get("parameters/StateMachine/playback"))

#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("bent_down"):
		#print($AnimationPlayer.get_animation_library_list())



#### LOGIC ####
func immobilize() -> void:
	velocity_component.dir = Vector2.ZERO
	controler.active = false


func free_immobolize() -> void:
	controler.active = true


func _on_Event_combat_skill_selected(cs_data: CombatSkillData) -> void:
	var cs: CombatSkill= cs_data.combat_skill_scene.instantiate()
	
	if cs is Weapon:
		weapon_manager.current_weapon = cs
		weapon_manager.active = true
		controler.active = true
	
	elif cs is Spell:
		weapon_manager.active = false
		controler.active = false


func _on_Events_cs_interface_on_screen_changed(on_screen: bool) -> void:
	velocity_component.dir = Vector2.ZERO
	if on_screen == true:
		controler.active = false
