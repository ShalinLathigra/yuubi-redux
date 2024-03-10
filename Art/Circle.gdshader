shader_type canvas_item;

uniform float edge: hint_range(0.0, 1.0, 0.01);

varying vec4 color;
void vertex() {
	color = COLOR;
	// Called for every vertex the material is visible on.
}
void fragment() {
	float x = UV.x - 0.5;
	float y = UV.y - 0.5;
	float cutoff = step(x*x + y*y, edge / 4.0);
	COLOR = color * cutoff;
	// Called for every pixel the material is visible on.
}