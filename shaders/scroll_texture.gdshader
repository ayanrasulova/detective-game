shader_type canvas_item;

uniform float speed = 0.2;
uniform float gap : hint_range(0.0, 5.0) = 0.5;
varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec2 uv = UV;
	float cycle = 1.0 + gap;
	
	// Scale UVs so one full repeat covers [texture + gap]
	uv.x = mod(uv.x * cycle + TIME * speed, cycle);
	
	if (uv.x > 1.0) {
		COLOR = vec4(0.0); // Transparent gap
	} else {
		COLOR = texture(TEXTURE, uv) * modulate;
	}
}