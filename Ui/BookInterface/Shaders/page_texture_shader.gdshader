shader_type canvas_item;

uniform sampler2D noise;
uniform float mix_amount: hint_range(0.0, 0.1, 0.001) = 0.05;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if (texture_color.a == 0.0){
		discard;
	}
	
	vec4 noise_color = texture(noise, UV);
	COLOR = mix(texture_color, noise_color, mix_amount);
}