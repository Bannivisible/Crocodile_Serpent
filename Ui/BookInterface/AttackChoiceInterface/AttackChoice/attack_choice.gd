extends AttaqueChoiceInterface
class_name AttaqueChoice

var spells_dict: Dictionary ={
	water_spells_buttons_dict = {
	choices_names = ["Flood", "Typhoon", "Siphon", "Water cannon"],
	choices_text = ["Deluge","Typhon","Siphon","Canon à eau"],
	color = [Color(0.114, 0.192, 0.808, 1.0)]
	},
	
	fire_spells_buttons_dict = {
	choices_names = ["Fireball", "Flamethrower", "Flaming Explosion"],
	choices_text = ["Boule de feu","Lance flamme","Explosion flamboyante"],
	color = [Color(0.647, 0.18, 0.133, 1.0)]
	},
	
	wind_spells_buttons_dict = {
	choices_names = ["Tornado", "Gust", "Hurricane"],
	choices_text = ["Tornade","Bourasque","Ouragan"],
	color = [Color(0.24, 0.667, 0.357, 1.0)]
	},
	
	electricity_spells_buttons_dict = {
	choices_names = ["Lightning","Thunder","Spark"],
	choices_text = ["Éclair","Foudre","Étincelle"],
	color = [Color(0.779, 0.735, 0.118, 1.0)]
	},
	
	ice_spells_buttons_dict = {
	choices_names = ["Blizzard", "Hail"],
	choices_text = ["Blizzard","Grêle"],
	color = [Color(0.477, 0.53, 0.814, 1.0)]
	}
}

var attack_choice_array: Dictionary ={
	choices_names = ["Water", "Fire", "Wind", "Electricity", "Ice"],
	choices_text = ["Eau", "Feu", "Vent", "Electricité", "Glace"],
	color = [spells_dict.water_spells_buttons_dict["color"][0], spells_dict.fire_spells_buttons_dict["color"][0], 
	spells_dict.wind_spells_buttons_dict["color"][0], spells_dict.electricity_spells_buttons_dict["color"][0],
	spells_dict.ice_spells_buttons_dict["color"][0]]
	}


func _ready() -> void:
	_create_button(attack_choice_array)
	
	super._ready()

func _on_choice_button_made(button: Button) -> void:
	var dict_name = spells_dict[button.name.to_lower() + "_spells_buttons_dict"]
	
	Events.AttackChoice_attack_choice_made.emit(self, dict_name)
