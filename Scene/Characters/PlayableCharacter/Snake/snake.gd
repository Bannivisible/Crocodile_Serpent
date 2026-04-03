extends PlayableCharacter


@onready var spell_manager: Node2D = $SpellManager

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_manager_component: AnimationManagerComponent = $AnimationManagerComponent

#### BUILT-IN ####
func _ready() -> void:
	super._ready()
	Events.combat_skill_selected.connect(_on_Event_combat_skill_selected)

#func _input(_event: InputEvent) -> void:
	#var playback: AnimationNodeStateMachinePlayback= animation_tree.get("parameters/AnimationNodeStateMachine 2/playback")
	#if Input.is_action_just_pressed("up"):
		#print(animation_manager_component.tracks_filter["OneShot"])


#### LOGIC ####
func _can_play() -> bool:
	return spell_manager.active


#### SIGNALS RESPONSES ####
func _on_Event_combat_skill_selected(cs_data: CombatSkillData) -> void:
	if not cs_data.combat_skill_scene: return
	var cs: CombatSkill= cs_data.combat_skill_scene.instantiate()
	
	if cs is Spell:
		spell_manager.current_spell_data = cs_data
		spell_manager.active = true
	
	elif cs is Weapon:
		spell_manager.active = false
