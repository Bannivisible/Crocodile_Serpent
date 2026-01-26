extends Control
class_name CSInterface

@onready var data_manager: CSInterfacceDataManager = $CSInterfaceDataManager

@export var show_animation_ease: Tween.EaseType
@export var show_animation_trans: Tween.TransitionType

@export var last_button_focus: Button


var on_screen: bool= false:
	set(value):
		if value != on_screen:
			on_screen = value
			on_screen_changed.emit(on_screen)
			Events.cs_interface_on_screen_changed.emit(on_screen)

var tween: Tween

const SHOW_ANIMATION_DURATION: float= 0.5

signal on_screen_changed(on_screen: bool)
signal on_screen_animation_finished()
signal cs_category_selected()
signal cancel()

#### BUILT_IN ####
func _ready() -> void:
	on_screen_changed.connect(_on_on_scren_changed)


#### INPUTS ####
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("choose"):
		display()
	
	if Input.is_action_just_pressed("cancel"):
		cancel.emit()


#### LOGIC ####
func display() -> void:
	if tween: tween.kill()
	var to = -size.y if on_screen else 0.0
	on_screen = !on_screen
	
	tween = create_tween().set_ease(show_animation_ease).set_trans(show_animation_trans)
	tween.tween_property(self, "position:y", to, SHOW_ANIMATION_DURATION)
	tween.tween_callback(func():on_screen_animation_finished.emit())


func _emit_event_cs_selected_signal(cs_data) -> void:
	Events.combat_skill_selected.emit(cs_data)



func _last_button_focus_grab_focus() -> void:
	last_button_focus.grab_focus()

func _last_button_focus_release_focus() -> void:
	last_button_focus.release_focus()

#### SIGNAL RESPONSES ####
func _on_cs_category_button_pressed() -> void:
	cs_category_selected.emit()


func _on_cs_selected(cs_data: CombatSkillData) -> void:
	display()
	tween.tween_callback(func():
		Events.combat_skill_selected.emit(cs_data)
	)


func _on_on_scren_changed(_value: bool) -> void:
	if on_screen:
		_last_button_focus_grab_focus()
	else :
		_last_button_focus_release_focus()
