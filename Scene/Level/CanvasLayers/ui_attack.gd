extends CanvasLayer
class_name UI_Attack

@onready var sub_viewport: SubViewport = $SubViewport
@onready var page: Node2D = $Page
@onready var sprite_2d: Sprite2D = $Page/Sprite2D


var previous_interface: AttaqueChoiceInterface
var next_scene: AttaqueChoiceInterface

var tween: Tween

#### BUILT-IN ####

func _ready() -> void:
	Events.AttackChoice_attack_choice_made.connect(_on_Events_AttackChoice_attack_choice_made)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		pass

#### LOGIC ####
func _reset_page() -> void:
	page.scale.y = 1.0
	page.skew = 0.0
	page.visible = true

func _load_new_interface(interface: AttaqueChoiceInterface, dict_button) -> void:
	add_child(interface)
	move_child(interface, 0)
	interface._create_button(dict_button)

func _update_sub_viewport(interface: AttaqueChoiceInterface) -> void:
	remove_child(interface)
	sub_viewport.add_child(interface)

func _tween_page_to_midway(to_left:= true) -> void:
	if tween: tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(page, "skew", -PI/2 * float(to_left) , 0.5)
	tween.parallel().tween_property(sprite_2d.material, "shader_parameter/wave_strength", 0.40, 0.25)

func _update_midway_page(open_to_left:= true) -> void:
	page.scale.y *= -1.0
	page.skew = PI/2 * float(open_to_left)

func _update_midway_sub_viewport(new_interface: AttaqueChoiceInterface) -> void:
	previous_interface = sub_viewport.get_child(0)
	sub_viewport.get_child(0).queue_free()
	sub_viewport.add_child(new_interface)

func _tween_page_to_end() -> void:
	if tween: tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(page, "skew", 0.0, 0.5)
	tween.parallel().tween_property(sprite_2d.material, "shader_parameter/wave_strength", 0.0, 0.25)

#### Signal Responses ####

func _on_Events_AttackChoice_attack_choice_made(attack_interface: AttaqueChoice, dict_button: Dictionary) -> void:
	_reset_page()
	var spell_interface: SpellChoiceInterface = preload("res://Ui/BookInterface/AttackChoiceInterface/SpellChoice/spell_choice.tscn").instantiate()
	_load_new_interface(spell_interface, dict_button)
	get_child(0).v_box_container_left.get_child(0).grab_focus()
	_update_sub_viewport(attack_interface)
	_tween_page_to_midway()
	
	tween.tween_callback(func():
		_update_midway_page()
		var void_interface: AttaqueChoiceInterface  = preload("res://Ui/BookInterface/AttackChoiceInterface/attack_choice_interface.tscn").instantiate()
		_update_midway_sub_viewport(void_interface)
		_tween_page_to_end()
		)
