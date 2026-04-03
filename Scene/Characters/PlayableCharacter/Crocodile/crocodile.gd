extends PlayableCharacter
class_name Crocodile


@onready var weapon_manager: Node2D = $WeaponManager
@onready var state_machine: CharacStateMachine = $StateMachine
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_manager: AnimationManagerComponent = $AnimationManagerComponent
@onready var remote_hand_target: RemoteTransform2D = $Skeleton2D/Center/Body/Torso/ArmFront/ForeArmFront/HandFront/HandFrontTarget/HandFrontTarget

##### BUILT-IN ####
func _ready() -> void:
	super._ready()
	Events.combat_skill_selected.connect(_on_Event_combat_skill_selected)


#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("up"):
		#print(rotation)


#### LOGIC ####
func _can_play() -> bool:
	return weapon_manager.active


#### SIGNALS RESPONSES ####
func _on_Event_combat_skill_selected(cs_data: CombatSkillData) -> void:
	if not cs_data.combat_skill_scene: return
	var cs: CombatSkill= cs_data.combat_skill_scene.instantiate()
	
	if cs is Weapon:
		weapon_manager.current_weapon_data = cs_data
		weapon_manager.active = true
	
	elif cs is Spell:
		weapon_manager.active = false
