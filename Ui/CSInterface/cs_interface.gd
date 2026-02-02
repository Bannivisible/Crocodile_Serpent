extends Control
class_name CSInterface

@onready var data_manager: CSInterfacceDataManager = $CSInterfaceDataManager

@export var show_animation_ease: Tween.EaseType
@export var show_animation_trans: Tween.TransitionType

@export var tab_first_buttons: Array[Button]
var last_buttons_focus: Array[Button]


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
	
	elif Input.is_action_just_pressed("cancel"):
		cancel.emit()
		return_page()
	
	elif Input.is_action_just_pressed("special"):
		turn_page()


#### LOGIC ####
func display() -> void:
	if tween: tween.kill()
	var to = -size.y if on_screen else 0.0
	on_screen = !on_screen
	
	tween = create_tween().set_ease(show_animation_ease).set_trans(show_animation_trans)
	tween.tween_property(self, "position:y", to, SHOW_ANIMATION_DURATION)
	tween.tween_callback(func():on_screen_animation_finished.emit())


func turn_page() -> void:
	if %DoublePageTabContainer.get_child_count() - 1 == %DoublePageTabContainer.current_tab: return
	if not on_screen: return
	
	$AnimationPlayer.play("TurnPage")


func return_page() -> void:
	if %DoublePageTabContainer.current_tab == 0: return
	if not on_screen: return
	
	$AnimationPlayer.play("ReturnPage")


func _anime_turn_page() -> void:
	var double_page_tab_container: TabContainer = %DoublePageTabContainer
	var tab1_node: Control= double_page_tab_container.get_child(double_page_tab_container.current_tab).duplicate()
	var tab2_node: Control= double_page_tab_container.get_child(double_page_tab_container.current_tab + 1).duplicate()
	
	double_page_tab_container.current_tab += 1
	tab2_node.visible = true
	
	tab1_node.set_anchors_preset(Control.PRESET_FULL_RECT)
	tab2_node.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	Utiles.remove_all_child(%SubViewControl1)
	Utiles.remove_all_child(%SubViewControl2)
	
	%SubViewControl1.add_child(tab1_node)
	%SubViewControl2.add_child(tab2_node)


func _anime_return_page() -> void:
	var double_page_tab_container: TabContainer = %DoublePageTabContainer
	var tab1_node: Control= double_page_tab_container.get_child(double_page_tab_container.current_tab).duplicate()
	var tab2_node: Control= double_page_tab_container.get_child(double_page_tab_container.current_tab - 1).duplicate()
	
	double_page_tab_container.current_tab -= 1
	tab2_node.visible = true
	
	tab1_node.set_anchors_preset(Control.PRESET_FULL_RECT)
	tab2_node.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	Utiles.remove_all_child(%SubViewControl1)
	Utiles.remove_all_child(%SubViewControl2)
	
	%SubViewControl1.add_child(tab2_node)
	%SubViewControl2.add_child(tab1_node)


func _emit_event_cs_selected_signal(cs_data) -> void:
	Events.combat_skill_selected.emit(cs_data)


func _last_button_focus_grab_focus() -> void:
	var tab: int= %DoublePageTabContainer.current_tab
	
	if last_buttons_focus.size() - 1 == tab:
		last_buttons_focus[tab].grab_focus()
	else :
		tab_first_buttons[tab].grab_focus()


func _last_button_focus_release_focus() -> void:
	var tab: int= %DoublePageTabContainer.current_tab
	
	if last_buttons_focus.size() - 1 == tab:
		last_buttons_focus[tab].release_focus()
	else :
		tab_first_buttons[tab].release_focus()

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


func _on_double_page_tab_container_tab_changed(_tab: int) -> void:
	#_last_button_focus_grab_focus()
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name.ends_with("Page"):
		_last_button_focus_grab_focus()
