extends StateMachine

## !! NE PAS SUPPRIMMER EN MEME TEMPS DANS L'EDITEUR LES DEUX REMOTE CAR LEUR PISTE D'ANIMATIONS 
## S'EFFACERONS AUTOMATIQUEMENT

@export var next_state: State

@export var remote_f_parent_path: NodePath
@export var remote_b_parent_path: NodePath

@export var remote_f: RemoteTransform2D
@export var remote_b: RemoteTransform2D

@export var gauge: Control
@export_range(0.0, 999.9) var bonus_time_amount: float= 1.0
@export var hit_box: HitBox

@onready var dynamic_timer: DynamicTimer = $DynamicTimer

@onready var front: StaticBody2D = $"../../Front"
@onready var back: StaticBody2D = $"../../Back"

var remote_trans_f : RemoteTransform2D= null

var remote_trans_b : RemoteTransform2D= null

#### BUILT-IN ####

func _ready() -> void:
	super._ready()
	
	dynamic_timer.timeout.connect(_on_dynamic_timer_timeout)
	hit_box.hit.connect(_on_hit_box_hit)
	#
	#await object.ready
	#
	#var f_remote: RemoteTransform2D= get_node_or_null(String(remote_f_parent_path) + "/" + remote_f_name)
	#if f_remote:
		#remote_trans_f= f_remote
	#else :
		#remote_trans_f = _innit_remote_trans(remote_f_parent_path)
		#remote_trans_f.name = remote_f_name
	#
	#var b_remote: RemoteTransform2D= get_node_or_null(String(remote_b_parent_path) + "/" + remote_b_name)
	#if b_remote:
		#remote_trans_b = b_remote
	#else :
		#remote_trans_b = _innit_remote_trans(remote_b_parent_path)
		#remote_trans_b.name = remote_b_name


func _enter_tree() -> void:
	#remove
	var f_parent: Node= get_node_or_null(remote_f_parent_path)
	if f_parent: f_parent.add_child(remote_f)
	
	var b_parent: Node= get_node_or_null(remote_b_parent_path)
	if b_parent: b_parent.add_child(remote_b)


func _exit_tree() -> void:
	remote_f.get_parent().remove_child(remote_f)
	add_child(remote_f)
	remote_b.get_parent().remove_child(remote_b)
	add_child(remote_b)


#### INHERITENCE ####

func enter() -> void:
	super.enter()
	
	dynamic_timer.start()
	
	gauge.visible = true


func exit() -> void:
	super.exit()
	
	remote_f.remote_path = ""
	remote_b.remote_path = ""
	
	gauge.visible = false


#### LOGIC ####
func _innit_remote_trans(parent_path: NodePath) -> RemoteTransform2D:
	var remote_trans = RemoteTransform2D.new()
	get_node(parent_path).add_child(remote_trans)
	
	return remote_trans


#### SIGNALS RESPONSES ####

func _on_dynamic_timer_timeout() -> void:
	if not is_current_state(): return
	get_top_state_machine().set_state(next_state)

#func _input(_event: InputEvent) -> void:
	#if Input.is_action_just_pressed("BentDown"):
		#dynamic_timer.add_time(3.0)


func _on_hit_box_hit(_damage: float, _hurt_box: HurtBox) -> void:
	if is_current_state():
		dynamic_timer.add_time(bonus_time_amount)

