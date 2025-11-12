shader_type canvas_item;

uniform vec4 color_a : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color_b : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform float speed = 1.0;
uniform float scale = 0.01;

// Variable personnalisée pour stocker la position du sommet
varying vec2 local_pos;

void vertex() {
    local_pos = VERTEX; // on enregistre la position du vertex pour l'utiliser dans fragment()
}

void fragment() {
    float t = fract((local_pos.x * scale) + TIME * speed);
    COLOR = mix(color_a, color_b, t);
}
