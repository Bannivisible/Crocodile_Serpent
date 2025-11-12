shader_type canvas_item;

uniform float speed: hint_range(0.0, 10.0, 0.1) =  0.5;
uniform vec4 color1: source_color;
uniform vec4 color2: source_color;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV * sin(TIME));
	float mix_amount = (UV.x + UV.y) * 2.0;
	float t = fract((POINT_COORD.x * 0.01) + TIME * speed);
	vec4 gradient_color = mix(color1, color2, t);
	
	COLOR = gradient_color;
}

