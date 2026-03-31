extends Label

@onready var base_text: String= text


#### BUILT-IN ####
func _ready() -> void:
	Events.request_help.connect(_on_Events_request_help)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("hide_help"):
		visible = !visible

#### SIGNALS RESPONSES ####
func _on_Events_request_help(new_text: String, show_help: bool):
	if show_help: visible = true
	text = new_text + "\n" + "-".repeat(80) + "\n" + base_text
