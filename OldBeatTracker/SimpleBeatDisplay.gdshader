shader_type canvas_item;

uniform float t: hint_range(0.0, 1.0, 0.1);
uniform float edge: hint_range(0.0, 0.5, 0.05);
uniform float edge_offset: hint_range(-0.5, 0.5, 0.05);
varying vec4 colour;
void vertex() {
	colour = COLOR;
}

void fragment() {
	// passing in a float from 0 to 1, compare against UV.y
	float t_ = step(1.0 - UV.y, t);
	float cutoff = step(UV.y + edge_offset, edge) + 1.0 - step(UV.y + edge_offset, 1.0 - edge);
	COLOR = colour * (t_) + vec4(0,0,0,1) * (1.0 - t_);
	COLOR = COLOR * (1.0 - cutoff) + vec4(0,0,0,1) * (cutoff);
}
