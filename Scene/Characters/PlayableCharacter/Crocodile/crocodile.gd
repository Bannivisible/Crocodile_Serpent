extends Character
class_name Crocodile


@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var controler: Controler = $PlayerControler
@onready var weapon_manager: Node2D = $WeaponManager
@onready var state_machine: CharacStateMachine = $StateMachine
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_manager: AnimationManagerComponent = $AnimationManagerComponent


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


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_pressed("up"):
		#animation_player.play("Idle")


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("up"):
		#animation_manager.print_blendtree()

#### LOGIC ####
func immobilize() -> void:
	velocity_component.dir = Vector2.ZERO
	controler.active = false


func free_immobolize() -> void:
	controler.active = true


func _on_Event_combat_skill_selected(cs_data: CombatSkillData) -> void:
	if not cs_data.combat_skill_scene: return
	var cs: CombatSkill= cs_data.combat_skill_scene.instantiate()
	
	if cs is Weapon:
		weapon_manager.current_weapon_data = cs_data
		weapon_manager.active = true
		controler.active = true
	
	elif cs is Spell:
		weapon_manager.active = false
		controler.active = false


func _on_Events_cs_interface_on_screen_changed(on_screen: bool) -> void:
	velocity_component.dir = Vector2.ZERO
	if on_screen == true:
		controler.active = false
