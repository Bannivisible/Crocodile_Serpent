extends Control
class_name CSInterface

@onready var data_manager: CSInterfacceDataManager = $CSInterfaceDataManager

@export var show_animation_ease: Tween.EaseType
@export var show_animation_trans: Tween.TransitionType

signal on_screen_changed(on_screen)
var on_screen: bool= false:
	set(value):
		if value != on_screen:
			on_screen = value
			on_screen_changed.emit(on_screen)
			Events.cs_interface_on_screen_changed.emit(on_screen)

var tween: Tween

const SHOW_ANIMATION_DURATION: float= 0.5

signal on_screen_animation_finished()
signal cs_category_selected()
signal cancel()

#### BUILT_IN ####
func _ready() -> void:
	data_manager.player_statistics.reactive_changed.connect(_on_player_statistics_stat_changed)
	_connect_cs_category_buttons_signals()
	
	for stat_name in data_manager.player_statistics.statistics.keys():
		_set_stat_label_text(data_manager.player_statistics.get(stat_name))
	
	on_screen_changed.connect(func(_value):
		if not on_screen: release_focus())

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

func _set_stat_label_text(stat: Stat) -> void:
	var stat_name: String= Utiles.get_property_name_from_value(
		data_manager.player_statistics, stat
	)
	
	var label: Label = get_node_or_null("%" + Utiles.uppercase_first_letter(stat_name) + "Label")
	if label:
		label.text += " " + str(stat.value)

func _connect_cs_category_buttons_signals() -> void:
	for child in %CSCategoryGridContainer.get_children():
		var cs_categ_button: CSCategoryButton= child
		cs_categ_button.pressed.connect(_on_cs_category_button_pressed)

#### SIGNAL RESPONSES ####
func _on_cs_category_button_pressed() -> void:
	cs_category_selected.emit()

func _on_cs_selected(cs_data: CombatSkillData) -> void:
	display()
	tween.tween_callback(func():
		Events.combat_skill_selected.emit(cs_data)
	)

func _on_player_statistics_stat_changed(stat: Stat) -> void:
	_set_stat_label_text(stat)
