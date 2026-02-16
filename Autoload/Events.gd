extends Node

@warning_ignore("unused_signal")
signal cs_interface_on_screen_changed(on_screen: bool)

@warning_ignore("unused_signal")
signal combat_skill_selected(cs_data: CombatSkillData)


@warning_ignore("unused_signal")
signal request_spawn_object(node: Node2D)

@warning_ignore("unused_signal")
signal object_dispawn(node: Node2D)
