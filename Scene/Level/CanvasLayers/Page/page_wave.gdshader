shader_type canvas_item;

uniform float wave_strength: hint_range(0.0, 0.5, 0.01) = 0.25;
uniform float wave_direction: hint_range(0.0, 10.0, 0.1) = 5.0;
uniform float wave_speed: hint_range(0.0, 10.0, 0.1) = 5.0;

void fragment(){
	vec2 uv = UV;
	uv.y += sin(uv.x * wave_direction + TIME * wave_speed) * wave_strength * uv.x * 0.5 ;
	vec4 texture_color = texture(TEXTURE, uv);
	
	COLOR = texture_color;
}