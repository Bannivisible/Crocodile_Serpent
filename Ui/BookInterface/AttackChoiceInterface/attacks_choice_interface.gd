extends Control
class_name AttaqueChoiceInterface

@onready var h_box_container: HBoxContainer = $PanelContainer/MarginContainer/HBoxContainer/Panel2/HBoxContainer
@onready var v_box_container_left: VBoxContainer = h_box_container.get_child(0)
@onready var v_box_container_right: VBoxContainer = h_box_container.get_child(1)

@export var button_min_size:= Vector2(0.0, 125.0)

signal choice_button_made(button)

#### BUILT-IN ####
func _ready() -> void:
	choice_button_made.connect(_on_choice_button_made)
	
	if v_box_container_left.get_child_count() > 0:
		v_box_container_left.get_child(0).grab_focus()


#### LOGIC ####
func _create_button(dict: Dictionary) -> void:
	var button: Button
	
	for i in range(len(dict.choices_names)):
		button = Button.new()
		button.z_as_relative = false
		
		button.pressed.connect(_on_Button_pressed)
		
		_custome_button(dict, button, i)
		
		if i % 2 == 0:
			v_box_container_left.add_child(button)
		else:
			v_box_container_right.add_child(button)
	
	_set_buttons_focus_neighbor_v(v_box_container_left)
	_set_buttons_focus_neighbor_v(v_box_container_right)
	_set_buttons_focus_neighbor_h(v_box_container_left, v_box_container_right)

func _custome_button(dict: Dictionary, button: Button,i: int) -> void:
	button.name = dict.choices_names[i]
	button.text = dict.choices_text[i]
	button.custom_minimum_size = button_min_size
	
	if !dict.has("color"):
		return
	
	elif i > len(dict["color"]) - 1:
		i = len(dict["color"]) - 1
	
	button.add_theme_color_override("font_color", dict["color"][i])
	button.add_theme_color_override("font_pressed_color", dict["color"][i])
	button.add_theme_color_override("font_focus_color", dict["color"][i])
	button.add_theme_color_override("font_outline_color", dict["color"][i].inverted())

func _set_buttons_focus_neighbor_h(container1: Control, container2: Control) -> void:
	for i in range(len(container1.get_children())):
		if container2.get_child_count() <= i:
			container1.get_child(i).focus_neighbor_left = container2.get_child(i -1).get_path()
			
			continue
		
		container1.get_child(i).focus_neighbor_left = container2.get_child(i).get_path()
		container2.get_child(i).focus_neighbor_right = container1.get_child(i).get_path()

func _set_buttons_focus_neighbor_v(container: Control) -> void:
	container.get_child(0).focus_neighbor_top = container.get_child(-1).get_path()
	container.get_child(-1).focus_neighbor_bottom = container.get_child(0).get_path()

func find_button_pressed() -> Button:
	for i in range(len(h_box_container.get_children())):
		for button: Button in h_box_container.get_child(i).get_children():
			if button.button_pressed:
				return button
	return

#### SIGNAL RESPONSES ####
func _on_Button_pressed() -> void:
	var button = find_button_pressed()
	
	choice_button_made.emit(button)

func _on_choice_button_made(_button: Button) -> void:
	pass
