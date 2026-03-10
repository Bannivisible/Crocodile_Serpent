extends Area2D
class_name HiderArea

enum MODULATE_MODE{
	ALL_FAMILLY,
	SELF
}


@export var canvas_node_path: NodePath= ".."

@export var color := Color(1.0, 1.0, 1.0, 0.392)

@export var modulate_mode := MODULATE_MODE.ALL_FAMILLY

@export var tw_ease: Tween.EaseType
@export var tw_trans: Tween.TransitionType
@export var tw_time: float= 0.5

@onready var canvas_node: Node2D= get_node_or_null(canvas_node_path)

var overlapping_bodies: Array[CollisionObject2D]
var previous_modulate: Color

var tween: Tween

#### BUILT-IN ####
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


#### SIGNALS RESPONSES ####
func _on_body_entered(body: CollisionObject2D) -> void:
	if not canvas_node: return
	
	if overlapping_bodies.is_empty():
		match modulate_mode:
			MODULATE_MODE.ALL_FAMILLY:
				previous_modulate = canvas_node.modulate
			MODULATE_MODE.SELF:
				previous_modulate = canvas_node.self_modulate
	
	overlapping_bodies.append(body)
	
	tween = Utiles.reset_tween(self, tween, tw_ease, tw_trans)
	var property_name: NodePath
	
	match modulate_mode:
		MODULATE_MODE.ALL_FAMILLY: property_name = "modulate"
		MODULATE_MODE.SELF: property_name = "self_modulate"
	
	tween.tween_property(canvas_node, property_name, color, tw_time)


func _on_body_exited(body: CollisionObject2D) -> void:
	overlapping_bodies.erase(body)
	
	if not overlapping_bodies == []: return
	
	tween = Utiles.reset_tween(self, tween, tw_ease, tw_trans)
	var property_name: NodePath
	
	match modulate_mode:
		MODULATE_MODE.ALL_FAMILLY: property_name = "modulate"
		MODULATE_MODE.SELF: property_name = "self_modulate"
	
	tween.tween_property(canvas_node, property_name, previous_modulate, tw_time)
