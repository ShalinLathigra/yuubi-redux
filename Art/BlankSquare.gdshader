shader_type canvas_item;

varying vec4 color;
void vertex() {
	color = COLOR;
	// Called for every vertex the material is visible on.
}
void fragment() {
	COLOR = color;
	// Called for every pixel the material is visible on.
}